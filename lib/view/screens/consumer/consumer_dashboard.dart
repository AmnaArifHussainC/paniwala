import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/components/dialogs/location_dialog.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';
import '../../../viewModel/locationOndashscreens.dart';
import 'consumer_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> _suppliers = [];

  @override
  void initState() {
    super.initState();
    Provider.of<LocationViewModel>(context, listen: false).fetchUserLocation();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    List<DocumentSnapshot> suppliers = await Provider.of<LocationViewModel>(context, listen: false).fetchFilteredSuppliers();
    setState(() {
      _suppliers = suppliers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pani Wala", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomUserDrawer(authViewModel: AuthViewModel()),
      body: Consumer<LocationViewModel>(
        builder: (context, locationProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Location:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => showLocationDialog(context, locationProvider),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            locationProvider.userLocation ?? "Click to enter location",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Icon(Icons.edit, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Available Suppliers:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: _suppliers.length,
                    itemBuilder: (context, index) {
                      var supplier = _suppliers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4, // Adds a shadow effect
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Company Name
                              Text(
                                supplier['company_name'] ?? 'Unknown',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),

                              // Location (Wrapped to prevent overflow)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the top
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      supplier['location'] ?? 'Not available',
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true, // Ensures text wraps
                                      overflow: TextOverflow.visible, // Keeps the text readable
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              // Phone Number
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.green),
                                  SizedBox(width: 6),
                                  Text(
                                    supplier['phone'] ?? 'No phone available',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
