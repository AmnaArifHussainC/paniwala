import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paniwala/view/consumer/product_lists_of_suppliers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AllSuppliersScreen extends StatefulWidget {
  @override
  _AllSuppliersScreenState createState() => _AllSuppliersScreenState();
}

class _AllSuppliersScreenState extends State<AllSuppliersScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
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
        elevation: 0,
        title: const Text("All Suppliers",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10.0 : 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
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
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          supplier['avgRating'].toStringAsFixed(1), // Display rating
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SupplierProductListsForCustomers(
                            userId: userId,  // Add this line
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
    ]),
    )
      );

  }
}
