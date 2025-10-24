CLASS lhc_consideration DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_consideration
      IMPORTING dto                TYPE zif_re_revenuestream=>ts_consideration
                consideration_link TYPE zif_re_revenuestream=>tt_link
                state_area         TYPE string
                exists             TYPE boolean OPTIONAL
      CHANGING  failed             TYPE zif_re_revenuestream=>tt_failed
                reported           TYPE zif_re_revenuestream=>tt_reported.

    METHODS chargeableTime FOR VALIDATE ON SAVE
      IMPORTING keys FOR Consideration~chargeableTime.

    METHODS validityrange FOR VALIDATE ON SAVE
      IMPORTING keys FOR Consideration~validityrange.
    METHODS validentryexists FOR VALIDATE ON SAVE
      IMPORTING keys FOR Consideration~validentryexists.

ENDCLASS.

CLASS lhc_consideration IMPLEMENTATION.

  METHOD validate_consideration.

    APPEND VALUE #( %tky             = dto-%tky
                    %state_area      = state_area
                    %path            = VALUE #( header-%tky = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                item-%tky   = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                    %element-Endtime = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-chargeable THEN if_abap_behv=>mk-off )
                    %element-Validfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validexists THEN if_abap_behv=>mk-off )
                    %element-Validto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity
                                                OR state_area EQ zif_re_revenuestream=>state_area-validexists
                                                THEN if_abap_behv=>mk-off ) ) TO reported-consideration.

    CASE state_area.
      WHEN zif_re_revenuestream=>state_area-chargeable.
        IF dto-Starttime GT dto-Endtime.
          DATA(e) = abap_true.
          DATA(msg) = zif_re_revenuestream=>message_v-valuerange.
        ENDIF.
      WHEN zif_re_revenuestream=>state_area-validity.
        IF dto-Validfrom GT dto-Validto.
          e = abap_true.
          msg = zif_re_revenuestream=>message_v-valuerange.
        ENDIF.
      WHEN zif_re_revenuestream=>state_area-validexists.
        IF exists EQ abap_true.
          e = abap_true.
          msg = 'Overlapping period is not allowed'.
        ENDIF.
    ENDCASE.

    IF e EQ abap_true.
      APPEND VALUE #( %tky = dto-%tky ) TO failed-consideration.

      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = state_area
                      %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                      number   = zif_re_revenuestream=>msgcommon
                                                      severity = if_abap_behv_message=>severity-error
                                                      v1       = msg )
                      %path            = VALUE #( header-%tky = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                  item-%tky   = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                      %element-Endtime = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-chargeable THEN if_abap_behv=>mk-on )
                      %element-Validfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validexists THEN if_abap_behv=>mk-on )
                      %element-Validto   = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity
                                                    OR state_area EQ zif_re_revenuestream=>state_area-validexists
                                                    THEN if_abap_behv=>mk-on ) ) TO reported-consideration.
    ENDIF.
  ENDMETHOD.

  METHOD chargeableTime.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    LOOP AT considerations INTO DATA(dto).
      validate_consideration( EXPORTING dto = dto
                                        consideration_link = consideration_link
                                        state_area = zif_re_revenuestream=>state_area-chargeable
                              CHANGING  failed = failed
                                        reported = reported ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validityrange.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    LOOP AT considerations INTO DATA(dto).
      validate_consideration( EXPORTING dto = dto
                                        consideration_link = consideration_link
                                        state_area = zif_re_revenuestream=>state_area-validity
                              CHANGING  failed = failed
                                        reported = reported ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validentryexists.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    SORT considerations BY Validfrom.

    LOOP AT keys INTO DATA(key).
      ASSIGN considerations[ Cnsderationuuid = key-Cnsderationuuid ]
      TO FIELD-SYMBOL(<dto>).
      IF sy-subrc EQ 0.

        LOOP AT considerations INTO DATA(data)
        WHERE Cnsderationuuid NE key-Cnsderationuuid.
          IF <dto>-Validfrom LE data-Validto
          AND <dto>-Validto GE data-Validfrom.
            DATA(exists) = abap_true.
          ENDIF.

          validate_consideration( EXPORTING dto = <dto>
                                            consideration_link = consideration_link
                                            state_area = zif_re_revenuestream=>state_area-validexists
                                            exists = exists
                                  CHANGING  failed = failed
                                            reported = reported ).
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_roundoff DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS roundoff_reported
      IMPORTING dto        TYPE zif_re_revenuestream=>ts_roundoff
                state_area TYPE string
                msgv1      TYPE sy-msgv1
      CHANGING  failed     TYPE zif_re_revenuestream=>tt_failed
                reported   TYPE zif_re_revenuestream=>tt_reported.

    METHODS roundoffRange FOR VALIDATE ON SAVE
      IMPORTING keys FOR Roundoff~roundoffRange.
    METHODS sequencekey FOR VALIDATE ON SAVE
      IMPORTING keys FOR Roundoff~sequencekey.

ENDCLASS.

CLASS lhc_roundoff IMPLEMENTATION.

  METHOD roundoff_reported.
    APPEND VALUE #( %tky             = dto-%tky
                    %state_area      = state_area
                    %path            = VALUE #( header-%tky = CORRESPONDING #( dto-%tky )
                                                item-%tky   = CORRESPONDING #( dto-%tky ) )
                    %element-Roundto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-roundoff
                                               THEN if_abap_behv=>mk-off )
                    %element-Rndsequence = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-roundoffseq
                                               THEN if_abap_behv=>mk-off ) ) TO reported-roundoff.

    CASE state_area.
      WHEN zif_re_revenuestream=>state_area-roundoff.
        IF dto-Roundfrom GT dto-Roundto.
          DATA(e) = abap_true.
        ENDIF.
      WHEN zif_re_revenuestream=>state_area-roundoffseq.
        e = abap_true.
    ENDCASE.

    IF e EQ abap_true.
      APPEND VALUE #( %tky = dto-%tky ) TO failed-roundoff.
      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = state_area
                      %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                      number   = zif_re_revenuestream=>msgcommon
                                                      severity = if_abap_behv_message=>severity-error
                                                      v1       = msgv1 )
                      %path            = VALUE #( header-%tky = CORRESPONDING #( dto-%tky )
                                                  item-%tky   = CORRESPONDING #( dto-%tky ) )
                      %element-Roundto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-roundoff
                                               THEN if_abap_behv=>mk-on )
                      %element-Rndsequence = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-roundoffseq
                                               THEN if_abap_behv=>mk-on ) ) TO reported-roundoff.
    ENDIF.
  ENDMETHOD.

  METHOD roundoffRange.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Round
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(roundoff)
    LINK DATA(roundoff_link).

    LOOP AT roundoff INTO DATA(dto)
    WHERE Roundfrom IS NOT INITIAL
       OR Roundto IS NOT INITIAL.

      DATA(msgv1) = |{ zif_re_revenuestream=>message_v-valuerange } : Sequence { dto-Rndsequence }|.
      roundoff_reported( EXPORTING dto = dto
                                   state_area = zif_re_revenuestream=>state_area-roundoff
                                   msgv1 = CONV #( msgv1 )
                         CHANGING  failed = failed
                                   reported = reported ).
      CLEAR: msgv1.
    ENDLOOP.

  ENDMETHOD.

  METHOD sequencekey.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Round
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(roundoff)
    LINK DATA(roundoff_link).

    LOOP AT keys INTO DATA(key).
      ASSIGN roundoff[ Roundoffuuid = key-Roundoffuuid ]
      TO FIELD-SYMBOL(<dto>).
      IF sy-subrc EQ 0.
        LOOP AT roundoff INTO DATA(dto)
        WHERE Roundoffuuid NE key-Roundoffuuid.

          IF dto-Rndsequence EQ <dto>-Rndsequence.
            DATA(msgv1) = |Sequence { <dto>-Rndsequence } already exists.|.
            roundoff_reported( EXPORTING dto = <dto>
                                         state_area = zif_re_revenuestream=>state_area-roundoffseq
                                         msgv1 = CONV #( msgv1 )
                               CHANGING  failed = failed
                                         reported = reported ).
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.
    METHODS setdefaultitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR header~setdefaultitem.
    METHODS revenuekey FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~revenuekey.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setDefaultitem.

    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Header
    FIELDS ( Streamuuid ) WITH CORRESPONDING #( keys )
    RESULT DATA(header)
    ENTITY Header BY \_Item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(items).

    IF items IS INITIAL.
      SELECT FROM ZI__RE_FlightNature_VH
      FIELDS *
      INTO TABLE @DATA(natureOfFlight).
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
        ENTITY Header
        CREATE BY \_Item
        AUTO FILL CID WITH VALUE #( FOR n IN natureOfFlight
                                      ( %tky = header[ 1 ]-%tky
                                        %target = VALUE #( (
                                                   %is_draft = header[ 1 ]-%is_draft
                                                   %data-Nature = n-nature
                                                   %control-Nature = cl_abap_behv=>flag_changed ) ) ) )
        MAPPED DATA(item_mapped)
        FAILED DATA(item_failed)
        REPORTED DATA(item_reported).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD revenuekey.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Header
    FIELDS ( Streamuuid CompanyCode Code )
    WITH CORRESPONDING #( keys )
    RESULT DATA(header).

    LOOP AT header INTO DATA(dto).

      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = zif_re_revenuestream=>state_area-header ) TO reported-header.

      IF dto-CompanyCode IS INITIAL
      OR dto-Code IS INITIAL.
        APPEND VALUE #( %tky = dto-%tky ) TO failed-header.

        APPEND VALUE #( %tky             = dto-%tky
                        %state_area      = zif_re_revenuestream=>state_area-header
                        %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                        number   = zif_re_revenuestream=>msgrequi
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-CompanyCode = COND #( WHEN dto-CompanyCode IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Code        = COND #( WHEN dto-Code IS INITIAL THEN if_abap_behv=>mk-on ) ) TO reported-header.
      ELSE.
        SELECT SINGLE FROM ZI_RE_RevenueStreamTP_M
        FIELDS @abap_true
        WHERE CompanyCode EQ @dto-CompanyCode
          AND Code EQ @dto-Code
        INTO @DATA(is_true).

        IF is_true EQ abap_true.
          APPEND VALUE #( %tky = dto-%tky ) TO failed-header.

          APPEND VALUE #( %tky             = dto-%tky
                          %state_area      = zif_re_revenuestream=>state_area-header
                          %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                          number   = zif_re_revenuestream=>msgcommon
                                                          severity = if_abap_behv_message=>severity-error
                                                          v1       = 'Company Code and Revenue Stream already exists.' )
                          %element-CompanyCode = COND #( WHEN dto-CompanyCode IS NOT INITIAL THEN if_abap_behv=>mk-on )
                          %element-Code        = COND #( WHEN dto-Code IS NOT INITIAL THEN if_abap_behv=>mk-on ) ) TO reported-header.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
