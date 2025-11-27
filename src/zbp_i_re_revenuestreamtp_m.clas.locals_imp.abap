CLASS lsc_zi_re_revenuestreamtp_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_re_revenuestreamtp_m IMPLEMENTATION.

  METHOD save_modified.
    DATA: headerkeys TYPE TABLE FOR KEY OF zi_re_revenuestreamtp_m\\Header.

    IF create-header IS NOT INITIAL.
      LOOP AT create-header INTO DATA(h).
        APPEND VALUE #( streamuuid = h-Streamuuid ) TO headerkeys.
      ENDLOOP.
    ENDIF.

    IF update-header IS NOT INITIAL.
      LOOP AT update-header INTO DATA(u).
        APPEND VALUE #( streamuuid = u-Streamuuid ) TO headerkeys.
      ENDLOOP.
    ENDIF.

    IF delete-header IS NOT INITIAL.
      LOOP AT delete-header INTO DATA(d).
        APPEND VALUE #( streamuuid = d-Streamuuid ) TO headerkeys.
      ENDLOOP.
    ENDIF.

    CHECK headerkeys IS NOT INITIAL.

    SORT headerkeys BY Streamuuid.
    DELETE ADJACENT DUPLICATES FROM headerkeys COMPARING Streamuuid.

    DATA(operation) = NEW zcl_re_bgpf_revenuestream( keys = CORRESPONDING #( headerkeys ) ).

    TRY.
      DATA(process_factory) = cl_bgmc_process_factory=>get_default( ).

      DATA(process) = process_factory->create( ).

      process->set_name( 'AERO_CUTE_PROCESS'
           )->set_operation( operation ).

      process->save_for_execution( ).

      CATCH cx_bgmc INTO DATA(ebgmc).
        DATA(ebgmcText) = ebgmc->get_longtext( ).

    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_consideration DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_consideration
      IMPORTING dto                TYPE zif_re_revenuestream=>ts_consideration
                consideration_link TYPE zif_re_revenuestream=>tt_link
                state_area         TYPE string
                msgv1              TYPE sy-msgv1
                e                  TYPE boolean
      CHANGING  failed             TYPE zif_re_revenuestream=>tt_failed
                reported           TYPE zif_re_revenuestream=>tt_reported.

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

    IF e EQ abap_true.
      APPEND VALUE #( %tky = dto-%tky ) TO failed-consideration.

      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = state_area
                      %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                      number   = zif_re_revenuestream=>msgcommon
                                                      severity = if_abap_behv_message=>severity-error
                                                      v1       = msgv1 )
                      %path            = VALUE #( header-%tky = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                  item-%tky   = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                      %element-Endtime = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-chargeable THEN if_abap_behv=>mk-on )
                      %element-Validfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validexists THEN if_abap_behv=>mk-on )
                      %element-Validto   = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity
                                                    OR state_area EQ zif_re_revenuestream=>state_area-validexists
                                                    THEN if_abap_behv=>mk-on ) ) TO reported-consideration.
    ENDIF.
  ENDMETHOD.


  METHOD validityrange.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item
    FIELDS ( Streamuuid Streamitemuuid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    LOOP AT item INTO DATA(i).
      LOOP AT considerations INTO DATA(dto)
        WHERE Streamitemuuid EQ i-Streamitemuuid.
        DATA(e) = COND #( WHEN dto-Validfrom GT dto-Validto THEN abap_true ELSE abap_false ).

        validate_consideration( EXPORTING dto = dto
                                          consideration_link = consideration_link
                                          state_area = zif_re_revenuestream=>state_area-validity
                                          msgv1 = zif_re_revenuestream=>message_v-valuerange
                                          e = e
                                CHANGING  failed = failed
                                          reported = reported ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD validentryexists.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item
    FIELDS ( Streamuuid Streamitemuuid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    SORT considerations BY Validfrom.

    LOOP AT item INTO DATA(i).
      DATA(tmp_consi) = considerations.
      DELETE tmp_consi WHERE Streamitemuuid NE i-Streamitemuuid.
      LOOP AT considerations INTO DATA(data)
      WHERE Streamitemuuid EQ i-Streamitemuuid.

        LOOP AT tmp_consi INTO DATA(data_2)
        WHERE Cnsderationuuid NE data-Cnsderationuuid.
          IF data-Validfrom LE data_2-Validto
          AND data-Validto GE data_2-Validfrom.
            DATA(e) = abap_true.
          ENDIF.
        ENDLOOP.

        validate_consideration( EXPORTING dto = data
                                          consideration_link = consideration_link
                                          state_area = zif_re_revenuestream=>state_area-validexists
                                          msgv1 = 'Overlapping period is not allowed'
                                          e = e
                                CHANGING  failed = failed
                                          reported = reported ).
      ENDLOOP.
*      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_roundoff DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS roundoff_reported
      IMPORTING dto        TYPE zif_re_revenuestream=>ts_roundoff
                state_area TYPE string
                msgv1      TYPE sy-msgv1
                e          TYPE boolean
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
    ENTITY Item
    FIELDS ( Streamuuid Streamitemuuid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    ENTITY Item BY \_Round
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(roundoff)
    LINK DATA(roundoff_link).

    LOOP AT item INTO DATA(i).
      LOOP AT roundoff INTO DATA(dto)
      WHERE Streamitemuuid EQ i-Streamitemuuid
        AND ( Roundfrom IS NOT INITIAL
         OR Roundto IS NOT INITIAL ).

        DATA(msgv1) = |{ zif_re_revenuestream=>message_v-valuerange } : Sequence { dto-Rndsequence }|.
        DATA(e) = COND #( WHEN dto-Roundfrom GT dto-Roundto THEN abap_true ELSE abap_false ).
        roundoff_reported( EXPORTING dto = dto
                                     state_area = zif_re_revenuestream=>state_area-roundoff
                                     msgv1 = CONV #( msgv1 )
                                     e = e
                           CHANGING  failed = failed
                                     reported = reported ).
        CLEAR: msgv1.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD sequencekey.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item
    FIELDS ( Streamuuid Streamitemuuid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    ENTITY Item BY \_Round
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(roundoff)
    LINK DATA(roundoff_link).

    LOOP AT item INTO DATA(i).
        DATA(temp_round) = roundoff.
        DELETE temp_round WHERE Streamitemuuid NE i-Streamitemuuid.
        LOOP AT roundoff INTO DATA(dto)
        WHERE Streamitemuuid EQ i-Streamitemuuid.

          LOOP AT temp_round INTO DATA(dto_2)
          WHERE Roundoffuuid NE dto-Roundoffuuid
            AND Rndsequence EQ dto-Rndsequence .
            DATA(e) = abap_True.
          ENDLOOP.

          DATA(msgv1) = |Sequence { dto-Rndsequence } already exists.|.
          roundoff_reported( EXPORTING dto = dto
                                       state_area = zif_re_revenuestream=>state_area-roundoffseq
                                       msgv1 = CONV #( msgv1 )
                                       e = e
                             CHANGING  failed = failed
                                       reported = reported ).

        ENDLOOP.
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
                      %state_area      = zif_re_revenuestream=>state_area-header
                      %element-CompanyCode = if_abap_behv=>mk-off
                      %element-Code = if_abap_behv=>mk-off ) TO reported-header.

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
