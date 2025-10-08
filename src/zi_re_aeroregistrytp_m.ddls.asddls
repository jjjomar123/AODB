@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aero Registry interface view'
define root view entity ZI_RE_AeroRegistryTP_M
  as select from ZP_RE_AeroRegistry
  association [1] to ZI_RE_Airline_BusinessPartner as _airline  on $projection.Airlinecode = _airline.BusinessPartner
  association [1] to ZI_AircraftMaster             as _aircraft on $projection.Aircrafttype = _aircraft.Type
  association [1] to ZI_IataMaster                 as _iata     on $projection.Iatacode = _iata.Code
  association [1] to ZI_MtowMaster                 as _mtow     on $projection.Mtowquantity >= _mtow.Qtyfrom
                                                               and $projection.Mtowquantity <= _mtow.Qtyto
{
  key Uuid,
      Airlinecode,
      Rpcid,
      Iatacode,
      Aircrafttype,
      @Semantics.quantity.unitOfMeasure: 'Mtowunit'
      Mtowquantity,
      Mtowunit,
      _mtow.Category as Mtowcategory,
      @Semantics.user.createdBy: true
      Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      Localcreatedat,
      @Semantics.user.localInstanceLastChangedBy: true
      Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,

      /* Associations */
      _airline,
      _aircraft,
      _iata,
      _mtow
}
