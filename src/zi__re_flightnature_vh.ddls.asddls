@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nature of flight'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI__RE_FlightNature_VH
  as select from I_DomainFixedValue
{
      @ObjectModel.text.element: [ 'Description' ]
  key cast ( DomainValue as zde_re_natureofflight )                           as Nature,
      @Semantics.text: true
      _DomainFixedValueText[ Language = $session.system_language ].DomainText as Description
}
where
  SAPDataDictionaryDomain = 'ZDO_RE_NATUREOFFLIGHT'
