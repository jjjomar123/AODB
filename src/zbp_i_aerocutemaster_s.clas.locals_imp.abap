CLASS lhc_rap_tdat_cts DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      get
        RETURNING
          VALUE(result) TYPE REF TO if_mbc_cp_rap_tdat_cts.

ENDCLASS.

CLASS lhc_rap_tdat_cts IMPLEMENTATION.
  METHOD get.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZAEROCUTEMASTER'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'AerocuteMaster' table = 'ZRE_AEROCUTERATE' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_aerocutemaster_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR AerocuteMasterAll
        RESULT    result,
      selectcustomizingtransptreq FOR MODIFY
        IMPORTING
                  keys   FOR ACTION AerocuteMasterAll~SelectCustomizingTransptReq
        RESULT    result,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR AerocuteMasterAll
        RESULT result.
ENDCLASS.

CLASS lhc_zi_aerocutemaster_s IMPLEMENTATION.
  METHOD get_instance_features.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMasterAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%is_draft = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %tky = all[ 1 ]-%tky
               %action-edit = edit_flag
               %assoc-_AerocuteMaster = edit_flag
               %action-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD selectcustomizingtransptreq.
    MODIFY ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
      ENTITY AerocuteMasterAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %tky               = key-%tky
                          TransportRequestID = key-%param-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
      ENTITY AerocuteMasterAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %tky   = entity-%tky
                          %param = entity ) ).
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_AEROCUTEMASTER' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = is_authorized.
    result-%action-Edit = is_authorized.
    result-%action-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS lsc_zi_aerocutemaster_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      save_modified REDEFINITION,
      cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zi_aerocutemaster_s IMPLEMENTATION.
  METHOD save_modified.
    READ TABLE update-AerocuteMasterAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD cleanup_finalize ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_aerocutemaster DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES: tt_failed   TYPE RESPONSE FOR FAILED LATE zi_aerocutemaster_s,
           tt_reported TYPE RESPONSE FOR REPORTED LATE zi_aerocutemaster_s,
           ts_cute     TYPE STRUCTURE FOR READ RESULT zi_aerocutemaster_s\\AerocuteMaster.

    METHODS validate_cute
      IMPORTING dto        TYPE ts_cute
                state_area TYPE string
                msgv1      TYPE sy-msgv1
                e          TYPE boolean
      CHANGING  failed     TYPE tt_failed
                reported   TYPE tt_reported.

    METHODS:
      validatetransportrequest FOR VALIDATE ON SAVE
        IMPORTING
          keys FOR AerocuteMaster~ValidateTransportRequest,
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR AerocuteMaster
        RESULT result,
      copyaerocutemaster FOR MODIFY
        IMPORTING
          keys FOR ACTION AerocuteMaster~CopyAerocuteMaster,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR AerocuteMaster
        RESULT result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR AerocuteMaster
        RESULT    result,

      validityrange FOR VALIDATE ON SAVE
        IMPORTING keys FOR AerocuteMaster~validityrange,
      countrange FOR VALIDATE ON SAVE
            IMPORTING keys FOR AerocuteMaster~countrange,
      mandatoryfield FOR VALIDATE ON SAVE
            IMPORTING keys FOR AerocuteMaster~mandatoryfield,
      valueexists FOR VALIDATE ON SAVE
            IMPORTING keys FOR AerocuteMaster~valueexists,
      overlapdate FOR VALIDATE ON SAVE
            IMPORTING keys FOR AerocuteMaster~overlapdate,
      overlapcount FOR VALIDATE ON SAVE
            IMPORTING keys FOR AerocuteMaster~overlapcount.
ENDCLASS.

CLASS lhc_zi_aerocutemaster IMPLEMENTATION.
  METHOD validatetransportrequest.
