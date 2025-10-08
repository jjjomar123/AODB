@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airline BP'
define view entity ZI_RE_Airline_BusinessPartner
  as select from I_BusinessPartner_to_BP_Role as _bprole
{
  key _bprole.BusinessPartner,
  @UI.hidden: true
  key _bprole.BusinessPartnerRole,
      _bprole._BusinessPartner.BusinessPartnerName
}
where
  BusinessPartnerRole = 'FLVN01'
