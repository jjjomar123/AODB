CLASS lhc_consideration DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    TYPES: tt_consieration_key TYPE TABLE FOR KEY OF zi_re_revenuestreamtp_m\\consideration,
           tt_reported TYPE RESPONSE FOR REPORTED LATE zi_re_revenuestreamtp_m,
           tt_failed TYPE RESPONSE FOR FAILED LATE zi_re_revenuestreamtp_m,
           tt_consideration_data TYPE TABLE FOR READ RESULT zi_re_revenuestreamtp_m\\item\_consideration,
           tt_link TYPE TABLE FOR READ LINK zi_re_revenuestreamtp_m\\item\_consideration.

    METHODS validate_consideration
      IMPORTING considerations     TYPE tt_consideration_data
                consideration_link TYPE tt_link
                state_area         TYPE string
       CHANGING failed             TYPE tt_failed
                reported           TYPE tt_reported.

    METHODS chargeableTime FOR VALIDATE ON SAVE
      IMPORTING keys FOR Consideration~chargeableTime.

    METHODS validity FOR VALIDATE ON SAVE
      IMPORTING keys FOR Consideration~validity.

ENDCLASS.

CLASS lhc_consideration IMPLEMENTATION.

  METHOD validate_consideration.

    LOOP AT considerations INTO DATA(dto).
      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = state_area
                      %path            = VALUE #( header-%tky = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                  item-%tky   = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                      %element-Endtime = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-chargeable THEN if_abap_behv=>mk-off )
                      %element-Validto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity THEN if_abap_behv=>mk-off ) ) TO reported-consideration.

      IF state_area EQ zif_re_revenuestream=>state_area-chargeable.
        IF dto-Starttime GT dto-Endtime.
          DATA(e) = abap_true.
        ENDIF.
      ELSEIF state_area EQ zif_re_revenuestream=>state_area-validity.
        IF dto-Validfrom GT dto-Validto.
          e = abap_true.
        ENDIF.
      ENDIF.

      IF e EQ abap_true.
        APPEND VALUE #( %tky = dto-%tky ) TO failed-consideration.

        APPEND VALUE #( %tky             = dto-%tky
                        %state_area      = state_area
                        %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                        number   = zif_re_revenuestream=>msgno
                                                        severity = if_abap_behv_message=>severity-error
                                                        v1       = 'Invalid value range' )
                        %path            = VALUE #( header-%tky = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                    item-%tky   = consideration_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                        %element-Endtime = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-chargeable THEN if_abap_behv=>mk-on )
                        %element-Validto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity THEN if_abap_behv=>mk-on ) ) TO reported-consideration.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD chargeableTime.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    validate_consideration( EXPORTING considerations = considerations
                                      consideration_link = consideration_link
                                      state_area = zif_re_revenuestream=>state_area-chargeable
                            CHANGING  failed = failed
                                      reported = reported ).
  ENDMETHOD.

  METHOD validity.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Consideration
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(considerations)
    LINK DATA(consideration_link).

    validate_consideration( EXPORTING considerations = considerations
                                      consideration_link = consideration_link
                                      state_area = zif_re_revenuestream=>state_area-validity
                            CHANGING  failed = failed
                                      reported = reported ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_roundoff DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS roundoffRange FOR VALIDATE ON SAVE
      IMPORTING keys FOR Roundoff~roundoffRange.

ENDCLASS.

CLASS lhc_roundoff IMPLEMENTATION.

  METHOD roundoffRange.
    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
    ENTITY Item BY \_Round
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(roundoff)
    LINK DATA(roundoff_link).

    LOOP AT roundoff INTO DATA(dto)
    WHERE Roundfrom IS NOT INITIAL
       OR Roundto IS NOT INITIAL.


      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = zif_re_revenuestream=>state_area-roundoff
                      %path            = VALUE #( header-%tky = roundoff_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                  item-%tky   = roundoff_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                      %element-Roundto = if_abap_behv=>mk-off ) TO reported-roundoff.

      IF dto-Roundfrom GT dto-Roundto.
        APPEND VALUE #( %tky = dto-%tky ) TO failed-roundoff.

        APPEND VALUE #( %tky             = dto-%tky
                        %state_area      = zif_re_revenuestream=>state_area-roundoff
                        %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                        number   = zif_re_revenuestream=>msgno
                                                        severity = if_abap_behv_message=>severity-error
                                                        v1       = 'Invalid value range' )
                        %path            = VALUE #( header-%tky = roundoff_link[ KEY id  source-%tky = dto-%tky ]-target-%tky
                                                    item-%tky   = roundoff_link[ KEY id  source-%tky = dto-%tky ]-target-%tky )
                        %element-Roundto = if_abap_behv=>mk-on ) TO reported-roundoff.
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

*  METHOD setConsierationStatus.
*
*    READ ENTITIES OF ZI_RE_RevenueStreamTP_M IN LOCAL MODE
*    ENTITY Header BY \_Item
*    FIELDS ( Streamuuid Streamitemuuid ) WITH CORRESPONDING #( keys )
*    RESULT DATA(items)
*    ENTITY Item BY \_Consideration
*    FIELDS ( Status ) WITH CORRESPONDING #( keys )
*    RESULT DATA(considerations).
*
*    DELETE considerations WHERE Locallastchangedat IS INITIAL.
*    IF considerations IS NOT INITIAL.
*      SORT considerations BY Validto DESCENDING.
*      LOOP AT considerations ASSIGNING FIELD-SYMBOL(<is_active>).
*        IF sy-tabix EQ 1.
*          <is_active>-Status = abap_true.
*        ELSE.
*          <is_active>-Status = abap_false.
*        ENDIF.
*      ENDLOOP.
*
*      MODIFY ENTITIES OF ZI_RE_RevenueStreamTP_M
*      ENTITY Consideration
*      UPDATE FIELDS ( Status )
*      WITH VALUE #( FOR dto IN considerations (
*                      %tky = dto-%tky
*                      Status = dto-Status ) ).
*    ENDIF.
*  ENDMETHOD.

ENDCLASS.
