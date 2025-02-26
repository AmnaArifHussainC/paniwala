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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationViewModel>(context, listen: false).fetchUserLocation();
    });
  }


  void _showLocationDialog(BuildContext context, LocationViewModel locationProvider) {
    TextEditingController manualLocationController = TextEditingController(text: locationProvider.userLocation);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Location"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: manualLocationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Location Manually",
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                onPressed: () async {
                  await locationProvider.updateUserLocation(manualLocationController.text);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.edit, color: Colors.white,),
                label: Text("Save Manual Location", style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                onPressed: () async {
                  await locationProvider.saveUserLocation();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.location_on, color: Colors.white,),
                label: Text("Fetch Current Location", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
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
                  onTap: () => _showLocationDialog(context, locationProvider),
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
