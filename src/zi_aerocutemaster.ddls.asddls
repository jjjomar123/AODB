@EndUserText.label: 'CUTE Rate'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_AerocuteMaster
  as select from zre_aerocuterate as _cute
  association to parent ZI_AerocuteMaster_S     as _AerocuteMasterAll on  $projection.SingletonID = _AerocuteMasterAll.SingletonID
  association to ZI_RE_RevenueStreamCALCRU_TP_M as _Calcrule          on  $projection.Streamuuid     = _Calcrule.Streamuuid
                                                                      and $projection.Streamitemuuid = _Calcrule.Streamitemuuid
                                                                      and $projection.Calcruleuuid   = _Calcrule.Calcruleuuid
{
  key _cute.cuteuuid           as Cuteuuid,
      _cute.streamuuid         as Streamuuid,
      _cute.streamitemuuid     as Streamitemuuid,
      _cute.calcruleuuid       as Calcruleuuid,
      _Calcrule._Item._Root.CompanyCode,
      _Calcrule._Item._Root.Code,
      _Calcrule._Item.Nature,
      _Calcrule.Calculationrule,
      _Calcrule.Differingmeasurement,
      _cute.cutesequence       as Cutesequence,
      _cute.validto            as Validto,
      _cute.validfrom          as Validfrom,
      _cute.countfrom          as Countfrom,
      _cute.countto            as Countto,
      _cute.rate               as Rate,
      @Semantics.systemDateTime.lastChangedAt: true
      _cute.last_changed_at    as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _cute.locallastchangedat as Locallastchangedat,
      1                        as SingletonID,
      _AerocuteMasterAll

}
