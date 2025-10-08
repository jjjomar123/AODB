@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'IATA VH'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_IataMaster_VH
  as select from ZI_IataMaster
{
  key Code,
      Description
}
