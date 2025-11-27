CLASS zcl_re_revenuestream_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_keys TYPE TABLE FOR KEY OF ZI_RE_RevenueStreamTP_M\\CalculationRule.

    CLASS-METHODS set_aerocute
      IMPORTING keys TYPE tt_keys.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_re_revenuestream_util IMPLEMENTATION.

  METHOD set_aerocute.
    DATA: deletecute TYPE TABLE FOR DELETE ZI_AerocuteMaster_S\\AerocuteMaster,
          createcute TYPE TABLE OF zre_aerocuterate. ""ZI_AerocuteMaster_S\\AerocuteMaster.

    READ ENTITIES OF ZI_RE_RevenueStreamTP_M
    ENTITY Header
    FIELDS ( Streamuuid Cute )
    WITH CORRESPONDING #( keys )
    RESULT DATA(header).

    IF header IS NOT INITIAL.
      DELETE header WHERE Cute EQ abap_false.
      IF header IS NOT INITIAL.

        SELECT FROM ZI_RE_RevenueStreamCALCRU_TP_M
        FIELDS *
        FOR ALL ENTRIES IN @header
        WHERE Streamuuid EQ @header-Streamuuid
        INTO TABLE @DATA(calcrules).

        CHECK calcrules IS NOT INITIAL.

        SELECT FROM ZI_AerocuteMaster
        FIELDS *
        FOR ALL ENTRIES IN @calcrules
        WHERE Streamuuid EQ @calcrules-Streamuuid
          AND Streamitemuuid EQ @calcrules-Streamitemuuid
        INTO TABLE @DATA(existing_cute).
        IF sy-subrc EQ 0.
*          "Delete if not exists from revenue stream
*          LOOP AT existing_cute INTO DATA(c).
*            IF NOT line_exists( calcrules[ Streamuuid = c-Streamuuid
*                                           Streamitemuuid = c-Streamitemuuid
*                                           Calcruleuuid = c-Calcruleuuid ] ).
*              APPEND VALUE #( %key = CORRESPONDING #( c ) ) TO deletecute.
*            ENDIF.
*          ENDLOOP.
*
*          IF deletecute IS NOT INITIAL.
*            MODIFY ENTITIES OF ZI_AerocuteMaster_S
*            ENTITY AerocuteMaster
*            DELETE FROM deletecute
*            FAILED DATA(failed)
*            REPORTED DATA(reported).
*          ENDIF.
        ENDIF.

        "Insert if not exists from cute
        LOOP AT calcrules INTO DATA(r).
          IF NOT line_exists( existing_cute[ Streamuuid = r-Streamuuid
                                             Streamitemuuid = r-Streamitemuuid
                                             Calcruleuuid = r-Calcruleuuid ] ).
            TRY.
                APPEND VALUE #( cuteuuid = cl_system_uuid=>create_uuid_x16_static(  )
                                streamuuid = r-streamuuid
                                streamitemuuid = r-streamitemuuid
                                calcruleuuid = r-calcruleuuid
                                cutesequence = 1 ) TO createcute.
              CATCH cx_uuid_error INTO DATA(euuid).
                DATA(euuidtext) = euuid->get_longtext(  ).
            ENDTRY.
          ENDIF.
        ENDLOOP.

        IF createcute IS NOT INITIAL.
          INSERT zre_aerocuterate FROM TABLE createcute.
          COMMIT WORK.
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
