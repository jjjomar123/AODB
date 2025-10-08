@EndUserText.label: 'IATA master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_IataMaster_S
  as select from    I_Language
    left outer join zre_iata on 0 = 0
  composition [0..*] of ZI_IataMaster as _IataMaster
{
  key 1                                          as SingletonID,
      _IataMaster,
      max( zre_iata.last_changed_at )            as LastChangedAtMax,
      cast( '' as sxco_transport)                as TransportRequestID,
      cast( 'X' as abap_boolean preserving type) as HideTransport

}
where
  I_Language.Language = $session.system_language
