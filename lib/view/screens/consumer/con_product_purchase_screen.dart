import 'package:flutter/material.dart';

class ProductPurchase extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductPurchase({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    List<dynamic> imageUrls = product['imageUrls'] ?? [];
    List<dynamic> sizesAndPrices = product['sizesAndPrices'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(product['productName'] ?? 'Product Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Slider
            if (imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrls[index],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              product['productName'] ?? 'Unknown Product',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Product Description
            Text(
              product['productDescription'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Sizes and Prices
            const Text("Available Sizes & Prices:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (sizesAndPrices.isNotEmpty)
              Column(
                children: sizesAndPrices.map((sizeData) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text("Size: ${sizeData['size']}"),
                    subtitle: Text("Price: ${sizeData['price']} PKR"),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
