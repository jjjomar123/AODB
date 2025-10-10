@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item consideration'
define view entity ZI_RE_RevenueStreamCNSTP_M
  as select from ZP_RE_RevenueStreamCNS
  association        to parent ZI_RE_RevenueStreamItemTP_M as _Item on  $projection.Streamuuid     = _Item.Streamuuid
                                                                    and $projection.Streamitemuuid = _Item.Streamitemuuid
  association [1..1] to ZI_RE_RevenueStreamTP_M            as _Root on  $projection.Streamuuid = _Root.Streamuuid
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
      _Item.Baseunitofmeasure,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,
      
      _Item,
      _Root
}
