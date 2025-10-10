@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item consideration'
define view entity ZP_RE_RevenueStreamCNS
  as select from zre_rvnstmconsd
  association [1..1] to zre_rvnstrmitem as _tabitem on  $projection.Streamuuid     = _tabitem.streamuuid
                                                    and $projection.Streamitemuuid = _tabitem.streamitemuuid
{
  key streamuuid         as Streamuuid,
  key streamitemuuid     as Streamitemuuid,
  key cnsderationuuid    as Cnsderationuuid,
      @Semantics.quantity.unitOfMeasure: 'baseunitofmeasure'
      free               as Free,
      @Semantics.quantity.unitOfMeasure: 'baseunitofmeasure'
      firsthalf          as Firsthalf,
      @Semantics.quantity.unitOfMeasure: 'baseunitofmeasure'
      succeeding         as Succeeding,
      starttime          as Starttime,
      endtime            as Endtime,
      status             as Status,
      validfrom          as Validfrom,
      validto            as Validto,
      _tabitem.baseunitofmeasure,
      locallastchangedat as Locallastchangedat
}
