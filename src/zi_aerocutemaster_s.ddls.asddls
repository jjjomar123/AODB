@EndUserText.label: 'AEROCute master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_AerocuteMaster_S
  as select from I_Language
    left outer join ZRE_AEROCUTERATE on 0 = 0
  composition [0..*] of ZI_AerocuteMaster as _AerocuteMaster
{
  key 1 as SingletonID,
  _AerocuteMaster,
  max( ZRE_AEROCUTERATE.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
