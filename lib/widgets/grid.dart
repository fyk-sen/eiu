import 'popup.dart';
import 'storage.dart';

import 'package:flutter/material.dart';

Widget grid(sub, context, space) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.grey[200]),
          child: GridView.count(
            crossAxisCount: 14,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            padding: const EdgeInsets.all(15.0),
            children: [
              for (int i = 0; i < sub.length-1; i++)
                GestureDetector(
                  onTap: () {if(sub[i][1] != '0') {popup(context, space, sub[i][0], sub[i][1]);}},
                  child: 
                Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: sub[i][1] == '0' ? Colors.green : Colors.pink,
                    ),
                    child: Center(
                      child: Text('${Storage.no[i]}', textAlign: TextAlign.center),
                    ),
                    ),
                ),
            ],
          ),
        ),
      ),
    );
  }
