@EndUserText.label: 'Maintain AEROCute master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_AerocuteMaster_S
  provider contract transactional_query
  as projection on ZI_AerocuteMaster_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _AerocuteMaster : redirected to composition child ZC_AerocuteMaster
  
}
