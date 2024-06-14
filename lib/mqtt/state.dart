
import 'package:flutter/cupertino.dart';

// --------------------------------------------------

enum MQTTAppConnectionState { connected, disconnected, connecting }

// --------------------------------------------------

class MQTTState with ChangeNotifier{

  // vars
  String subText = '';
  MQTTAppConnectionState appConnectionState = MQTTAppConnectionState.disconnected;

// --------------------------------------------------

  // mthds
  void setSubText(String text)
  {
  subText = text;
  notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state)
  {
    appConnectionState = state;
    notifyListeners();
  }

// --------------------------------------------------

  String get getSubText => subText;
  MQTTAppConnectionState get getAppConnectionState => appConnectionState;
}