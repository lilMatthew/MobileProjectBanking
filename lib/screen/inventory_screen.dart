/*BTL Mobile Banking Academy */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'items.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_search_delegate.dart';

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
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/xf_bangTin2.jpg"), // Đường dẫn tới ảnh nền
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Header tùy chỉnh
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 196, 178, 170),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(90.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Inventory Screen',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Xử lý sự kiện tìm kiếm ở đây
                    showSearch(
                      context: context,
                      delegate: InventorySearchDelegate(_inventoryCollection),
                    );
                  },
                ),
              ],
            ),
          ),
          // Nội dung chính
          Positioned.fill(
            top: 100.0, // Đẩy nội dung xuống dưới header
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0),
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
          ),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: 0.8,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Items()));
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

   Future<void> _showOptionsDialog(String id, int currentQuantity) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Options'),
          content: Text('What would you like to do?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showUpdateQuantityDialog(id, currentQuantity);
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

  Future<void> _showUpdateQuantityDialog(String id, int currentQuantity) async {
    TextEditingController quantityController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Quantity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantity'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updateQuantity(id, currentQuantity, int.parse(quantityController.text), true);
                        Navigator.of(context).pop();
                      },
                      child: Text('Receive'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _updateQuantity(id, currentQuantity, int.parse(quantityController.text), false);
                        Navigator.of(context).pop();
                      },
                      child: Text('Transfer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateQuantity(String id, int currentQuantity, int inputQuantity, bool isReceive) async {
    int newQuantity = isReceive ? currentQuantity + inputQuantity : currentQuantity - inputQuantity;
    try {
      DocumentSnapshot doc = await _inventoryCollection.doc(id).get();
      if (doc.exists) {
        await _inventoryCollection.doc(id).update({'Quantity': newQuantity});
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _inventoryCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}