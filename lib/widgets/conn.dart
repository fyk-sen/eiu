import '../mqtt/state.dart';
import 'package:flutter/material.dart';

Widget connState(String status, connColor) {
  return SafeArea(
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
          color: connColor,
          child: Text(status, textAlign: TextAlign.center)),
),],));}


//There's probably a way to combine connText and connColor.

String connText(MQTTAppConnectionState state) {
  switch (state) {
  case MQTTAppConnectionState.connected:
    return 'Connected';
  case MQTTAppConnectionState.connecting:
    return 'Connecting';
  case MQTTAppConnectionState.disconnected:
    return 'Disconnected';
}}

connColor(MQTTAppConnectionState state) {
  switch (state) {
    case MQTTAppConnectionState.connected:
      return Colors.green;
    case MQTTAppConnectionState.connecting:
      return Colors.amber;
    case MQTTAppConnectionState.disconnected:
      return Colors.pink;
}}