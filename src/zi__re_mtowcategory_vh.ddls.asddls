@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MTOW Category VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI__RE_MTOWCATEGORY_VH
  as select from I_DomainFixedValue
{
      @ObjectModel.text.element: [ 'Description' ]
  key DomainValue as Category,
      @Semantics.text: true
      _DomainFixedValueText[ Language = $session.system_language ].DomainText as Description
}
where
  SAPDataDictionaryDomain = 'ZDO_RE_MTOWCATEGORY'
