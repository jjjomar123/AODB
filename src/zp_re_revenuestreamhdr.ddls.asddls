@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream header'
define view entity ZP_RE_RevenueStreamHDR
  as select from zre_rvnstreamhdr
{
  key streamuuid         as Streamuuid,
      comapnycode        as Comapnycode,
      code               as Code,
      name               as Name,
      localcreatedby     as Localcreatedby,
      localcreatedat     as Localcreatedat,
      locallastchangedby as Locallastchangedby,
      locallastchangedat as Locallastchangedat,
      lastchangedat      as Lastchangedat
}
