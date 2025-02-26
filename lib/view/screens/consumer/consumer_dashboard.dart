import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';
import '../../../viewModel/locationOndashscreens.dart';
import 'consumer_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEditing = false;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationViewModel>(context, listen: false).fetchUserLocation();
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
          locationController.text = locationProvider.userLocation ?? "No location available";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Location:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: isEditing
                          ? TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter your location",
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            isEditing = false;
                          });
                        },
                      )
                          : GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            locationProvider.userLocation ?? "Click to enter location",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.location_on, color: Colors.blue),
                      onPressed: () => locationProvider.requestLocationPermission(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
