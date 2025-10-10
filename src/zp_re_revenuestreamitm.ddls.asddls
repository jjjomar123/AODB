@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item'
define view entity ZP_RE_RevenueStreamITM
  as select from zre_rvnstrmitem
{
  key streamuuid         as Streamuuid,
  key streamitemuuid     as Streamitemuuid,
      nature             as Nature,
      govermenttshare    as Govermenttshare,
      baseunitofmeasure  as Baseunitofmeasure,
      locallastchangedat as Locallastchangedat
}
