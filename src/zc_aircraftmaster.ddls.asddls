@EndUserText.label: 'Maintain Aircraft Master'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_AircraftMaster
  as projection on ZI_AircraftMaster
{
  key Type,
      Description,
      LastChangedAt,
      @Consumption.hidden: true
      LocalLastChangedAt,
      @Consumption.hidden: true
      SingletonID,
      _AircraftMasterAll : redirected to parent ZC_AircraftMaster_S

}
