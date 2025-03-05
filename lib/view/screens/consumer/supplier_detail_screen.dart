import 'package:flutter/material.dart';
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
        iconTheme: IconThemeData(color: Colors.white),
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
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(supplier['phone'] ?? 'No phone available', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),

                // Products List
                const Text("Products:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: products.isEmpty
                      ? const Center(child: Text("No products available"))
                      : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      List<dynamic> sizesAndPrices = product['sizesAndPrices'] ?? [];
                      List<dynamic> imageUrls = product['imageUrls'] ?? [];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Text(
                                product['productName'] ?? 'Unknown',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),

                              // Product Description
                              // Text(
                              //   product['productDescription'] ?? '',
                              //   style: const TextStyle(fontSize: 14, color: Colors.black87),
                              // ),
                              // const SizedBox(height: 10),

                              // Product Images (if available)
                              if (imageUrls.isNotEmpty)
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageUrls.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            imageUrls[index],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.image_not_supported, size: 100),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 10),

                              // Sizes and Prices
                              const Text("Sizes & Prices:",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Column(
                                children: sizesAndPrices.map((sizePrice) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Size: ${sizePrice['size']}",
                                          style: const TextStyle(fontSize: 14)),
                                      Text("Price: ${sizePrice['price']} PKR",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ],
                                  );
                                }).toList(),
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
