@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item consideration'
@Metadata.allowExtensions: true
define view entity ZC_RE_RevenueStreamCNSTP_M
  as projection on ZI_RE_RevenueStreamCNSTP_M
{
  key Streamuuid,
  key Streamitemuuid,
  key Cnsderationuuid,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Free,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Firsthalf,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Succeeding,
      Starttime,
      Endtime,
      Status,
      Validfrom,
      Validto,
      Locallastchangedat,
      Baseunitofmeasure,
      
      /* Associations */
      _Item : redirected to parent ZC_RE_RevenueStreamItemTP_M,
      _Root : redirected to ZC_RE_RevenueStreamTP_M
}
