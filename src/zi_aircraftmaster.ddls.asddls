@EndUserText.label: 'Aircraft Master'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_AircraftMaster
  as select from zre_aircraft
  association to parent ZI_AircraftMaster_S as _AircraftMasterAll on $projection.SingletonID = _AircraftMasterAll.SingletonID
{
  key type                  as Type,
      description           as Description,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      1                     as SingletonID,
      _AircraftMasterAll

}
