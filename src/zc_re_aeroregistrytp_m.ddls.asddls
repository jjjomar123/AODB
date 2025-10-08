@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aero Registry projection'
@Metadata.allowExtensions: true
define root view entity ZC_RE_AeroRegistryTP_M
  provider contract transactional_query
  as projection on ZI_RE_AeroRegistryTP_M
{
  key Uuid,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_RE_Airline_BusinessPartner', element: 'BusinessPartner' }, useForValidation: true }]
      @ObjectModel.text.element: ['AirlineName']
      Airlinecode,
      _airline.BusinessPartnerName  as AirlineName,
      Rpcid,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_IataMaster_VH', element: 'Code' }, useForValidation: true }]
      @ObjectModel.text.element: ['IataName']
      Iatacode,
      _iata.Description     as IataName,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_AircraftMaster_VH', element: 'Type' }, useForValidation: true }]
      @ObjectModel.text.element: ['AircraftName']
      Aircrafttype,
      _aircraft.Description as AircraftName,
      Mtowquantity,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' }, useForValidation: true }]
      Mtowunit,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI__RE_MTOWCATEGORY_VH', element: 'Category' }, useForValidation: true }]
      @ObjectModel.text.element: ['MtowText']
      Mtowcategory,
      _mtow.Description     as MtowText,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,

      /* Associations */
      _airline,
      _aircraft,
      _iata,
      _mtow
}
