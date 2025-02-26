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
  @override
  void initState() {
    super.initState();
    Provider.of<LocationViewModel>(context, listen: false).fetchUserLocation();
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
              ],
            ),
          );
        },
      ),
    );
  }
}
