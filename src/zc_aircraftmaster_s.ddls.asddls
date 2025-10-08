@EndUserText.label: 'Maintain Aircraft Master Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_AircraftMaster_S
  provider contract transactional_query
  as projection on ZI_AircraftMaster_S
{
  key SingletonID,
      LastChangedAtMax,
      TransportRequestID,
      HideTransport,
      _AircraftMaster : redirected to composition child ZC_AircraftMaster

}
