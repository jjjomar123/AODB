@EndUserText.label: 'MTOW Master'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_MtowMaster
  as select from zre_mtow
  association to parent ZI_MtowMaster_S as _MtowMasterAll on $projection.SingletonID = _MtowMasterAll.SingletonID
{
  key category              as Category,
      qtyfrom               as Qtyfrom,
      qtyto                 as Qtyto,
      description           as Description,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      1                     as SingletonID,
      _MtowMasterAll

}
