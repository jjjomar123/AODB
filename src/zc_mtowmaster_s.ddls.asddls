@EndUserText.label: 'Maintain MTOW Master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_MtowMaster_S
  provider contract transactional_query
  as projection on ZI_MtowMaster_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _MtowMaster : redirected to composition child ZC_MtowMaster
  
}
