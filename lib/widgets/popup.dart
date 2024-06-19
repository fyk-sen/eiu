import 'package:flutter/material.dart';

popup(context, space, sub, val) {
    return showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
      decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.grey[200]),
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CELL $sub', style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          Divider(color: Colors.brown[200],),
          Text('Value: $val', style: const TextStyle(fontSize: 20.0)),
          space,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {Navigator.of(context).pop();},
              child: const Text('Close', style: TextStyle(color: Colors.pink),),
  ))])));

    });
    }