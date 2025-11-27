CLASS zcl_re_bgpf_revenuestream DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_bgmc_op_single.

    METHODS constructor
      IMPORTING
        keys TYPE zcl_re_revenuestream_util=>tt_keys.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mt_keys TYPE zcl_re_revenuestream_util=>tt_keys.
    METHODS save.
ENDCLASS.



CLASS zcl_re_bgpf_revenuestream IMPLEMENTATION.
  METHOD constructor.
    mt_keys = keys.
  ENDMETHOD.

  METHOD if_bgmc_op_single~execute.
    cl_abap_tx=>save( ).

    save( ).
  ENDMETHOD.

  METHOD save.
    zcl_re_revenuestream_util=>set_aerocute( keys = mt_keys ).
  ENDMETHOD.

ENDCLASS.
