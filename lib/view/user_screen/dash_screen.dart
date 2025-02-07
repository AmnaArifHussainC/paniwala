import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paniwala/view/user_screen/user_drawer.dart';

import '../../services/location/location_permission.dart';
import '../../utils/fetchLocation/fetch_location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? location;
  final PermissionAndPositionService _positionService = PermissionAndPositionService();
  final DetailedAddressService _addressService = DetailedAddressService();

  final List<Map<String, dynamic>> suppliers = [
    {
      'name': 'Eleanor',
      'status': 'Closed',
      'services': 'Big Tanker, Small Tanker, Water Cans',
      'rating': 4.5,
      'reviews': '2K',
      'image': 'https://via.placeholder.com/50',
      'isFavorite': true
    },
    {
      'name': 'Greg Watson',
      'status': 'Open',
      'services': 'Small Tanker, Water Cans',
      'rating': 3.1,
      'reviews': '25',
      'image': 'https://via.placeholder.com/50',
      'isFavorite': false
    },
    {
      'name': 'Randall Steward',
      'status': 'Open',
      'services': 'Big Tanker, Small Tanker, Water Cans',
      'rating': 4.5,
      'reviews': '1.8K',
      'image': 'https://via.placeholder.com/50',
      'isFavorite': true
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    try {
      Position position = await _positionService.fetchUserPosition();
      String detailedAddress = await _addressService.getDetailedAddress(position);
      setState(() {
        location = detailedAddress;
      });
    } catch (e) {
      setState(() {
        location = "Unable to fetch location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("Pani Wala", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomUserDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      location == null
                          ? "Fetching location..."
                          : "Deliver to\n📍 $location",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      softWrap: true,
                    ),
                  ),
                ],
              )

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(supplier['image']),
                    ),
                    title: Text(supplier['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(supplier['services'], style: const TextStyle(fontSize: 12)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text("${supplier['rating']} (${supplier['reviews']} reviews)"),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        supplier['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: supplier['isFavorite'] ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {},
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
