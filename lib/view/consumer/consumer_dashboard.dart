import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    fetchUserLocation();
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

    String fullAddress = " ${place.street ?? ''}, ${place.subLocality ?? ''}, "
        "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

    setState(() {
      userLocation = fullAddress.isNotEmpty ? fullAddress : "Address not available.";
      locationController.text = userLocation;
    });
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

      // Save location in the user's document using their UID
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'location': locationController.text
      }, SetOptions(merge: true));

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
  Future<void> fetchSuppliers() async {
    try {
      setState(() => isLoading = true);

      // Fetch suppliers from Firestore
      final querySnapshot =
      await FirebaseFirestore.instance.collection('suppliers').get();
      print('Fetched suppliers: ${querySnapshot.docs.length}');

      final fetchedSuppliers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id, // Store supplier's document ID
          'companyName': data['company_name'] ?? 'Unknown Company',
          'email': data['email'] ?? 'No Email Provided',
          'phone': data['phone'] ?? 'No Phone Number',
          'address': data['address'] ?? 'No Address Available',
        };
      }).toList();

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
                    onPressed: fetchUserLocation, // Ensure this function is defined
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: searchSuppliers,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search by Location....',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2)),
                ),
              ),
            ),
            // Supplier List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSuppliers.isEmpty
                  ? const Center(
                child: Text(
                  'No suppliers available at the moment.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = filteredSuppliers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          supplier['companyName'].isNotEmpty
                              ? supplier['companyName']
                              .substring(0, 1)
                              .toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        supplier['companyName'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  supplier['email'],
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 16, color: Colors.grey),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => openWhatsApp(supplier['phone']),
                                child: Text(
                                  supplier['phone'],
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  supplier['address'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SupplierProductListsForCustomers(
                                  userId: uid,
                                  supplierId: supplier['id'],
                                  companyName: supplier['companyName'],
                                ),
                          ),
                        );
                      },
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