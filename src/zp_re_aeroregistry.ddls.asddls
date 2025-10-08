@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aero Registry view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZP_RE_AeroRegistry
  as select from zre_aeroregistry
{
  key uuid               as Uuid,
      airlinecode        as Airlinecode,
      rpcid              as Rpcid,
      iatacode           as Iatacode,
      aircrafttype       as Aircrafttype,
      @Semantics.quantity.unitOfMeasure: 'mtowunit'
      mtowquantity       as Mtowquantity,
      mtowunit           as Mtowunit,
      mtowcategory       as Mtowcategory,
      localcreatedby     as Localcreatedby,
      localcreatedat     as Localcreatedat,
      locallastchangedby as Locallastchangedby,
      locallastchangedat as Locallastchangedat,
      lastchangedat      as Lastchangedat
}
