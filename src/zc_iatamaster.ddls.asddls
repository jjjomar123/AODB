@EndUserText.label: 'Maintain IATA master'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_IataMaster
  as projection on ZI_IataMaster
{
  key Code,
      Description,
      LastChangedAt,
      @Consumption.hidden: true
      LocalLastChangedAt,
      @Consumption.hidden: true
      SingletonID,
      _IataMasterAll : redirected to parent ZC_IataMaster_S

}
