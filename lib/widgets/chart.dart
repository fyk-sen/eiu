import 'legend.dart';
import 'storage.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget chart(String data, cell, id, value, sub, unocc, occ, percentage, round) {
  int c = 0;
  data == '' || data == '0' || data == '1'
    ? {}
    : {cell = data.split('*'),
      id = int.parse(cell[0]),
      if (cell[1] != '0'){value.add(cell[1])},
      
      for (int i = 0; i < sub.length; i++) {
        if (i==id) {sub[i-1] = cell}, 
        if (cell[1] == '') {cell[1] = '0'},},
      
      for(int i = 0 ; i < sub.length; i++){
        if(sub[i][1] != '0'){c++}},

      print(c),
        
        };

    print('cell $cell');
    print('id $id');
    print('sub $sub');

    double red = c.toDouble();
    double green = sub.length - red;

    Storage.unocc = green.toInt();
    Storage.occ = red.toInt();
    percentage = (unocc / sub.length) * 100;
    round = double.parse(percentage.toStringAsFixed(1));

    print('unocc $green');
    print('occ $red');

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.grey[200]),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                "$round",
                style: TextStyle(
                    color: Colors.brown[900],
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Text('PERCENT\nUNOCCUPIED', style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: PieChart(
                  swapAnimationCurve: Curves.easeInOut,
                  swapAnimationDuration: const Duration(milliseconds: 750),
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: red,
                        color: Colors.pink,
                      ),
                      PieChartSectionData(
                        value: green,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              legend(),
            ],
          ),
        ),
      ),
    );
  }
  