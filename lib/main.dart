import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';
import 'mqtt/state.dart';


// --------------------------------------------------

void main() {runApp(const Main());}

// --------------------------------------------------

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<MQTTState>(
          create: (_) => MQTTState(),
          child: const Home(),
       ),
       theme: ThemeData(scaffoldBackgroundColor: Colors.grey[200]),
       );
  } 
}

