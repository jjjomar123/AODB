@EndUserText.label: 'Maintain MTOW Master'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MtowMaster
  as projection on ZI_MtowMaster
{
  key Category,
  key Qtyfrom,
      Qtyto,
      Description,
      LastChangedAt,
      @Consumption.hidden: true
      LocalLastChangedAt,
      @Consumption.hidden: true
      SingletonID,
      _MtowMasterAll : redirected to parent ZC_MtowMaster_S

}
