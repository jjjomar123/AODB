@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item'
@Metadata.allowExtensions: true
define view entity ZC_RE_RevenueStreamItemTP_M
  as projection on ZI_RE_RevenueStreamItemTP_M
{
  key Streamuuid,
  key Streamitemuuid,
      @ObjectModel: { 
          filter.enabled: true,
          text.element:   ['NatureName']
      }   
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'ZI__RE_FlightNature_VH',
            element : 'Nature'
          },
          useForValidation: true
        }
      ]
      Nature,
      _Naturetype.Description as NatureName,
      Govermenttshare,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'I_UnitOfMeasureStdVH',
            element : 'UnitOfMeasure'
          },
          useForValidation: true
        }
      ]
      Baseunitofmeasure,
      Locallastchangedat,
      /* Associations */
      _Calcrule      : redirected to composition child ZC_RE_RevenueStreamCALCRU_TP_M,
      _Consideration : redirected to composition child ZC_RE_RevenueStreamCNSTP_M,
      _Root          : redirected to parent ZC_RE_RevenueStreamTP_M,
      _Round         : redirected to composition child ZC_RE_RevenueStreamRNDTP_M,
      _Naturetype
}
