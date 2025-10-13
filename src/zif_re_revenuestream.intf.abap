INTERFACE zif_re_revenuestream
  PUBLIC .

  CONSTANTS: msgid TYPE symsgid VALUE 'SY',
             msgno TYPE symsgno VALUE 2.

  CONSTANTS: BEGIN OF state_area,
               roundoff   TYPE string VALUE 'ROUNDOFF',
               chargeable TYPE string VALUE 'CHARGEABLE',
               validity   TYPE string VALUE 'Validity',
             END OF state_area.
ENDINTERFACE.
