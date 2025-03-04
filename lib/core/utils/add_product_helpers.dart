import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/core/utils/image_pick.dart';
import 'package:paniwala/viewModel/product_view_model.dart';

class ProductHelper {
  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> pickMultipleImages(List<File> imageFiles, Function(List<File>) updateImages, BuildContext context) async {
    try {
      List<File> pickedImages = await ImagePickerUtil.pickMultipleImages();
      if (pickedImages.isNotEmpty) {
        updateImages([...imageFiles, ...pickedImages]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick images: $e")),
      );
    }
  }

  static void removeImage(int index, List<File> imageFiles, Function(List<File>) updateImages) {
    List<File> updatedImages = List.from(imageFiles)..removeAt(index);
    updateImages(updatedImages);
  }

  static void addSizePriceField(List<Map<String, dynamic>> sizesAndPrices, Function(List<Map<String, dynamic>>) updateSizes) {
    List<Map<String, dynamic>> updatedSizes = List.from(sizesAndPrices)..add({'size': '', 'price': ''});
    updateSizes(updatedSizes);
  }

  static void removeSizePriceField(int index, List<Map<String, dynamic>> sizesAndPrices, Function(List<Map<String, dynamic>>) updateSizes) {
    List<Map<String, dynamic>> updatedSizes = List.from(sizesAndPrices)..removeAt(index);
    updateSizes(updatedSizes);
  }

  static void submitProduct(
      GlobalKey<FormState> formKey,
      BuildContext context,
      ProductViewModel productViewModel,
      TextEditingController productNameController,
      TextEditingController productDescriptionController,
      bool isRefill,
      List<File> imageFiles,
      List<Map<String, dynamic>> sizesAndPrices,
      ) {
    if (!formKey.currentState!.validate()) return;

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
}
