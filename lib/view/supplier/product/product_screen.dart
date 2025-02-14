import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/custome_widgets/supplier_add_product_textformfield.dart';

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

  List<Map<String, dynamic>> sizesAndPrices = [];
  List<File> selectedImages = [];
  bool isRefillAvailable = false;
  final ImagePicker _picker = ImagePicker();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: nameController,
              labelText: 'Product Name',
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              controller: descriptionController,
              labelText: "Description",
              keyboardType: TextInputType.text,
              isMultiline: true,
            ),
            const SizedBox(height: 20),
            Text(
              'Add Sizes and Prices',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: sizeController,
                    labelText: 'Liters (e.g. 20)',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    controller: priceController,
                    labelText: 'Price',
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                  onPressed: addSizeAndPrice,
                ),
              ],
            ),
            if (sizesAndPrices.isNotEmpty) ...[
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sizesAndPrices.length,
                itemBuilder: (context, index) {
                  final sizePrice = sizesAndPrices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    elevation: 2,
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
            ],
            const SizedBox(height: 20),
            const Text(
              'Add Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
              label: const Text(
                'Select Images',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                        image: DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        ),
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
                const Text(
                  'Just Refill?',
                  style: TextStyle(fontSize: 16),
                ),
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
                onPressed: () {
                  // Submit logic or validation can be added here
                },
                child: const Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
