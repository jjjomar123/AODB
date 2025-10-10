@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item calculation rule'
@Metadata.allowExtensions: true
define view entity ZC_RE_RevenueStreamCALCRU_TP_M
  as projection on ZI_RE_RevenueStreamCALCRU_TP_M
{
  key Streamuuid,
  key Streamitemuuid,
  key Calcruleuuid,
      @ObjectModel: { 
          filter.enabled: true,
          text.element:   ['Rulename']
      }    
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'ZI_RE_CalculationFormulaVH',
            element : 'RECalculationRule'
          },
          useForValidation: true
        }
      ]  
      Calculationrule,
      _Calc.REConditionAttributeName as Rulename,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'I_REMeasurementTypeStdVH',
            element : 'REMeasurementType'
          },
          useForValidation: true
        }
      ]        
      Succeedingrate,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'I_REMeasurementTypeStdVH',
            element : 'REMeasurementType'
          },
          useForValidation: true
        }
      ]       
      Differingmeasurement,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'I_REMeasurementTypeStdVH',
            element : 'REMeasurementType'
          },
          useForValidation: true
        }
      ]       
      Succeedingmeasurement,
      Locallastchangedat,
      /* Associations */
      _Item : redirected to parent ZC_RE_RevenueStreamItemTP_M,
      _Root : redirected to ZC_RE_RevenueStreamTP_M,
      _Calc
}
