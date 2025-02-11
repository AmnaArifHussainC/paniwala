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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete '$productName'?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onDelete(); // Trigger the delete action
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                "Price: Rs.${price.toStringAsFixed(2)}",
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
      ),
    );
  }
}
