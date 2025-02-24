import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';
import '../../../viewModel/location_on_dash_screens.dart';
import 'consumer_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Access LocationViewModel from context
    final locationViewModel = Provider.of<LocationViewModel>(context);

    // Trigger location fetching when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await locationViewModel.hasLocationPermission();
      if (!hasPermission) {
        final permissionGranted = await locationViewModel.requestLocationPermission();
        if (permissionGranted) {
          await locationViewModel.fetchCurrentLocation();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required to proceed.'),
            ),
          );
        }
      }
    });

    // Mocked suppliers for demo purposes
    final filteredSuppliers = []; // Replace with actual suppliers data

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("Pani Wala", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: CustomUserDrawer(authViewModel: AuthViewModel()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true, // Make the field read-only
                decoration: InputDecoration(
                  hintText: locationViewModel.address ?? 'Fetching location...',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            // Add more widgets here...
          ],
        ),
      ),
    );
  }
}
