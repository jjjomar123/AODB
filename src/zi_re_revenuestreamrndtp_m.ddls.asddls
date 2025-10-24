@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item round off details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_RE_RevenueStreamRNDTP_M
  as select from ZP_RE_RevenueStreamRND
  association        to parent ZI_RE_RevenueStreamItemTP_M as _Item on  $projection.Streamuuid     = _Item.Streamuuid
                                                                    and $projection.Streamitemuuid = _Item.Streamitemuuid
  association [1..1] to ZI_RE_RevenueStreamTP_M            as _Root on  $projection.Streamuuid = _Root.Streamuuid
{
  key Streamuuid,
  key Streamitemuuid,
  key Roundoffuuid,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Roundfrom,
      @Semantics.quantity.unitOfMeasure: 'Baseunitofmeasure'
      Roundto,
      _Item.Baseunitofmeasure,
      Rndsequence,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,
      
      _Item,
      _Root
}
