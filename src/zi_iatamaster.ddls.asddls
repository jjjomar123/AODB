@EndUserText.label: 'IATA master'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_IataMaster
  as select from zre_iata
  association to parent ZI_IataMaster_S as _IataMasterAll on $projection.SingletonID = _IataMasterAll.SingletonID
{
  key code                  as Code,
      description           as Description,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      1                     as SingletonID,
      _IataMasterAll

}
