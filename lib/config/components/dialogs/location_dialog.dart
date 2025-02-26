import 'package:flutter/material.dart';

import '../../../viewModel/locationOndashscreens.dart';

void showLocationDialog(BuildContext context, LocationViewModel locationProvider) {
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
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                await locationProvider.updateUserLocation(manualLocationController.text);
                Navigator.pop(context);
              },
              icon: Icon(Icons.edit, color: Colors.white),
              label: Text(
                "Save Manual Location",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                await locationProvider.saveUserLocation();
                Navigator.pop(context);
              },
              icon: Icon(Icons.location_on, color: Colors.white),
              label: Text(
                "Fetch Current Location",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}
