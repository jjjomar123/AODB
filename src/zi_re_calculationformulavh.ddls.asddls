@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'External Calculation Formula VH'
define view entity ZI_RE_CalculationFormulaVH
  as select from I_RECndnCalculationRuleExt
{
  key RECalculationRule,
      _Text[ Language = $session.system_language ].REConditionAttributeName
}
