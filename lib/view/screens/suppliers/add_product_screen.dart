import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/core/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:paniwala/viewModel/product_view_model.dart';
import '../../../config/components/custome_widgets/custome_btn_auth.dart';
import '../../../config/components/custome_widgets/custome_text_field.dart';
import '../../../core/utils/image_pick.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AuthService authservice = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  bool isRefill = false;
  List<Map<String, dynamic>> sizesAndPrices = [];
  List<File> imageFiles = [];

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

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

  void removeImage(int index) {
    setState(() {
      imageFiles.removeAt(index);
    });
  }

  void addSizePriceField() {
    setState(() {
      sizesAndPrices.add({'size': '', 'price': ''});
    });
  }

  void removeSizePriceField(int index) {
    setState(() {
      sizesAndPrices.removeAt(index);
    });
  }

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
      productName: productNameController.text,
      productDescription: productDescriptionController.text,
      imagePaths: imageFiles.map((file) => file.path).toList(),
      sizesAndPrices: sizesAndPrices,
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully!")),
      );
      Navigator.pop(context);
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                textinputtype: TextInputType.text,
                validator: (value) => value!.isEmpty ? "Required" : null,
                hintText: 'Enter product name',
                icon: Icons.shopping_bag,
                controller: productNameController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textinputtype: TextInputType.text,
                validator: (value) => value!.isEmpty ? "Required" : null,
                hintText: 'Enter product description',
                icon: Icons.description,
                controller: productDescriptionController,
              ),
              SwitchListTile(
                title: const Text("Is Refill?"),
                value: isRefill,
                onChanged: (value) => setState(() => isRefill = value),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sizesAndPrices.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildTextField('Size', 'e.g., 500ml', (value) => sizesAndPrices[index]['size'] = value),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField('Price', 'e.g., 100', (value) => sizesAndPrices[index]['price'] = double.tryParse(value) ?? 0.0, isNumber: true),
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
              SizedBox(
                  width: double.infinity,
                  child: CustomButton(text: "Add Size & Price", onPressed: addSizePriceField)),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  child: CustomButton(text: "Pick Images", onPressed: pickMultipleImages)),
              const SizedBox(height: 10),
              Wrap(
                children: imageFiles.asMap().entries.map((entry) {
                  int index = entry.key;
                  File file = entry.value;
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.8)),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              productViewModel.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                  width: double.infinity,
                  child: CustomButton(text: "Add Product", onPressed: () => submitProduct(productViewModel))),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildTextField(String label, String hint, Function(String) onChanged, {bool isNumber = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, hintText: hint, border: OutlineInputBorder()),
      validator: (value) => value!.isEmpty ? "Required" : null,
      onChanged: onChanged,
    ),
  );
}
