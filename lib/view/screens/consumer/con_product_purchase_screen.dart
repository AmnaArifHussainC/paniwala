import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductPurchase extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductPurchase({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    List<dynamic> imageUrls = product['imageUrls'] ?? [];
    List<dynamic> sizesAndPrices = product['sizesAndPrices'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['productName'] ?? 'Product Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Slider with CarouselSlider
              if (imageUrls.isNotEmpty)
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 300,
                        // Increased height for full image display
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 16 / 9,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayCurve: Curves.easeInOut,
                        enableInfiniteScroll: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: imageUrls.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            // Ensures the entire image is visible
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported,
                                    size: 100),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imageUrls.length,
                        (index) => Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              // Product Name
              Text(
                product['productName'] ?? 'Unknown Product',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      leading:
                          const Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Size: ${sizeData['size']}"),
                      subtitle: Text("Price: ${sizeData['price']} PKR"),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
