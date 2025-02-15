import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/custome_widgets/supplier_add_product_textformfield.dart';
import '../../../view_model/product_viewmodel.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final ProductViewModel _productViewModel = ProductViewModel();
  List<Map<String, dynamic>> sizesAndPrices = [];
  List<File> selectedImages = [];
  bool isRefillAvailable = false;
  final ImagePicker _picker = ImagePicker();

  Future<String?> getCurrentSupplierId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      return currentUser?.uid;
    } catch (e) {
      print('Error getting supplier ID: $e');
      return null;
    }
  }

  void addSizeAndPrice() {
    if (sizeController.text.isNotEmpty && priceController.text.isNotEmpty) {
      setState(() {
        sizesAndPrices.add({
          'size': sizeController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
        });
        sizeController.clear();
        priceController.clear();
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> submitProduct() async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty || sizesAndPrices.isEmpty || selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields and select an image.')),
      );
      return;
    }

    String? supplierId = await getCurrentSupplierId();
    if (supplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Supplier not logged in.')),
      );
      return;
    }

    await _productViewModel.uploadProduct(
      supplierId: supplierId,
      productName: nameController.text,
      productDescription: descriptionController.text,
      productPrice: sizesAndPrices.first['price'],
      imagePaths: selectedImages.map((file) => file.path).toList(),
    );

    if (_productViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_productViewModel.errorMessage!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(controller: nameController, labelText: 'Product Name'),
            const SizedBox(height: 15),
            CustomTextFormField(controller: descriptionController, labelText: "Description", isMultiline: true),
            const SizedBox(height: 20),
            Text('Add Sizes and Prices', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: CustomTextFormField(controller: sizeController, labelText: 'Liters (e.g. 20)', keyboardType: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(child: CustomTextFormField(controller: priceController, labelText: 'Price', keyboardType: TextInputType.number)),
                IconButton(icon: const Icon(Icons.add, color: Colors.blueAccent), onPressed: addSizeAndPrice),
              ],
            ),
            if (sizesAndPrices.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: sizesAndPrices.length,
                itemBuilder: (context, index) {
                  final sizePrice = sizesAndPrices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text('Size: ${sizePrice['size']} L'),
                      subtitle: Text('Price: Rs. ${sizePrice['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            sizesAndPrices.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.upload, color: Colors.white),
              label: const Text('Select Images', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            if (selectedImages.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selectedImages
                    .map((file) => Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            selectedImages.remove(file);
                          });
                        },
                      ),
                    ),
                  ],
                ))
                    .toList(),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Just Refill?', style: TextStyle(fontSize: 16)),
                Switch(
                  value: isRefillAvailable,
                  onChanged: (value) {
                    setState(() {
                      isRefillAvailable = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitProduct,
                child: const Text('Add Product', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
