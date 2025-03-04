import 'package:flutter/material.dart';
import 'package:paniwala/view/screens/suppliers/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:paniwala/viewModel/product_view_model.dart';

class SupplierProductsScreen extends StatefulWidget {
  @override
  _SupplierProductsScreenState createState() => _SupplierProductsScreenState();
}

class _SupplierProductsScreenState extends State<SupplierProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false).fetchSupplierProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ProductViewModel>(context, listen: false).fetchSupplierProducts();
        },
        child: productViewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productViewModel.supplierProducts.isEmpty
            ? const Center(
          child: Text(
            "No products added yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: productViewModel.supplierProducts.length,
            itemBuilder: (context, index) {
              final product = productViewModel.supplierProducts[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    // Navigate to the Product Details Screen with product data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: product['imageUrls'] != null && product['imageUrls'].isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product['imageUrls'][0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    title: Text(
                      product['productName'] ?? "Unknown Product",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      product['productDescription'] ?? "No description available",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product['sizesAndPrices'] != null && product['sizesAndPrices'].isNotEmpty
                              ? "Rs. ${product['sizesAndPrices'][0]['price']}"
                              : "N/A",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        const SizedBox(height: 5),
                        const Icon(Icons.shopping_cart, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
