import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../mqtt/state.dart';
import '../mqtt/manager.dart';
import '../widgets/export.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int id = 1;
  
  double round = 0;
  double percentage = 0;

  late MQTT manager;
  late MQTTState currentAppState;

  List<String> cell = [];
  List<String> value = [];
  List sub = List.generate(98, (index) => [0,'0']);
  final space = const SizedBox(height: 10.0);

  @override
  void initState() {super.initState();}

  @override
  Widget build(BuildContext context) {
    final MQTTState appState = Provider.of<MQTTState>(context);

    currentAppState = appState;

  return Scaffold(
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        connState(connText(currentAppState.getAppConnectionState),
            connColor(currentAppState.getAppConnectionState)),
            space,
        connBtn(currentAppState.getAppConnectionState, conn, disconn),
        space,
        Text(
          'STALL DATA',
          style: TextStyle(
              color: Colors.brown[900],
              fontSize: 21,
              fontWeight: FontWeight.bold),
        ),
        chart(currentAppState.getSubText, cell, id, value, sub, Storage.unocc, Storage.occ, percentage, round),
        stat(Storage.occ, Storage.unocc),
        grid(sub, context, space),
      ],
    ));
  }

  void conn() {
    manager = MQTT(
      // host: '192.168.0.101',
      host: 'broker.emqx.io',
      topic: 'PLC',
      identifier: 'cbd',
      state: currentAppState);
    manager.mqttInit();
    manager.connect();
  }

  void disconn() {manager.disconnect();}
  }
