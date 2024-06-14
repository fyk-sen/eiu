import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:fl_chart/fl_chart.dart';

import '../mqtt/state.dart';
import '../mqtt/manager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List sub = [];

  late MQTT manager;
  late MQTTState currentAppState;

  final space = const SizedBox(height: 10.0);

  @override
  void initState() {
    super.initState();
  }

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
        connBtn(currentAppState.getAppConnectionState),
        space,
        chart(currentAppState.getSubText),
        space,
        grid()
      ],
    ));
  }

  Widget connState(String status, connColor) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: connColor,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  Widget connBtn(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed:
                state == MQTTAppConnectionState.disconnected ? conn : null,
            child: const Text('Connect'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed:
                state == MQTTAppConnectionState.connected ? disconn : null,
            child: const Text('Disconnect'),
          ),
        ),
      ],
    );
  }

  String connText(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  connColor(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return Colors.green;
      case MQTTAppConnectionState.connecting:
        return Colors.amber;
      case MQTTAppConnectionState.disconnected:
        return Colors.pink;
    }
  }

  void conn() {
    manager = MQTT(
        host: '192.168.0.101',
        // host: 'broker.emqx.io',
        pubTopic: 'PLC',
        subTopic: 'PLC',
        identifier: 'owoFlutter',
        state: currentAppState);
    manager.mqttInit();
    manager.connect();
  }

  void disconn() {
    manager.disconnect();
  }

  Widget chart(String data) {
    sub = [];
    sub = data.split(',');

    double falseval = (sub.where((item) => item == "0").length).toDouble();
    double trueval = (sub.where((item) => item == "1").length).toDouble();

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Available Space:\n$trueval%',
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    PieChart(
                        swapAnimationCurve: Curves.easeInOut,
                        swapAnimationDuration: const Duration(milliseconds: 750),
                        PieChartData(sections: [
                          PieChartSectionData(
                              value: falseval,
                              color: Colors.pink,
                              title: '$falseval\nOccupied'),
                          PieChartSectionData(
                            value: (trueval),
                            color: Colors.green,
                            title: '$trueval\nUnoccupied',
                          )
                        ]))
                  ],
                ),
              ),
            )));
  }

  Widget grid() {
    return Expanded(
        child: GridView.count(
      crossAxisCount: 14,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      padding: const EdgeInsets.all(10.0),
      children: [
        for (int i = 0; i < sub.length - 1; i++)
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: sub[i] == "1" ? Colors.green : Colors.pink),
            child: Text('${i + 1}', textAlign: TextAlign.center),
          ),
      ],
    ));
  }
}
