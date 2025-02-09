import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  List<String> _uploadedImages = [];
  List<String> _sizes = []; // List to store sizes

  void _addSize() {
    final size = _sizeController.text.trim();
    if (size.isNotEmpty) {
      setState(() {
        _sizes.add(size);
        _sizeController.clear(); // Clear the input field after adding
      });
    }
  }

  void _removeSize(int index) {
    setState(() {
      _sizes.removeAt(index);
    });
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      if (_sizes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please add at least one size.")),
        );
        return;
      }

      // Collect product details
      final productName = _productNameController.text;
      final description = _descriptionController.text;
      final price = _priceController.text;

      debugPrint('Product Added: $productName, $description, $price, Sizes: $_sizes');

      // Clear the form
      _formKey.currentState?.reset();
      _uploadedImages.clear();
      _sizes.clear();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      "Add New Product",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product Name
                  const Text(
                    "Product Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      hintText: "Enter product name",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a product name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Enter product description",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price
                  const Text(
                    "Price",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      hintText: "Enter price",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the price";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sizes Section
                  const Text(
                    "Sizes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _sizeController,
                          decoration: const InputDecoration(
                            hintText: "Enter size (e.g., 20ml)",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addSize,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text("Add", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sizes
                        .asMap()
                        .entries
                        .map((entry) => Chip(
                      label: Text(entry.value),
                      onDeleted: () => _removeSize(entry.key),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Add Product",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
