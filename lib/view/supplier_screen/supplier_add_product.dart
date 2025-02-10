import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore/supplier_product.dart';

class AddProductScreen extends StatefulWidget {
  final String supplierId;

  const AddProductScreen({Key? key, required this.supplierId})
      : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  List<File> _uploadedImages = [];
  List<String> _sizes = [];
  final DatabaseService _databaseService = DatabaseService();

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _uploadedImages =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  void _addSize() {
    final size = _sizeController.text.trim();
    if (size.isNotEmpty) {
      setState(() {
        _sizes.add(size);
        _sizeController.clear();
      });
    }
  }

  void _removeSize(int index) {
    setState(() {
      _sizes.removeAt(index);
    });
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_sizes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please add at least one size.")),
        );
        return;
      }
      if (_uploadedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please add at least one image.")),
        );
        return;
      }

      final productName = _productNameController.text.trim();
      final description = _descriptionController.text.trim();
      final price = double.parse(_priceController.text.trim());

      try {
        final imageUrls = await Future.wait(
          _uploadedImages.map((image) =>
              _databaseService.uploadImage(widget.supplierId, image)),
        );

        await _databaseService.addProduct(
          supplierId: widget.supplierId,
          productName: productName,
          description: description,
          price: price,
          sizes: _sizes,
          images: imageUrls,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );

        _formKey.currentState?.reset();
        setState(() {
          _uploadedImages.clear();
          _sizes.clear();
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add product: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Add Product", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                    labelText: "Product Name",
                    labelStyle: const TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2))),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)
                  ),
                  labelText: "Description",
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? "Enter a description"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2)
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? "Enter a valid price"
                        : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2)
                        ),
                        labelText: "Size",
                        labelStyle: const TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addSize,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Add",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _sizes
                    .map(
                      (size) => Chip(
                        label: Text(size),
                        onDeleted: () => _removeSize(_sizes.indexOf(size)),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Upload Images",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _uploadedImages
                    .map(
                      (image) => Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child:
                    const Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
