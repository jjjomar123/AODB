@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream'
@Metadata.allowExtensions: true
define root view entity ZC_RE_RevenueStreamTP_M
  provider contract transactional_query
  as projection on ZI_RE_RevenueStreamTP_M
{
  key Streamuuid,
      @ObjectModel: { 
          filter.enabled: true,
          text.element:   ['CompanyCodeName']
      }      
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name    : 'I_CompanyCode',  
            element : 'CompanyCode'                     
          },
          useForValidation: true
        }
      ]  
      CompanyCode,
      _compcode.CompanyCodeName,
      Code,
      Name,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      /* Associations */
      _Item : redirected to composition child ZC_RE_RevenueStreamItemTP_M,
      _compcode
}
