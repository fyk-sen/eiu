import 'package:flutter/material.dart';

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
  List sub = List.generate(98, (index) => 0);
  Map<int, String> map = <int, String>{};
  double roundedNumber = 0;
  double percentage = 0;
  int unOccupied = 0;
  int occupied = 0;
  List<String> cell = [];
  int id = 0;

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
    print('sub $sub');

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
        const Text(
          'STALL DATA',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        chart(currentAppState.getSubText),
        data(),
        grid(),
        buttonNav()
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
        identifier: 'cbd',
        state: currentAppState);
    manager.mqttInit();
    manager.connect();
  }

  void disconn() {
    manager.disconnect();
  }

// Pie Chart
  Widget chart(String data) {
    data == '' ? {} : {cell = data.split('*'), id = int.parse(cell[0])};

    print('cell $cell');
    print('id $id');

    for (int i = 0; i < sub.length+1; i++) {
      if (i == id) {
        sub[i] = id;
      }
    }

    double falseval =  (sub.where((item) => item == '0' || item == 0).length).toDouble();
    double trueval =  sub.length - falseval;

    occupied = falseval.toInt();
    unOccupied = trueval.toInt();
    percentage = (occupied / (occupied + unOccupied)) * 100;
    roundedNumber = double.parse(percentage.toStringAsFixed(1));

    print('unocc $trueval');
        print('occ $falseval');


    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.brown[100]),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "$roundedNumber%",
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: PieChart(
                  swapAnimationCurve: Curves.easeInOut,
                  swapAnimationDuration: const Duration(milliseconds: 750),
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: falseval,
                        color: Colors.green,
                      ),
                      PieChartSectionData(
                        value: trueval,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    legend('Occupied', Colors.pink),
                    const SizedBox(height: 5),
                    legend('Unoccupied', Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget legend(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(title),
      ],
    );
  }

  Widget data() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            color: Colors.brown[100], borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Occupied',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        occupied.toString(),
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Unoccupied',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        unOccupied.toString(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget grid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 14,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        padding: const EdgeInsets.all(10.0),
        children: [
          for (int i = 0; i < sub.length; i++)
            GestureDetector(
              onTap: () {
                sub[i] == 0
                    ? null
                    : showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              color: Colors.white,
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('CELL DATA',
                                            style: TextStyle(
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 20),
                                         Text('Number: ${sub[i]}',
                                            style: const TextStyle(fontSize: 20.0)),
                                        const SizedBox(height: 10),
                                         Text('Value: ${cell[1]}',
                                            style: const TextStyle(fontSize: 20.0)),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ))
                                      ])));
                        });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color:
                      sub[i] == 0 || sub[i] == '0' ? Colors.green : Colors.pink,
                ),
                child: Center(
                  child: Text('${i + 1}', textAlign: TextAlign.center),
                ),
              ),
            ),
        ],
      ),
    );
  }

  final isSelected = <bool>[false, false];

  Widget buttonNav() {
    // final builder = MqttClientPayloadBuilder();
    // final client = MqttServerClient('broker.emqx.io', '');
    // const pubTopic = 'PLC';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: ToggleButtons(
        color: Colors.black.withOpacity(0.60),
        selectedColor: const Color(0xFF6200EE),
        selectedBorderColor: const Color(0xFF6200EE),
        fillColor: const Color(0xFF6200EE).withOpacity(0.08),
        splashColor: const Color(0xFF6200EE).withOpacity(0.12),
        // hoverColor: const Color(0xFF6200EE).withOpacity(0.04),
        borderRadius: BorderRadius.circular(4.0),
        constraints: const BoxConstraints(minHeight: 36.0),
        isSelected: isSelected,
        onPressed: (index) {
          // builder.clear();
          // builder.addString("{hi}");
          // client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
          setState(() {
            isSelected[index] = !isSelected[index];
            if (isSelected[index]) {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                if (buttonIndex != index) {
                  isSelected[buttonIndex] = false;
                }
              }
            }
          });
        },
        children: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('STALL LEFT'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('STALL RIGHT'),
          ),
        ],
      ),
    );
  }
}
