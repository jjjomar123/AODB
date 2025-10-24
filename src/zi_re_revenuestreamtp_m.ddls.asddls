@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue Stream'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RE_RevenueStreamTP_M
  as select from ZP_RE_RevenueStreamHDR
  composition[0..*] of ZI_RE_RevenueStreamItemTP_M as _Item
  association [1..1] to I_CompanyCode as _compcode on $projection.CompanyCode = _compcode.CompanyCode
{
  key Streamuuid,
      CompanyCode,
      Code,
      Name,
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
      _Item,
      _compcode
}
