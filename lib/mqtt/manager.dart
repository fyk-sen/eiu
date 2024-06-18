import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'state.dart';

// ------------------------------

class MQTT {
  final String host;
  final String pubTopic;
  final String subTopic;
  final String identifier;
  final MQTTState currentState;

  MqttServerClient? client;

  MQTT(
      {
      required this.host,
      required this.pubTopic,
      required this.subTopic,
      required this.identifier,
      required MQTTState state
      })

      : 
        currentState = state;

  void mqttInit() {
    client = MqttServerClient(host, identifier);

    client!.setProtocolV31();
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;

// ------------------------------

//              WILL

// ------------------------------

    final MqttConnectMessage will = MqttConnectMessage()
        .withClientIdentifier(identifier)
        .withWillTopic('Adios')
        .withWillMessage('Goodbye world!')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client!.connectionMessage = will;

// ------------------------------

//         CONNECTING

// ------------------------------

    print('\nCONNECTING...');
    client!.connectionMessage = will;
 }
// ------------------------------

//         CONNECTED

// ------------------------------

    void connect() async {
      assert(client != null);
      try {
        print('\nCONNECTING...');
        currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
        await client!.connect();
      } on NoConnectionException catch (e) {
        //client error
        print('\nCLIENT EXCEPTION:\n$e');
        disconnect();
      } on SocketException catch (e) {
        print('\nSOCKET EXCEPTION:\n$e');
        disconnect();
      }
    }
 

  void disconnect() {
    print('Disconnected');
    client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.clear();
    builder.addString(message);
    client!.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
  }

// ------------------------------

//          CALLBACKS

// ------------------------------

  void onSubscribed(String topic) {
    print('\nSUBSCRIPTION CALLBACK:\nConfirmation!\nTopic: $topic');
  }

  // Disconnected
  void onDisconnected() {
    print(
        //Unsolicited
        '\nDISCONNECTED CALLBACK:\nType: Unsolicited\nClient has disconnected.');

    //Solicited
    if (client!.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('\nDISCONNECTED CALLBACK:\nType: Solicited\nAll good :)');

    //Unsolicited
    } else {
      print(
          '\nDISCONNECTED CALLBACK:\nType: Unsolicited/None\nSomething is wrong. Exiting.');
      exit(-1);
    }
    currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  // Connected
  void onConnected() {
    currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('\nCONNECTED!');
    client!.subscribe(subTopic, MqttQos.atLeastOnce);

    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) 
    {
      final MqttPublishMessage recMsg = c![0].payload as MqttPublishMessage;
      final String subTxt = MqttPublishPayload.bytesToStringAsString(recMsg.payload.message);
     
     currentState.setSubText(subTxt);
    
    });

// ------------------------------

//         LISTENERS

// ------------------------------

// Change
    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(
          '\nCHANGE NOTIFICATION\nTopic: <${c[0].topic}>\nPayload: <-- $pt -->');
    });
    print('CONNECTED CALLBACK:\n Successful!');
  }
}
