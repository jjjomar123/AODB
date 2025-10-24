@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item round off details'
@Metadata.allowExtensions: true
define view entity ZC_RE_RevenueStreamRNDTP_M
  as projection on ZI_RE_RevenueStreamRNDTP_M
{
  key Streamuuid,
  key Streamitemuuid,
  key Roundoffuuid,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Roundfrom,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Roundto,
      Baseunitofmeasure,
      Rndsequence,
      Locallastchangedat,
      /* Associations */
      _Item : redirected to parent ZC_RE_RevenueStreamItemTP_M,
      _Root : redirected to ZC_RE_RevenueStreamTP_M
}
