@EndUserText.label: 'Aircraft Master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_AircraftMaster_S
  as select from    I_Language
    left outer join zre_aircraft on 0 = 0
  composition [0..*] of ZI_AircraftMaster as _AircraftMaster
{
  key 1                                          as SingletonID,
      _AircraftMaster,
      max( zre_aircraft.last_changed_at )        as LastChangedAtMax,
      cast( '' as sxco_transport)                as TransportRequestID,
      cast( 'X' as abap_boolean preserving type) as HideTransport

}
where
  I_Language.Language = $session.system_language
