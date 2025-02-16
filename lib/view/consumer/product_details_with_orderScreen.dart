import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsDetailForConsumer extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductsDetailForConsumer({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductsDetailForConsumer> createState() => _ProductsDetailForConsumerState();
}

class _ProductsDetailForConsumerState extends State<ProductsDetailForConsumer> {
  bool isRefillAvailable = false;
  int quantity = 1;
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
    _checkRefillAvailability();
  }

  Future<void> _checkRefillAvailability() async {
    try {
      final productId = widget.product['id'] ?? '';
      final supplierId = widget.product['supplierId'] ?? '';

      if (productId.isEmpty || supplierId.isEmpty) {
        return;
      }

      final productDoc = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        final data = productDoc.data();
        setState(() {
          isRefillAvailable = data?['isRefill'] ?? false;
        });
      }
    } catch (e) {
      print("Error checking refill availability: $e");
    }
  }

  void _increaseQuantity() => setState(() => quantity++);
  void _decreaseQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }
  void _updateRating(double newRating) => setState(() => rating = newRating);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.product['name'], style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product['imageUrls'].isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CarouselSlider(
                    options: CarouselOptions(height: 250, autoPlay: true, enlargeCenterPage: true),
                    items: widget.product['imageUrls'].map<Widget>((imageUrl) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, size: 50, color: Colors.red),
                        ),
                      );
                    }).toList(),
                  ),
                )
              else
                Container(
                  height: 250,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
                  child: const Center(child: Icon(Icons.image, size: 50)),
                ),

              const SizedBox(height: 20),

              Text(widget.product['name'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(widget.product['description'] ?? 'No description available.',
                  style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 10),
              Text('Price: Rs.${widget.product['price']}',
                  style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                isRefillAvailable ? 'Refill is available' : 'Refill is not available',
                style: TextStyle(fontSize: 16, color: isRefillAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Quantity:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  IconButton(onPressed: _decreaseQuantity, icon: const Icon(Icons.remove, color: CupertinoColors.inactiveGray)),
                  Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: _increaseQuantity, icon: const Icon(Icons.add, color: CupertinoColors.inactiveGray)),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate the Supplier:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(5, (index) => IconButton(
                      onPressed: () => _updateRating(index + 1.0),
                      icon: Icon(index < rating ? Icons.star : Icons.star_border, color: Colors.amber),
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Purchase", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
