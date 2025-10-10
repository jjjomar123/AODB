@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item calculation rule'
define view entity ZP_RE_RevenueStreamCalcRule
  as select from zre_rvnamrcalcr
{
  key streamuuid            as Streamuuid,
  key streamitemuuid        as Streamitemuuid,
  key calcruleuuid          as Calcruleuuid,
      calculationrule       as Calculationrule,
      succeedingrate        as Succeedingrate,
      differingmeasurement  as Differingmeasurement,
      succeedingmeasurement as Succeedingmeasurement,
      locallastchangedat    as Locallastchangedat
}
