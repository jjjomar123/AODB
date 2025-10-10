@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item calculation rule'
define view entity ZI_RE_RevenueStreamCALCRU_TP_M
  as select from ZP_RE_RevenueStreamCalcRule
  association        to parent ZI_RE_RevenueStreamItemTP_M as _Item on  $projection.Streamuuid     = _Item.Streamuuid
                                                                    and $projection.Streamitemuuid = _Item.Streamitemuuid
  association [1..1] to ZI_RE_RevenueStreamTP_M            as _Root on  $projection.Streamuuid = _Root.Streamuuid
  association [1..1] to ZI_RE_CalculationFormulaVH         as _Calc on $projection.Calculationrule = _Calc.RECalculationRule
{
  key Streamuuid,
  key Streamitemuuid,
  key Calcruleuuid,
      Calculationrule,
      Succeedingrate,
      Differingmeasurement,
      Succeedingmeasurement,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,

      _Item,
      _Root,
      _Calc
}
