CLASS lhc_aeroregistry DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR aeroregistry RESULT result.
    METHODS fileupload FOR MODIFY
      IMPORTING keys FOR ACTION aeroregistry~fileupload.
    METHODS airlinemaster FOR VALIDATE ON SAVE
      IMPORTING keys FOR aeroregistry~airlinemaster.

*    METHODS copyregistry FOR MODIFY
*      IMPORTING keys FOR ACTION aeroregistry~copyregistry.

ENDCLASS.

CLASS lhc_aeroregistry IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD fileUpload.
*    DATA: ls_temp TYPE ztab_fiori_temp.
*    DATA(key) = keys[ 1 ].
*
*    ls_temp-name = key-%param-filename.
*    ls_temp-description = key-%param-mimetype.
*    MODIFY ztab_fiori_temp FROM ls_temp.
  ENDMETHOD.

  METHOD airlinemaster.
    READ ENTITIES OF ZI_RE_AeroRegistryTP_M IN LOCAL MODE
    ENTITY AeroRegistry
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(aeroEntity).

    LOOP AT aeroEntity INTO DATA(dto).

      APPEND VALUE #( %tky             = dto-%tky
                      %state_area      = zif_re_revenuestream=>state_area-header ) TO reported-aeroregistry.

      IF dto-Airlinecode IS INITIAL
      OR dto-Rpcid IS INITIAL
      OR dto-Iatacode IS INITIAL
      OR dto-Mtowquantity IS INITIAL
      OR dto-Mtowunit IS INITIAL.
        APPEND VALUE #( %tky = dto-%tky ) TO failed-aeroregistry.

        APPEND VALUE #( %tky             = dto-%tky
                        %state_area      = zif_re_revenuestream=>state_area-header
                        %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                        number   = zif_re_revenuestream=>msgrequi
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-Airlinecode  = COND #( WHEN dto-Airlinecode IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Rpcid        = COND #( WHEN dto-Rpcid IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Iatacode     = COND #( WHEN dto-Iatacode IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Mtowquantity = COND #( WHEN dto-Mtowquantity IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Mtowunit     = COND #( WHEN dto-Mtowunit IS INITIAL THEN if_abap_behv=>mk-on )  ) TO reported-aeroregistry.
      ELSE.
        SELECT SINGLE FROM ZI_RE_AeroRegistryTP_M
        FIELDS @abap_true
        WHERE Uuid NE @dto-Uuid
          AND Airlinecode EQ @dto-Airlinecode
          AND Rpcid       EQ @dto-Rpcid
          AND Iatacode    EQ @dto-Iatacode
        INTO @DATA(is_true).

        IF is_true EQ abap_true.
          APPEND VALUE #( %tky = dto-%tky ) TO failed-aeroregistry.

          APPEND VALUE #( %tky             = dto-%tky
                          %state_area      = zif_re_revenuestream=>state_area-header
                          %msg             = new_message( id       = zif_re_revenuestream=>msgid
                                                          number   = zif_re_revenuestream=>msgcommon
                                                          severity = if_abap_behv_message=>severity-error
                                                          v1       = 'Airline Registry already exists.' )
                        %element-Airlinecode  = COND #( WHEN dto-Airlinecode IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Rpcid        = COND #( WHEN dto-Rpcid IS INITIAL THEN if_abap_behv=>mk-on )
                        %element-Iatacode     = COND #( WHEN dto-Iatacode IS INITIAL THEN if_abap_behv=>mk-on ) ) TO reported-aeroregistry.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
