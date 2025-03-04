import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paniwala/view/screens/suppliers/supplier_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:paniwala/view/screens/suppliers/supplier_drawer.dart';

import '../../../config/components/custome_widgets/supplier_dashboard_cards.dart';
import '../../../config/components/dialogs/location_dialog.dart';
import '../../../viewModel/location_on_dash_screens.dart';
import 'add_product_screen.dart';

class SupplierDashboardScreen extends StatefulWidget {
  const SupplierDashboardScreen({super.key});

  @override
  State<SupplierDashboardScreen> createState() =>
      _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<LocationViewModel>(context, listen: false).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String supplierId = currentUser?.uid ?? "unknownSupplierId";

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(supplierId: supplierId),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Supplier Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_sharp,
                              color: Colors.white,
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  showLocationDialog(context,
                                      Provider.of<LocationViewModel>(context, listen: false));
                                },
                                child: Consumer<LocationViewModel>(
                                  builder: (context, locationProvider, child) {
                                    return Text(
                                      locationProvider.userLocation ?? "Click to enter location",
                                      style: const TextStyle(color: Colors.white),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis, // Prevents text overflow
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  CustomSupplierCard(
                    icon: Icons.inventory,
                    title: 'Products',
                    subtitle: 'View and manage products',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupplierProductsScreen()),
                      );
                    },
                  ),
                  CustomSupplierCard(
                    icon: Icons.card_travel,
                    title: 'New Orders',
                    subtitle: 'Track new Orders here',
                    color: Colors.green,
                    onTap: () {
                      // Add navigation or action for deliveries
                    },
                  ),
                  CustomSupplierCard(
                    icon: Icons.analytics,
                    title: 'Pending orders',
                    subtitle: 'View pending orders status',
                    color: Colors.purple,
                    onTap: () {
                      // Add navigation or action for analytics
                    },
                  ),
                  CustomSupplierCard(
                    icon: Icons.cabin_sharp,
                    title: 'Payment',
                    subtitle: 'Manage payment status here',
                    color: Colors.blueGrey,
                    onTap: () {
                      // Add navigation or action for settings
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProductScreen()));
        },
        backgroundColor: Colors.blue,
        elevation: 2,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}