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
  final FirebaseAuth  user = FirebaseAuth.instance;
  String? getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if no user is logged in
  }

  final _formKey = GlobalKey<FormState>();
  String productName = "";
  String productDescription = "";
  bool isRefill = false;
  List<Map<String, dynamic>> sizesAndPrices = [];
  List<File> imageFiles = [];

  // Pick multiple images using ImagePickerUtil
  Future<void> pickMultipleImages() async {
    List<File> pickedImages = await ImagePickerUtil.pickMultipleImages();
    if (pickedImages.isNotEmpty) {
      setState(() {
        imageFiles.addAll(pickedImages);
      });
    }
  }

  // Add new size and price entry
  void addSizePriceField() {
    setState(() {
      sizesAndPrices.add({'size': '', 'price': ''});
    });
  }

  // Remove size and price entry
  void removeSizePriceField(int index) {
    setState(() {
      sizesAndPrices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                value!.isEmpty ? "Enter product name" : null,
                onChanged: (value) => productName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value!.isEmpty ? "Enter product description" : null,
                onChanged: (value) => productDescription = value,
              ),
              SwitchListTile(
                title: const Text("Is Refill?"),
                value: isRefill,
                onChanged: (value) => setState(() => isRefill = value),
              ),
              const SizedBox(height: 10),
              const Text("Sizes & Prices", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sizesAndPrices.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Size'),
                          validator: (value) => value!.isEmpty ? "Enter size" : null,
                          onChanged: (value) => sizesAndPrices[index]['size'] = value,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter price" : null,
                          onChanged: (value) => sizesAndPrices[index]['price'] = double.tryParse(value) ?? 0.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeSizePriceField(index),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: addSizePriceField,
                child: const Text("Add Size & Price"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickMultipleImages,
                child: const Text("Pick Images"),
              ),
              Wrap(
                children: imageFiles
                    .map((file) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.file(file, width: 100, height: 100),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              productViewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && imageFiles.isNotEmpty) {
                      final String? currentUserId = getCurrentUserId();

                      if (currentUserId == null) {
                        print("Error: No user logged in!");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not logged in! Please log in first.")),
                        );
                        return;
                      }

                      productViewModel.addProduct(
                        supplierId: currentUserId, // Now it uses the actual logged-in user's ID
                        isRefill: isRefill,
                        productName: productName,
                        productDescription: productDescription,
                        imagePaths: imageFiles.map((file) => file.path).toList(),
                        sizesAndPrices: sizesAndPrices,
                      );
                    }
                  },
                child: const Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
