import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';
import '../../../viewModel/locationOndashscreens.dart';
import 'consumer_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final locationViewModel = Provider.of<LocationViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await locationViewModel.hasLocationPermission();
      if (!hasPermission) {
        final permissionGranted = await locationViewModel.requestLocationPermission();
        if (permissionGranted) {
          await locationViewModel.fetchCurrentLocation();
          // Assuming latitude and longitude are available
          await locationViewModel.fetchSublocality(0.0, 0.0); // Replace with actual lat/lng
          if (locationViewModel.sublocality != null) {
            await locationViewModel.fetchSuppliersInSublocality(locationViewModel.sublocality!);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required to proceed.')),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pani Wala", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomUserDrawer(authViewModel: AuthViewModel()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: locationViewModel.address ?? 'Fetching location...',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            locationViewModel.sublocality != null
                ? Expanded(
              child: ListView.builder(
                itemCount: locationViewModel.suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = locationViewModel.suppliers[index];
                  return Card(
                    child: ListTile(
                      title: Text(supplier['companyName'] ?? 'Unknown'),
                      subtitle: Text(supplier['email'] ?? 'No email'),
                    ),
                  );
                },
              ),
            )
                : const Center(child: Text('No suppliers available in your sublocality.')),
          ],
        ),
      ),
    );
  }
}
