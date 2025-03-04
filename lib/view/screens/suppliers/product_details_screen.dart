import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/product_view_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product['productName'] ?? "Product Details"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                print("Product ID: ${product['id']}"); // Debugging print statement

                if (product['id'] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error: Product ID is missing"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Product"),
                    content: const Text("Are you sure you want to delete this product?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirmDelete == true) {
                  await productViewModel.deleteProduct(product['id']);
                  Navigator.pop(context); // Go back after deleting
                }
              },

          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display all product images
              if (product['imageUrls'] != null && product['imageUrls'].isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product['imageUrls'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['imageUrls'][index],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                ),
              const SizedBox(height: 20),

              Text(
                product['productName'] ?? "Unknown Product",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text(
                product['productDescription'] ?? "No description available",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Display all sizes with prices
              if (product['sizesAndPrices'] != null && product['sizesAndPrices'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Available Sizes & Prices:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(product['sizesAndPrices'].length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['sizesAndPrices'][index]['size']?.toString() ?? "Unknown Size",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "\$${product['sizesAndPrices'][index]['price']?.toString() ?? "N/A"}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),

                          ],
                        ),
                      );
                    }),
                  ],
                )
              else
                const Text("No size & price information available."),
            ],
          ),
        ),
      ),
    );
  }
}