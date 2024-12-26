import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventorySearchDelegate extends SearchDelegate {
  final CollectionReference inventoryCollection;

  InventorySearchDelegate(this.inventoryCollection);

  @override
  String get searchFieldLabel => 'Lục kho của Xofa';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: inventoryCollection
          .where('Name', isGreaterThanOrEqualTo: query)
          .where('Name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final results = snapshot.data!.docs;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            final data = item.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['Name']),
              subtitle: Text('Code: ${data['Id']}'),
              trailing: Text('Quantity: ${data['Quantity']}'),
              onTap: () {
                close(context, null);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(data['Name']),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Code: ${data['Id']}'),
                          SizedBox(height: 10.0),
                          Text('Quantity: ${data['Quantity']}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: inventoryCollection
          .where('Name', isGreaterThanOrEqualTo: query)
          .where('Name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final suggestions = snapshot.data!.docs;

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            final data = item.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['Name']),
              subtitle: Text('Code: ${data['Id']}'),
              // trailing: Text('Quantity: ${data['Quantity']}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(data['Name']),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Code: ${data['Id']}'),
                          SizedBox(height: 10.0),
                          Text('Quantity: ${data['Quantity']}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}