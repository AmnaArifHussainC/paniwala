import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'customer_order/customer-details-for-order.dart';

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
  List<Map<String, dynamic>> sizesAndPrices = [];
  String? selectedSize;
  double selectedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _checkRefillAvailability();
    _fetchSizesAndPrices();
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

  Future<void> _fetchSizesAndPrices() async {
    print("Fetching sizes and prices...");  // Debugging

    try {
      final productId = widget.product['id'] ?? '';
      final supplierId = widget.product['supplierId'] ?? '';

      if (productId.isEmpty || supplierId.isEmpty) {
        print("Product ID or Supplier ID is empty.");
        return;
      }

      final productDoc = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        print("Product document exists!"); // Debugging
        final data = productDoc.data();
        print("Firestore Data: $data"); // Debugging

        final List<dynamic> fetchedSizesAndPrices = data?['sizesAndPrices'] ?? [];

        if (fetchedSizesAndPrices.isNotEmpty) {
          setState(() {
            sizesAndPrices = List<Map<String, dynamic>>.from(fetchedSizesAndPrices);
            selectedSize = sizesAndPrices.first['size'];
            selectedPrice = (sizesAndPrices.first['price'] as num).toDouble();
          });

          print("Sizes and Prices: $sizesAndPrices"); // Debugging
          print("Selected Size: $selectedSize, Price: $selectedPrice"); // Debugging
        } else {
          print("No sizesAndPrices found.");
        }
      } else {
        print("Product document does not exist.");
      }
    } catch (e) {
      print("Error fetching sizes and prices: $e");
    }
  }

  void _selectSize(String size, double price) {
    setState(() {
      selectedSize = size;
      selectedPrice = price;
    });
  }

  Future<void> _showOrderDialog(BuildContext context) async {
    // Show confirmation dialog
    final bool? confirmOrder = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Order', style: TextStyle(fontWeight: FontWeight.w600,color: Colors.blue),),
          content: const Text('Are you sure you want to order this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No', style: TextStyle(color: CupertinoColors.inactiveGray),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes', style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );

    // Show success dialog if confirmed
    if (confirmOrder == true) {

      Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerDetailsForOrder()));
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

              // Size selection
              if (sizesAndPrices.isNotEmpty) ...[
                const Text('Select Size: (in litters)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: sizesAndPrices.map((sizeData) {
                    return ChoiceChip(
                      backgroundColor: Colors.blue.shade100,
                      label: Text(sizeData['size']),
                      selected: selectedSize == sizeData['size'],
                      onSelected: (isSelected) {
                        if (isSelected) {
                          _selectSize(sizeData['size'], sizeData['price'].toDouble());
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text('Price: Rs. $selectedPrice',
                    style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
              ],

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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showOrderDialog(context);
                  },
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
