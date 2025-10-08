@EndUserText.label: 'MTOW Master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_MtowMaster_S
  as select from    I_Language
    left outer join zre_mtow on 0 = 0
  composition [0..*] of ZI_MtowMaster as _MtowMaster
{
  key 1                                          as SingletonID,
      _MtowMaster,
      max( zre_mtow.last_changed_at )            as LastChangedAtMax,
      cast( '' as sxco_transport)                as TransportRequestID,
      cast( 'X' as abap_boolean preserving type) as HideTransport

}
where
  I_Language.Language = $session.system_language
