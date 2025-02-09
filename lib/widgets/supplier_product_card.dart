import 'package:flutter/material.dart';

class SupplierProductCard extends StatelessWidget {
  final String productId; // Add productId for deletion
  final String productName;
  final String description;
  final double price;
  final List<String> sizes;
  final List<String> images;
  final VoidCallback onDelete; // Callback for delete action

  const SupplierProductCard({
    Key? key,
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.sizes,
    required this.images,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: onDelete,
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red.shade800,),
                    )),
                // IconButton(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   onPressed: onDelete, // Trigger the delete action
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: \$${price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              "Sizes: ${sizes.join(", ")}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
