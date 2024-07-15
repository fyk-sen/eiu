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
  List sub = List.generate(99, (index) => [0,'0']);
  final space = const SizedBox(height: 10.0);

  String? _value ='one';

  @override
  void initState() {super.initState();}

  @override
  Widget build(BuildContext context) {
    final MQTTState appState = Provider.of<MQTTState>(context);

    currentAppState = appState;

    Future(() async {if (currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected) {conn();}});
  
  return Scaffold(
    appBar: AppBar(backgroundColor: connColor(currentAppState.getAppConnectionState),
          title: DropdownButton<String>(
          value: _value,
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem(
              value: 'one',
              child: Text('one'),
            
            ),
            DropdownMenuItem(
              value: 'two',
              child: Text('two'),

            ),
          ], 
          onChanged: (String? value) {setState(() => _value = value);},),),
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        chart(currentAppState.getSubText, cell, id, value, sub, Storage.unocc, Storage.occ, percentage, round),
        stat(Storage.occ, Storage.unocc),
        grid(sub, context, space),
      ],
    ));
  }

  void conn(){
    manager = MQTT(
      // host: '192.168.0.101',
      host: 'broker.emqx.io',
      topic: 'PLC',
      identifier: 'cbd',
      state: currentAppState);
    manager.mqttInit();
    manager.connect();
    return;
  }

  void disconn() {manager.disconnect();}
  }
