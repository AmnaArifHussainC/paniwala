import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paniwala/view/consumer/product_lists_of_suppliers.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';
import 'consumer_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> suppliers = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      setState(() {
        isLoading = true;
      });

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
        SnackBar(content: Text('Failed to load suppliers. Please try again.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchSuppliers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSuppliers = suppliers.where((supplier) {
      final companyName = supplier['companyName']?.toLowerCase() ?? '';
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: searchSuppliers,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2))),
              ),
            ),
            // Supplier List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSuppliers.isEmpty
                      ? const Center(
                          child: Text('No suppliers available at the moment.'),
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
                                    supplier['companyName']
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(supplier['companyName']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.email, size: 16),
                                        const SizedBox(width: 5),
                                        Text(supplier['email']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 16),
                                        const SizedBox(width: 5),
                                        Text('Phone: ${supplier['phone']}'),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            'Address: ${supplier['address']}',
                                            style: const TextStyle(
                                                overflow: TextOverflow.clip),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SupplierProductListsForCustomers(
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
