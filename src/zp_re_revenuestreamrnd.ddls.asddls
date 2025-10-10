@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item round off details'
define view entity ZP_RE_RevenueStreamRND
  as select from zre_rvnstmround
  association [1..1] to zre_rvnstrmitem as _tabitem on  $projection.Streamuuid     = _tabitem.streamuuid
                                                    and $projection.Streamitemuuid = _tabitem.streamitemuuid
{
  key streamuuid         as Streamuuid,
  key streamitemuuid     as Streamitemuuid,
  key roundoffuuid       as Roundoffuuid,
      @Semantics.quantity.unitOfMeasure: 'baseunitofmeasure'
      roundfrom          as Roundfrom,
      @Semantics.quantity.unitOfMeasure: 'baseunitofmeasure'
      roundto            as Roundto,
      _tabitem.baseunitofmeasure,
      locallastchangedat as Locallastchangedat
}
