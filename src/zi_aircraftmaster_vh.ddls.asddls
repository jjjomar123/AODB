@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aircraft VH'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_AircraftMaster_VH
  as select from ZI_AircraftMaster
{
  key Type,
      Description
}
