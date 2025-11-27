@EndUserText.label: 'Maintain AEROCute master'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_AerocuteMaster
  as projection on ZI_AerocuteMaster
{
  key Cuteuuid,
      Streamuuid,
      Streamitemuuid,
      Calcruleuuid,
      CompanyCode,
      Code,
      Nature,
      Calculationrule,
      Differingmeasurement,
      Cutesequence,
      Validto,
      Validfrom,
      Countfrom,
      Countto,
      Rate,
      LastChangedAt,
      @Consumption.hidden: true
      Locallastchangedat,
      @Consumption.hidden: true
      SingletonID,
      _AerocuteMasterAll : redirected to parent ZC_AerocuteMaster_S
}
