import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pani Wala", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Deliver to\n📍 Lorem-500032",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const Text("8 Suppliers Found", style: TextStyle(color: Colors.grey)),
              ],
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
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Text("${supplier['rating']} (${supplier['reviews']} reviews)"),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      supplier['isFavorite'] ? Icons.favorite : Icons.favorite_border,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME",),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "FAVORITES"),
          BottomNavigationBarItem(icon: Icon(Icons.filter_list), label: "FILTER"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "CART"),
        ],
      ),
    );
  }
}
