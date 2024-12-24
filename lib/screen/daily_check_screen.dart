/**BTL Mobile Banking */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';

class DailyCheckScreen extends StatefulWidget {
  const DailyCheckScreen({super.key});

  @override
  State<DailyCheckScreen> createState() => _DailyCheckScreenState();
}

class _DailyCheckScreenState extends State<DailyCheckScreen> {
  final CollectionReference _inventoryCollection =
      FirebaseFirestore.instance.collection('Inventory');

  List<Map<String, dynamic>> _inventoryItems = [];

  @override
  void initState() {
    super.initState();
    fetchInventoryData();
  }

  Future<void> fetchInventoryData() async {
    // Lấy dữ liệu từ Firestore
    QuerySnapshot querySnapshot = await _inventoryCollection.get();

    setState(() {
      _inventoryItems = querySnapshot.docs
          .map((doc) => {'Id': doc.id, ...doc.data() as Map<String, dynamic>})
          // .where((item) => item['Quantity'] > 0) -- nếu muốn tệp chỉ gửi số lượng item > 0 thì uncomment
          .toList();
      _inventoryItems.sort((a, b) => a['Id'].compareTo(b['Id']));
    });
  }

  Future<void> exportToCSV() async {
    if (_inventoryItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data available to export')),
      );
      return;
    }

    List<List<dynamic>> rows = [
      ["Name", "Id", "Quantity"]
    ];

    for (var item in _inventoryItems) {
      rows.add([item['Name'], item['Id'], item['Quantity']]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getExternalStorageDirectory();
    final path = "${directory!.path}/DailyCheckXofa/daily_check.csv";
    final directoryPath = Directory("${directory.path}/DailyCheckXofa");
    if (!await directoryPath.exists()) {
      await directoryPath.create(recursive: true);
    }
    final file = File(path);
    await file.writeAsString(csv);

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV saved to $path')),
    );
  }

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
                  image: AssetImage("images/xf_bangTin2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Xử lí logic Firebase
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(top: kToolbarHeight + 20.0, left: 20.0, right: 20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _inventoryCollection.orderBy("Id").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final items = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['Quantity'] != 0;
                  }).toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final data = item.data() as Map<String, dynamic>;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white, //them withOpacity(0.8) neu muon mo
                          borderRadius: BorderRadius.circular(20.0),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2,
                          //     blurRadius: 5,
                          //     offset: Offset(0, 3),
                          //   ),
                          // ],
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // AppBar
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
                  'Daily Check Screen',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.download, color: Colors.black),
                  onPressed: exportToCSV,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
