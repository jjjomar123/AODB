@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream Item'
define view entity ZI_RE_RevenueStreamItemTP_M
  as select from ZP_RE_RevenueStreamITM
  association        to parent ZI_RE_RevenueStreamTP_M as _Root       on $projection.Streamuuid = _Root.Streamuuid
  composition [0..*] of ZI_RE_RevenueStreamRNDTP_M     as _Round
  composition [0..*] of ZI_RE_RevenueStreamCNSTP_M     as _Consideration
  composition [0..*] of ZI_RE_RevenueStreamCALCRU_TP_M as _Calcrule
  association [1..1] to ZI__RE_FlightNature_VH         as _Naturetype on $projection.Nature = _Naturetype.Nature
{
  key Streamuuid,
  key Streamitemuuid,
      Nature,
      Govermenttshare,
      Baseunitofmeasure,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,

      _Root,
      _Round,
      _Consideration,
      _Calcrule,
      _Naturetype
}
