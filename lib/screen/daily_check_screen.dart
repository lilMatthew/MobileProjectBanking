// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/gmail/v1.dart' as gmail;
// import 'package:http/http.dart' as http;
// import 'package:flutter_application_1/widget/widget_support.dart';

// class DailyCheckScreen extends StatefulWidget {
//   const DailyCheckScreen({super.key});

//   @override
//   State<DailyCheckScreen> createState() => _DailyCheckScreenState();
// }

// class _DailyCheckScreenState extends State<DailyCheckScreen> {
//   final CollectionReference _inventoryCollection =
//       FirebaseFirestore.instance.collection('Inventory');

//   List<Map<String, dynamic>> _inventoryItems = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchInventoryData();
//   }

//   Future<void> fetchInventoryData() async {
//     // Lấy dữ liệu từ Firestore
//     QuerySnapshot querySnapshot = await _inventoryCollection.get();

//     setState(() {
//       _inventoryItems = querySnapshot.docs
//           .map((doc) => {
//                 'id': doc.id,
//                 ...doc.data() as Map<String, dynamic>
//               })
//           .toList();
//     });
//   }

//   Future<void> exportToCSVAndSendEmail() async {
//     List<List<dynamic>> rows = [
//       ["Name", "Id", "Quantity"]
//     ];

//     for (var item in _inventoryItems) {
//       rows.add([
//         item['Name'],
//         item['Id'],
//         item['Quantity']
//       ]);
//     }

//     String csv = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path = "${directory.path}/daily_check.csv";
//     final file = File(path);
//     await file.writeAsString(csv);

//     // Lấy email của người dùng hiện tại từ Firebase Authentication
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String email = user.email!;

//       // Cấu hình OAuth 2.0
//       final clientId = ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET');
//       final scopes = [gmail.GmailApi.gmailSendScope];
//       await clientViaUserConsent(clientId, scopes, (url) {
//         // Mở URL trong trình duyệt để người dùng xác thực
//         print('Please go to the following URL and grant access:');
//         print('  => $url');
//         print('');
//       }).then((AuthClient client) async {
//         final gmailApi = gmail.GmailApi(client);

//         // Tạo email
//         var emailMessage = gmail.Message()
//           ..raw = base64UrlEncode(utf8.encode(
//               'Content-Type: text/plain; charset="UTF-8"\n'
//               'MIME-Version: 1.0\n'
//               'Content-Transfer-Encoding: 7bit\n'
//               'to: $email\n'
//               'subject: Daily Check CSV\n\n'
//               'Please find the attached CSV file for the daily check.\n\n'
//               'Attachment: ${file.path}'));

//         try {
//           await gmailApi.users.messages.send(emailMessage, 'me');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('CSV sent to $email')),
//           );
//         } catch (e) {
//           print('Failed to send email: $e');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to send CSV')),
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Daily Check Screen', style: AppWidget.boldTextFieildStyle(),),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: exportToCSVAndSendEmail,
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _inventoryCollection.orderBy("Id").snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final items = snapshot.data!.docs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return data['Quantity'] != 0;
//           }).toList();

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
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert';

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
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>
              })
          .toList();
    });
  }

  Future<void> exportToCSVAndSendEmail() async {
    List<List<dynamic>> rows = [
      ["Name", "Id", "Quantity"]
    ];

    for (var item in _inventoryItems) {
      rows.add([
        item['Name'],
        item['Id'],
        item['Quantity']
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/daily_check.csv";
    final file = File(path);
    await file.writeAsString(csv);

    // Lấy email của người dùng hiện tại từ Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;

      // Cấu hình OAuth 2.0
      final clientId = ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET');
      final scopes = [gmail.GmailApi.gmailSendScope];
      await clientViaUserConsent(clientId, scopes, (url) {
        // Mở URL trong trình duyệt để người dùng xác thực
        print('Please go to the following URL and grant access:');
        print('  => $url');
        print('');
      }).then((AuthClient client) async {
        final gmailApi = gmail.GmailApi(client);

        // Tạo email
        var emailMessage = gmail.Message()
          ..raw = base64UrlEncode(utf8.encode(
              'Content-Type: text/plain; charset="UTF-8"\n'
              'MIME-Version: 1.0\n'
              'Content-Transfer-Encoding: 7bit\n'
              'to: $email\n'
              'subject: Daily Check CSV\n\n'
              'Please find the attached CSV file for the daily check.\n\n'
              'Attachment: ${file.path}'));

        try {
          await gmailApi.users.messages.send(emailMessage, 'me');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV sent to $email')),
          );
        } catch (e) {
          print('Failed to send email: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send CSV')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Check Screen',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: exportToCSVAndSendEmail,
          ),
        ],
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}