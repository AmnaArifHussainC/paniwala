import 'package:flutter/material.dart';
import 'package:paniwala/view/rider/rider_drawer.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rider Dashboard", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: RiderDrawer(authViewModel: AuthViewModel(),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available Orders",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.delivery_dining, color: Colors.blue),
                      title: Text("Order #${index + 1}"),
                      subtitle: Text("Delivery Location: XYZ"),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Accept"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}