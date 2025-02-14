import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'manage_supplier.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _filter = "Pending"; // Default filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Admin Panel",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text("Pending Requests"),
              onTap: () {
                setState(() {
                  _filter = "Pending";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Accepted Requests"),
              onTap: () {
                setState(() {
                  _filter = "Accepted";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Rejected Requests"),
              onTap: () {
                setState(() {
                  _filter = "Rejected";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Blocked Requests"),
              onTap: () {
                setState(() {
                  _filter = "Blocked";
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('admin')
            .doc('admin1')
            .collection('request')
            .where('status', isEqualTo: _filter)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No $_filter requests found."));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text("Supplier: ${request['email']}"),
                subtitle: Text("CNIC: ${request['cnic']}"),
                trailing: Text(request['status']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailsScreen(
                        supplierId: requests[index].id,
                        requestData: request,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
