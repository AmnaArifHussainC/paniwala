import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paniwala/view/consumer/all_suppliers_screen.dart' show AllSuppliersScreen;
import 'package:url_launcher/url_launcher.dart';
import 'package:paniwala/view/consumer/product_lists_of_suppliers.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';
import 'consumer_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> suppliers = [];
  bool isLoading = true;
  String searchQuery = '';
  String userLocation = "Fetching location...";
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
    loadSavedLocation();
  }

  Future<void> loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('saved_location');

    setState(() {
      userLocation = savedLocation ?? "Fetching location...";
      locationController.text = userLocation;
    });
  }

  Future<void> fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => userLocation = "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => userLocation = "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => userLocation = "Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    String fullAddress = "${place.street ?? ''}, ${place.subLocality ?? ''}, "
        "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

    setState(() {
      userLocation = fullAddress.isNotEmpty ? fullAddress : "Address not available.";
      locationController.text = userLocation;
    });

    // Save to SharedPreferences so it's persistent
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_location', userLocation);
  }

  Future<void> saveLocationToFirestore(BuildContext context, TextEditingController locationController) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      // Save location in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'location': locationController.text
      }, SetOptions(merge: true));

      // Save location in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_location', locationController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location saved successfully!')),
      );
    } catch (e) {
      print('Error saving location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save location.')),
      );
    }
  }


  //fetch
  Future<void> fetchSuppliers() async {
    try {
      setState(() => isLoading = true);

      final querySnapshot =
      await FirebaseFirestore.instance.collection('suppliers').get();
      print('Fetched suppliers: ${querySnapshot.docs.length}');

      List<Map<String, dynamic>> fetchedSuppliers = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        double avgRating = await getAverageRating(doc.id); // Fetch average rating

        fetchedSuppliers.add({
          'id': doc.id,
          'companyName': data['company_name'] ?? 'Unknown Company',
          'email': data['email'] ?? 'No Email Provided',
          'phone': data['phone'] ?? 'No Phone Number',
          'address': data['address'] ?? 'No Address Available',
          'avgRating': avgRating, // Store the average rating
        });
      }

      setState(() {
        suppliers = fetchedSuppliers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching suppliers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load suppliers. Please try again.')),
      );
      setState(() => isLoading = false);
    }
  }

// Function to calculate average rating of a supplier
  Future<double> getAverageRating(String supplierId) async {
    try {
      final ratingSnapshot = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .collection('ratings')
          .get();

      if (ratingSnapshot.docs.isEmpty) return 0.0; // No ratings yet

      double totalRating = 0.0;
      int count = ratingSnapshot.docs.length;

      for (var doc in ratingSnapshot.docs) {
        totalRating += (doc.data()['rating'] ?? 0.0).toDouble();
      }

      return totalRating / count; // Calculate average
    } catch (e) {
      print('Error fetching ratings: $e');
      return 0.0;
    }
  }

  void searchSuppliers(String query) {
    setState(() => searchQuery = query.toLowerCase());
  }

  void openWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch WhatsApp");
    }
  }
  @override
  Widget build(BuildContext context) {
    final filteredSuppliers = suppliers.where((supplier) {
      final companyName = supplier['address']?.toLowerCase() ?? '';
      return companyName.contains(searchQuery);
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

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
            // Location Input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: 'Your Location',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2,
                          )
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location, color: Colors.blue),
                    onPressed: fetchUserLocation,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => saveLocationToFirestore(context, locationController),
                    child: const Text("Save", style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),

            // Suppliers List Header with "See All"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Suppliers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllSuppliersScreen()),
                      );
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}