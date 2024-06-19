import 'package:flutter/material.dart';

Widget stat(occ, unocc) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Occupied', style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3,),
                      Text(occ.toString(),style: const TextStyle(fontSize: 20, color: Colors.pink
                      ),),],),
                  VerticalDivider(color: Colors.brown[200]),
                    Column(
                      children: [
                        const Text('Unoccupied',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          unocc.toString(),
                          style:
                              const TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
