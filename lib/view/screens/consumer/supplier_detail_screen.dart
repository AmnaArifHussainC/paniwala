import 'package:flutter/material.dart';
import 'package:paniwala/core/utils/whatsapp_msg.dart' show openWhatsApp;
import 'package:provider/provider.dart';

import '../../../viewModel/supplier_viewmodal.dart';

class SupplierDetailScreen extends StatefulWidget {
  final String supplierId;

  const SupplierDetailScreen({super.key, required this.supplierId});

  @override
  _SupplierDetailScreenState createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupplierViewModel>(context, listen: false)
          .fetchSupplierDetails(widget.supplierId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Supplier Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<SupplierViewModel>(
        builder: (context, supplierProvider, child) {
          if (supplierProvider.supplier == null) {
            return const Center(child: CircularProgressIndicator());
          }

          var supplier = supplierProvider.supplier!;
          var products = supplierProvider.products;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Supplier Info
                Text(supplier['company_name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        supplier['location'] ?? 'Not available',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        if (supplier['phone'] != null) {
                          openWhatsApp(supplier['phone']!);
                        }
                      },
                      child: Text(
                        supplier['phone'] ?? 'No phone available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,  // Make it look clickable
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(supplier['email'] ?? 'No email available', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),

                // Products Grid
                const Text("Products:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: products.isEmpty
                      ? const Center(child: Text("No products available"))
                      : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75, // Controls height
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      List<dynamic> sizesAndPrices = product['sizesAndPrices'] ?? [];
                      List<dynamic> imageUrls = product['imageUrls'] ?? [];

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image (if available)
                              if (imageUrls.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrls.first, // Show only first image
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 100),
                                  ),
                                ),
                              const SizedBox(height: 6),

                              // Product Name
                              Text(
                                product['productName'] ?? 'Unknown',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),

                              if (sizesAndPrices.isNotEmpty)
                                Text(
                                  "Size: ${sizesAndPrices.first['size']}\nPrice: ${sizesAndPrices.first['price']} PKR",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
