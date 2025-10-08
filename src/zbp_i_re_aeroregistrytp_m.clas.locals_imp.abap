CLASS lhc_aeroregistry DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR aeroregistry RESULT result.
    METHODS fileupload FOR MODIFY
      IMPORTING keys FOR ACTION aeroregistry~fileupload.

*    METHODS copyregistry FOR MODIFY
*      IMPORTING keys FOR ACTION aeroregistry~copyregistry.

ENDCLASS.

CLASS lhc_aeroregistry IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD fileUpload.
    DATA: ls_temp TYPE ztab_fiori_temp.
    DATA(key) = keys[ 1 ].

    ls_temp-name = key-%param-filename.
    ls_temp-description = key-%param-mimetype.
    MODIFY ztab_fiori_temp FROM ls_temp.
  ENDMETHOD.

ENDCLASS.
