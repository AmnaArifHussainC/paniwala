import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paniwala/viewModel/product_view_model.dart';
import 'package:paniwala/core/services/auth_service.dart';
import '../../../config/components/custome_widgets/custome_btn_auth.dart';
import '../../../config/components/custome_widgets/custome_text_field.dart';
import '../../../core/utils/add_product_helpers.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  bool isRefill = false;
  List<Map<String, dynamic>> sizesAndPrices = [];
  List<File> imageFiles = [];

  void updateSizes(List<Map<String, dynamic>> updatedSizes) {
    setState(() {
      sizesAndPrices = updatedSizes;
    });
  }

  void updateImages(List<File> updatedImages) {
    setState(() {
      imageFiles = updatedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
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
                        onPressed: () => ProductHelper.removeSizePriceField(index, sizesAndPrices, updateSizes),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(text: "Add Size & Price", onPressed: () => ProductHelper.addSizePriceField(sizesAndPrices, updateSizes)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(text: "Pick Images", onPressed: () => ProductHelper.pickMultipleImages(imageFiles, updateImages, context)),
              ),
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
                          onTap: () => ProductHelper.removeImage(index, imageFiles, updateImages),
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
                child: CustomButton(
                  text: "Add Product",
                  onPressed: () => ProductHelper.submitProduct(_formKey, context, productViewModel, productNameController, productDescriptionController, isRefill, imageFiles, sizesAndPrices),
                ),
              ),
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
