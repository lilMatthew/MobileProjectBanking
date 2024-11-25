import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/items.dart';
import 'package:flutter_application_1/widget/widget_support.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Items()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
          title: Row(
        children: [
          Text(
            'Inventory Screen',
            style: AppWidget.boldTextFieildStyle(),
          ),
        ],
      )),
      body: Center(
        child: Text('This is the Inventory Screen'),
      ),
    );
  }
}
