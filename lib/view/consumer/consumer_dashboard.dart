import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        isLoading = true; // Set loading to true before fetching
      });

      // Fetch the data from Firestore
      final querySnapshot = await FirebaseFirestore.instance.collection('suppliers').get();
      print('Fetched suppliers: ${querySnapshot.docs.length}'); // Debugging

      final fetchedSuppliers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'companyName': data['company_name'] ?? 'Unknown',
          'email': data['email'] ?? 'Unknown',
          'phone': data['phone'] ?? 'N/A',
        };
      }).toList();

      // Debugging to check fetched suppliers
      print('Parsed suppliers: $fetchedSuppliers');

      setState(() {
        suppliers = fetchedSuppliers;
        isLoading = false; // Loading complete
      });
    } catch (e) {
      print('Error fetching suppliers: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load suppliers. Please try again.')),
      );
      setState(() {
        isLoading = false; // Ensure loading stops on error
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
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
        ],
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
                onChanged: searchSuppliers,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Center(child: CircularProgressIndicator()),
              )
                  : filteredSuppliers.isEmpty
                  ? const Center(child: Text('No suppliers available at the moment.'))
                  : ListView.builder(
                itemCount: filteredSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = filteredSuppliers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(supplier['companyName'][0].toUpperCase()),
                      ),
                      title: Text(supplier['companyName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(supplier['email']),
                          Text('Phone: ${supplier['phone']}'),
                        ],
                      ),
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
