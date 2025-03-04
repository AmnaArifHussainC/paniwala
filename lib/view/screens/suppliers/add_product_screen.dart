import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/core/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:paniwala/viewModel/product_view_model.dart';
import '../../../core/utils/image_pick.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AuthService authservice = AuthService();
  final _formKey = GlobalKey<FormState>();
  String productName = "";
  String productDescription = "";
  bool isRefill = false;
  List<Map<String, dynamic>> sizesAndPrices = [];
  List<File> imageFiles = [];

  // Get current user ID
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Pick multiple images
  Future<void> pickMultipleImages() async {
    try {
      List<File> pickedImages = await ImagePickerUtil.pickMultipleImages();
      if (pickedImages.isNotEmpty) {
        setState(() {
          imageFiles.addAll(pickedImages);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick images: $e")),
      );
    }
  }

  // Add new size & price entry
  void addSizePriceField() {
    setState(() {
      sizesAndPrices.add({'size': '', 'price': ''});
    });
  }

  // Remove size & price entry
  void removeSizePriceField(int index) {
    setState(() {
      sizesAndPrices.removeAt(index);
    });
  }

  // Validate and submit form
  void submitProduct(ProductViewModel productViewModel) {
    if (!_formKey.currentState!.validate()) return;

    if (imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one image.")),
      );
      return;
    }

    final String? currentUserId = getCurrentUserId();

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in! Please log in first.")),
      );
      return;
    }

    productViewModel.addProduct(
      supplierId: currentUserId,
      isRefill: isRefill,
      productName: productName,
      productDescription: productDescription,
      imagePaths: imageFiles.map((file) => file.path).toList(),
      sizesAndPrices: sizesAndPrices,
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully!")),
      );
      Navigator.pop(context); // Navigate back after adding product
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add product: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Product Name', 'Enter product name', (value) => productName = value),
              _buildTextField('Description', 'Enter product description', (value) => productDescription = value),

              SwitchListTile(
                title: const Text("Is Refill?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                value: isRefill,
                activeColor: Colors.blueAccent,
                onChanged: (value) => setState(() => isRefill = value),
              ),

              const SizedBox(height: 10),
              const Text("Sizes & Prices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sizesAndPrices.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildTextField('Size', 'e.g., 500ml', (value) => sizesAndPrices[index]['size'] = value)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('Price', 'e.g., 100', (value) => sizesAndPrices[index]['price'] = double.tryParse(value) ?? 0.0, isNumber: true)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeSizePriceField(index),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: addSizePriceField,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Size & Price",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),

              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: pickMultipleImages,
                icon: const Icon(Icons.image, color: Colors.white),
                label: const Text("Pick Images",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),

              const SizedBox(height: 10),
              Wrap(
                children: imageFiles.map((file) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 20),
              productViewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () => submitProduct(productViewModel),
                child: const Text("Add Product", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        validator: (value) => value!.isEmpty ? "Required" : null,
        onChanged: onChanged,
      ),
    );
  }
}
