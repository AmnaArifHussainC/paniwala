import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/authProviderViewModel.dart';
import '../../../viewModel/consumerDashScreenViewModelPro.dart';
import 'consumer_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<DashScreenProvider>(context);
    // final filteredSuppliers = provider.suppliers.where((supplier) {
    //   final companyName = supplier['address']?.toLowerCase() ?? '';
    //   return companyName.contains(provider.searchQuery);
    // }).toList();

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
                      // controller: provider.locationController,
                      decoration: const InputDecoration(
                        hintText: 'Your Location',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location, color: Colors.blue),
                    // onPressed: provider.fetchUserLocation,
                    onPressed: (){},
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    // onPressed: provider.saveLocationToFirestore,
                    onPressed: (){},
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // onChanged: provider.searchSuppliers,
                onTap: (){},
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
            // Expanded(
            //   child: provider.isLoading
            //       ? const Center(child: CircularProgressIndicator())
            //       : filteredSuppliers.isEmpty
            //       ? const Center(
            //     child: Text(
            //       'No suppliers available at the moment.',
            //       style: TextStyle(fontSize: 16, color: Colors.grey),
            //     ),
            //   )
            //       : ListView.builder(
            //     itemCount: filteredSuppliers.length,
            //     itemBuilder: (context, index) {
            //       final supplier = filteredSuppliers[index];
            //       return Card(
            //         margin: const EdgeInsets.symmetric(
            //             vertical: 8.0, horizontal: 10.0),
            //         child: ListTile(
            //           leading: CircleAvatar(
            //             backgroundColor: Colors.blue,
            //             child: Text(
            //               supplier['companyName'].isNotEmpty
            //                   ? supplier['companyName']
            //                   .substring(0, 1)
            //                   .toUpperCase()
            //                   : '?',
            //               style:
            //               const TextStyle(color: Colors.white),
            //             ),
            //           ),
            //           title: Text(supplier['companyName']),
            //           subtitle: Text(supplier['address']),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
