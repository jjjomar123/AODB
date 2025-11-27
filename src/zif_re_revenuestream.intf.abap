INTERFACE zif_re_revenuestream
  PUBLIC .

  TYPES: tt_consieration_key   TYPE TABLE FOR KEY OF zi_re_revenuestreamtp_m\\consideration,
         tt_reported           TYPE RESPONSE FOR REPORTED LATE zi_re_revenuestreamtp_m,
         tt_failed             TYPE RESPONSE FOR FAILED LATE zi_re_revenuestreamtp_m,
         tt_consideration_data TYPE TABLE FOR READ RESULT zi_re_revenuestreamtp_m\\item\_consideration,
         tt_link               TYPE TABLE FOR READ LINK zi_re_revenuestreamtp_m\\item\_consideration,
         ts_roundoff           TYPE STRUCTURE FOR READ RESULT zi_re_revenuestreamtp_m\\item\_Round,
         ts_consideration      TYPE STRUCTURE FOR READ RESULT zi_re_revenuestreamtp_m\\item\_consideration.

  CONSTANTS: msgid     TYPE symsgid VALUE '00',
             msgcommon TYPE symsgno VALUE 208,
             msgrequi  TYPE symsgno VALUE 055.

  CONSTANTS: BEGIN OF state_area,
               roundoffseq TYPE string VALUE 'ROUNDOFFSEQ',
               roundoff    TYPE string VALUE 'ROUNDOFF',
               chargeable  TYPE string VALUE 'CHARGEABLE',
               validity    TYPE string VALUE 'VALIDITYRANGE',
               validexists TYPE string VALUE 'VALIDENTRYEXISTS',
               header      TYPE string VALUE 'HEADER',
               validcount  TYPE string VALUE 'VALIDCOUNT',
               mandatory   TYPE string VALUE 'MANDATORY',
               countexists TYPE string VALUE 'COUNTEXISTS',
             END OF state_area.

  CONSTANTS: BEGIN OF message_v,
               valueRange TYPE symsgv1 VALUE 'Invalid value range',
             END OF message_v.

ENDINTERFACE.