*    DATA change TYPE REQUEST FOR CHANGE ZI_AerocuteMaster_S.
*    SELECT SINGLE TransportRequestID
*      FROM ZRE_AEROCUTE_D_S
*      WHERE SingletonID = 1
*      INTO @DATA(TransportRequestID).
*    lhc_rap_tdat_cts=>get( )->validate_changes(
*                                transport_request = TransportRequestID
*                                table             = 'ZRE_AEROCUTERATE'
*                                keys              = REF #( keys )
*                                reported          = REF #( reported )
*                                failed            = REF #( failed )
*                                change            = REF #( change-AerocuteMaster ) ).
  ENDMETHOD.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.
  METHOD copyaerocutemaster.
    DATA new_AerocuteMaster TYPE TABLE FOR CREATE ZI_AerocuteMaster_S\_AerocuteMaster.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-AerocuteMaster = VALUE #( FOR fkey IN keys ( %tky = fkey-%tky ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
      ENTITY AerocuteMaster
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_AerocuteMaster)
      FAILED DATA(read_failed).

    LOOP AT ref_AerocuteMaster ASSIGNING FIELD-SYMBOL(<ref_AerocuteMaster>).
      DATA(key) = keys[ KEY draft %tky = <ref_AerocuteMaster>-%tky ].
      DATA(key_cid) = key-%cid.
      APPEND VALUE #(
        %tky-SingletonID = 1
        %is_draft = <ref_AerocuteMaster>-%is_draft
        %target = VALUE #( (
          %cid = key_cid
          %is_draft = <ref_AerocuteMaster>-%is_draft
          %data = CORRESPONDING #( <ref_AerocuteMaster> EXCEPT
            Cuteuuid
            LastChangedAt
            Locallastchangedat
            SingletonID
            Cutesequence
        ) ) )
      ) TO new_AerocuteMaster ASSIGNING FIELD-SYMBOL(<new_AerocuteMaster>).
    ENDLOOP.

    MODIFY ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
      ENTITY AerocuteMasterAll CREATE BY \_AerocuteMaster
      FIELDS (
               streamuuid
               streamitemuuid
               calcruleuuid
               companycode
               code
               nature
               calculationrule
               differingmeasurement
               Validto
               Validfrom
               Countfrom
               Countto
               Rate
             ) WITH new_AerocuteMaster
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-AerocuteMaster = mapped_create-AerocuteMaster.
    INSERT LINES OF read_failed-AerocuteMaster INTO TABLE failed-AerocuteMaster.

    IF failed-AerocuteMaster IS INITIAL.
      reported-AerocuteMaster = VALUE #( FOR created IN mapped-AerocuteMaster (
                                                 %cid = created-%cid
                                                 %action-CopyAerocuteMaster = if_abap_behv=>mk-on
                                                 %msg = mbc_cp_api=>message( )->get_item_copied( )
                                                 %path-AerocuteMasterAll-%is_draft = created-%is_draft
                                                 %path-AerocuteMasterAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_AEROCUTEMASTER' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%action-CopyAerocuteMaster = is_authorized.
  ENDMETHOD.
  METHOD get_instance_features.
    result = VALUE #( FOR row IN keys ( %tky = row-%tky
                                        %action-CopyAerocuteMaster = COND #( WHEN row-%is_draft = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.

  METHOD validate_cute.
    APPEND VALUE #( %tky             = dto-%tky
                    %state_area      = state_area
                    %path-AerocuteMasterAll-%is_draft = dto-%is_draft
                    %path-AerocuteMasterAll-SingletonID = 1
                    %element-Cutesequence = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-mandatory THEN if_abap_behv=>mk-off )
                    %element-Validfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validexists THEN if_abap_behv=>mk-off )
                    %element-Validto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity
                                                 OR state_area EQ zif_re_revenuestream=>state_area-validexists
                                                THEN if_abap_behv=>mk-off )
                    %element-Countfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validcount
                                                   OR state_area EQ zif_re_revenuestream=>state_area-countexists THEN if_abap_behv=>mk-off )
                    %element-Countto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validcount
                                                 OR state_area EQ zif_re_revenuestream=>state_area-countexists THEN if_abap_behv=>mk-off ) ) TO reported-AerocuteMaster.

    IF e EQ abap_true.
      APPEND VALUE #( %tky = dto-%tky ) TO failed-AerocuteMaster.

      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = state_area
                      %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                      number   = zif_re_revenuestream=>msgcommon
                                                      severity = if_abap_behv_message=>severity-error
                                                      v1       = msgv1 )
                      %path-AerocuteMasterAll-%is_draft = dto-%is_draft
                      %path-AerocuteMasterAll-SingletonID = 1
                      %element-Cutesequence = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-mandatory THEN if_abap_behv=>mk-on )
                      %element-Validfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validexists THEN if_abap_behv=>mk-on )
                      %element-Validto   = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validity
                                                    OR state_area EQ zif_re_revenuestream=>state_area-validexists
                                                    THEN if_abap_behv=>mk-on )
                      %element-Countfrom = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validcount
                                                     OR state_area EQ zif_re_revenuestream=>state_area-countexists THEN if_abap_behv=>mk-on )
                      %element-Countto = COND #( WHEN state_area EQ zif_re_revenuestream=>state_area-validcount
                                                   OR state_area EQ zif_re_revenuestream=>state_area-countexists THEN if_abap_behv=>mk-on ) ) TO reported-AerocuteMaster.
    ENDIF.
  ENDMETHOD.


  METHOD validityrange.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMaster
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(ref_AerocuteMaster)
    FAILED DATA(read_failed).

    LOOP AT ref_AerocuteMaster INTO DATA(dto).
      DATA(e) = COND #( WHEN dto-Validfrom GT dto-Validto THEN abap_true ELSE abap_false ).

      validate_cute( EXPORTING dto = dto
                               state_area = zif_re_revenuestream=>state_area-validity
                               msgv1 = zif_re_revenuestream=>message_v-valuerange
                               e = e
                     CHANGING  failed = failed
                               reported = reported ).
    ENDLOOP.
  ENDMETHOD.


  METHOD countrange.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMaster
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(ref_AerocuteMaster)
    FAILED DATA(read_failed).

    LOOP AT ref_AerocuteMaster INTO DATA(dto).
      DATA(e) = COND #( WHEN dto-Countfrom GT dto-Countto THEN abap_true ELSE abap_false ).

      validate_cute( EXPORTING dto = dto
                               state_area = zif_re_revenuestream=>state_area-validcount
                               msgv1 = zif_re_revenuestream=>message_v-valuerange
                               e = e
                     CHANGING  failed = failed
                               reported = reported ).
    ENDLOOP.
  ENDMETHOD.

  METHOD mandatoryfield.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMaster
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(ref_AerocuteMaster)
    FAILED DATA(read_failed).

    LOOP AT ref_AerocuteMaster INTO DATA(dto).
      DATA(e) = COND #( WHEN dto-Cutesequence IS INITIAL THEN abap_true ELSE abap_false ).

      validate_cute( EXPORTING dto = dto
                               state_area = zif_re_revenuestream=>state_area-mandatory
                               msgv1 = |Sequence is mandatory.|
                               e = e
                     CHANGING  failed = failed
                               reported = reported ).
    ENDLOOP.
  ENDMETHOD.

  METHOD valueexists.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMaster
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(ref_AerocuteMaster)
    FAILED DATA(read_failed).

    IF ref_AerocuteMaster IS NOT INITIAL.

      SELECT FROM ZI_AerocuteMaster
      FIELDS *
      FOR ALL ENTRIES IN @ref_AerocuteMaster
      WHERE streamuuid EQ @ref_AerocuteMaster-streamuuid
        AND streamitemuuid EQ @ref_AerocuteMaster-streamitemuuid
        AND Calcruleuuid EQ @ref_AerocuteMaster-Calcruleuuid
      INTO TABLE @DATA(existing).
      IF sy-subrc EQ 0.
      ENDIF.

      LOOP AT ref_AerocuteMaster INTO DATA(dto).
        LOOP AT existing INTO DATA(x)
        WHERE Cuteuuid NE dto-Cuteuuid
          AND streamuuid EQ dto-Streamuuid
          AND Streamitemuuid EQ dto-Streamitemuuid
          AND Calcruleuuid EQ dto-Calcruleuuid.
          IF dto-Cutesequence EQ x-Cutesequence.
            DATA(e) = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
        validate_cute( EXPORTING dto = dto
                                 state_area = zif_re_revenuestream=>state_area-mandatory
                                 msgv1 = |Sequence is already exists.|
                                 e = e
                       CHANGING  failed = failed
                                 reported = reported ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD overlapdate.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMaster
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(ref_AerocuteMaster)
    FAILED DATA(read_failed).

    IF ref_AerocuteMaster IS NOT INITIAL.

      SELECT FROM ZI_AerocuteMaster
      FIELDS *
      FOR ALL ENTRIES IN @ref_AerocuteMaster
      WHERE streamuuid EQ @ref_AerocuteMaster-streamuuid
        AND streamitemuuid EQ @ref_AerocuteMaster-streamitemuuid
        AND Calcruleuuid EQ @ref_AerocuteMaster-Calcruleuuid
      INTO TABLE @DATA(existing).
      IF sy-subrc EQ 0.
        LOOP AT existing ASSIGNING FIELD-SYMBOL(<x>).
          ASSIGN ref_AerocuteMaster[ Cuteuuid = <x>-Cuteuuid ]
          TO FIELD-SYMBOL(<ref>).
          IF sy-subrc EQ 0.
            IF <x>-Validfrom IS INITIAL AND <ref>-Validfrom IS NOT INITIAL.
              <x>-Validfrom = <ref>-Validfrom.
            ENDIF.

            IF <x>-Validto IS INITIAL AND <ref>-Validto IS NOT INITIAL.
              <x>-Validto = <ref>-Validto.
            ENDIF.
          ENDIF.
        ENDLOOP.
        DELETE existing WHERE Validfrom IS INITIAL AND Validto IS INITIAL.
      ENDIF.

      LOOP AT ref_AerocuteMaster INTO DATA(dto).

        LOOP AT existing INTO DATA(x)
        WHERE Cuteuuid NE dto-Cuteuuid
          AND streamuuid EQ dto-Streamuuid
          AND Streamitemuuid EQ dto-Streamitemuuid
          AND Calcruleuuid EQ dto-Calcruleuuid.
          IF  dto-Validfrom LE x-Validto
          AND dto-Validto GE x-Validfrom.
            DATA(e) = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF e EQ abap_false.
          LOOP AT ref_AerocuteMaster INTO DATA(d)
          WHERE Cuteuuid NE dto-Cuteuuid
          AND streamuuid EQ dto-Streamuuid
          AND Streamitemuuid EQ dto-Streamitemuuid
          AND Calcruleuuid EQ dto-Calcruleuuid.
          IF  dto-Validfrom LE d-Validto
          AND dto-Validto GE d-Validfrom.
            e = abap_true.
            EXIT.
          ENDIF.
          ENDLOOP.
        ENDIF.

        validate_cute( EXPORTING dto = dto
                                 state_area = zif_re_revenuestream=>state_area-validexists
                                 msgv1 = |Overlapping period is not allowed: Sequence { dto-Cutesequence }|
                                 e = e
                       CHANGING  failed = failed
                                 reported = reported ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD overlapcount.
    READ ENTITIES OF ZI_AerocuteMaster_S IN LOCAL MODE
    ENTITY AerocuteMaster
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(ref_AerocuteMaster)
    FAILED DATA(read_failed).

    IF ref_AerocuteMaster IS NOT INITIAL.

      SELECT FROM ZI_AerocuteMaster
      FIELDS *
      FOR ALL ENTRIES IN @ref_AerocuteMaster
      WHERE streamuuid EQ @ref_AerocuteMaster-streamuuid
        AND streamitemuuid EQ @ref_AerocuteMaster-streamitemuuid
        AND Calcruleuuid EQ @ref_AerocuteMaster-Calcruleuuid
      INTO TABLE @DATA(existing).
      IF sy-subrc EQ 0.
        LOOP AT existing ASSIGNING FIELD-SYMBOL(<x>).
          ASSIGN ref_AerocuteMaster[ Cuteuuid = <x>-Cuteuuid ]
          TO FIELD-SYMBOL(<ref>).
          IF sy-subrc EQ 0.
            IF <x>-Countfrom EQ 0 AND <ref>-Countfrom NE 0.
              <x>-Countfrom = <ref>-Countfrom.
            ENDIF.

            IF <x>-Countto EQ 0 AND <ref>-Countto NE 0.
              <x>-Countto = <ref>-Countto.
            ENDIF.
          ENDIF.
        ENDLOOP.
        DELETE existing WHERE Countfrom EQ 0 AND Countto EQ 0.
      ENDIF.

      LOOP AT ref_AerocuteMaster INTO DATA(dto).

        LOOP AT existing INTO DATA(x)
        WHERE Cuteuuid NE dto-Cuteuuid
          AND streamuuid EQ dto-Streamuuid
          AND Streamitemuuid EQ dto-Streamitemuuid
          AND Calcruleuuid EQ dto-Calcruleuuid.
          IF  dto-Countfrom LE x-Countto
          AND dto-Countto GE x-Countfrom.
            DATA(e) = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF e EQ abap_false.
          LOOP AT ref_AerocuteMaster INTO DATA(d)
          WHERE Cuteuuid NE dto-Cuteuuid
          AND streamuuid EQ dto-Streamuuid
          AND Streamitemuuid EQ dto-Streamitemuuid
          AND Calcruleuuid EQ dto-Calcruleuuid.
          IF  dto-Countfrom LE d-Countto
          AND dto-Countto GE d-Countfrom.
            e = abap_true.
            EXIT.
          ENDIF.
          ENDLOOP.
        ENDIF.

        validate_cute( EXPORTING dto = dto
                                 state_area = zif_re_revenuestream=>state_area-countexists
                                 msgv1 = |Overlapping count is not allowed: Sequence { dto-Cutesequence }|
                                 e = e
                       CHANGING  failed = failed
                                 reported = reported ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
