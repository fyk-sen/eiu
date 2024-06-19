import 'package:flutter/material.dart';

Widget legend() {
  return Positioned(
    bottom: 10,
    left: 15,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        legendData('Occupied', Colors.pink),
        const SizedBox(height: 5),
        legendData('Unoccupied', Colors.green),],
),);}

Widget legendData(String title, Color color) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        color: color,),
      const SizedBox(width: 5),
      Text(title, style: const TextStyle(fontSize: 10),),
],);}