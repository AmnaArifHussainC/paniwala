import 'package:flutter/material.dart';
import 'package:paniwala/view/user_screen/user_drawer.dart';

class HomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Define small screen width threshold

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
            // Header Row (Deliver and Suppliers)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Deliver to\n📍 Lorem-500032",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text("8 Suppliers Found", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            // Search Bar
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
                  suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios, )),
                ),
              ),
            ),

            // Suppliers List
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
