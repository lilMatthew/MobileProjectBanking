// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/screen/items.dart';
// import 'package:flutter_application_1/widget/widget_support.dart';

// class InventoryScreen extends StatefulWidget {
//   const InventoryScreen({super.key});

//   @override
//   State<InventoryScreen> createState() => _InventoryScreenState();
// }

// class _InventoryScreenState extends State<InventoryScreen> {
//   final CollectionReference _inventoryCollection =
//       FirebaseFirestore.instance.collection('Inventory');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Opacity(
//         opacity: 0.5,
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => Items()));
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text(
//               'Inventory Screen',
//               style: AppWidget.boldTextFieildStyle(),
//             ),
//           ],
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _inventoryCollection.orderBy("Id").snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final items = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               final data = item.data() as Map<String, dynamic>;

//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ListTile(
//                   title: Text(
//                     data['Name'],
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   subtitle: Text('Code: ${data['Id']}'),
//                   trailing: Text(
//                     'Quantity: ${data['Quantity']}',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 15.0,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                   onTap: () => _showOptionsDialog(item.id, data['Quantity']),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _showOptionsDialog(String id, int currentQuantity) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Options'),
//           content: Text('Choose an action'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _updateQuantity(id, currentQuantity);
//               },
//               child: Text('Update Quantity'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteItem(id);
//               },
//               child: Text('Delete Item'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _updateQuantity(String id, int currentQuantity) async {
//     TextEditingController quantityController = TextEditingController();
//     quantityController.text = currentQuantity.toString();

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Update Quantity'),
//           content: TextField(
//             controller: quantityController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Quantity'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 int newQuantity = int.parse(quantityController.text);
//                 try {
//                   DocumentSnapshot doc = await _inventoryCollection.doc(id).get();
//                   if (doc.exists) {
//                     await _inventoryCollection.doc(id).update({'Quantity': newQuantity});
//                     Navigator.of(context).pop();
//                   } else {
//                     print('Document does not exist');
//                     Navigator.of(context).pop();
//                   }
//                 } catch (e) {
//                   print('Error updating document: $e');
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _deleteItem(String id) async {
//     try {
//       await _inventoryCollection.doc(id).delete();
//     } catch (e) {
//       print('Error deleting document: $e');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'items.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final CollectionReference _inventoryCollection =
      FirebaseFirestore.instance.collection('Inventory');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Opacity(
        opacity: 0.5,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Items()));
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: Text(
          'Inventory Screen',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[400]!, Colors.white!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _inventoryCollection.orderBy("Id").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final items = snapshot.data!.docs;

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final data = item.data() as Map<String, dynamic>;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      data['Name'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text('Code: ${data['Id']}'),
                    trailing: Text(
                      'Quantity: ${data['Quantity']}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onTap: () => _showOptionsDialog(item.id, data['Quantity']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showOptionsDialog(String id, int currentQuantity) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Options'),
          content: Text('Choose an action'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateQuantity(id, currentQuantity);
              },
              child: Text('Update Quantity'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteItem(id);
              },
              child: Text('Delete Item'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateQuantity(String id, int currentQuantity) async {
    TextEditingController quantityController = TextEditingController();
    quantityController.text = currentQuantity.toString();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Quantity'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                int newQuantity = int.parse(quantityController.text);
                try {
                  DocumentSnapshot doc = await _inventoryCollection.doc(id).get();
                  if (doc.exists) {
                    await _inventoryCollection.doc(id).update({'Quantity': newQuantity});
                    Navigator.of(context).pop();
                  } else {
                    print('Document does not exist');
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print('Error updating document: $e');
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _inventoryCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}