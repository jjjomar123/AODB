@EndUserText.label: 'Maintain IATA master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_IataMaster_S
  provider contract transactional_query
  as projection on ZI_IataMaster_S
{
  key SingletonID,
      LastChangedAtMax,
      TransportRequestID,
      HideTransport,
      _IataMaster : redirected to composition child ZC_IataMaster

}
