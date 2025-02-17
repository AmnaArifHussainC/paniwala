import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/product_model.dart';
import '../../../view_model/product_viewmodel.dart';

class SupplierProductsScreen extends StatefulWidget {
  final String supplierId;

  const SupplierProductsScreen({super.key, required this.supplierId});

  @override
  _SupplierProductsScreenState createState() => _SupplierProductsScreenState();
}

class _SupplierProductsScreenState extends State<SupplierProductsScreen> {
  final ProductViewModel _productViewModel = ProductViewModel();
  bool _isLoading = true;
  String? _errorMessage;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _products = await _productViewModel.fetchProducts(widget.supplierId);
    } catch (e) {
      _errorMessage = 'Failed to fetch products: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    // Show a confirmation dialog before proceeding with deletion
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // User does not want to delete
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: CupertinoColors.inactiveGray),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed deletion
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),

            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(true); // User confirmed deletion
            //   },
            //   child: Text(
            //     'Delete',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
          ],
        );
      },
    );

    // If the user confirms deletion, proceed with deleting the product
    if (confirmDelete == true) {
      try {
        await _productViewModel.deleteProduct(widget.supplierId, productId);
        setState(() {
          _products.removeWhere((product) => product.id == productId);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: $e')),
        );
      }
    }
  }

  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Supplier Products",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _products.isEmpty
                  ? const Center(child: Text("No products available."))
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        ProductModel product = _products[index];
                        return Card(
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.productName,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(product.productDescription,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 180,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.imageUrls.length,
                                    itemBuilder: (context, imgIndex) {
                                      return GestureDetector(
                                        onTap: () => _showFullImage(
                                            product.imageUrls[imgIndex]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              product.imageUrls[imgIndex],
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text("Available Sizes & Prices:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                const SizedBox(height: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: product.sizesAndPrices.map((size) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Text(
                                          "${size['size']}L : Rs.${size['price']}",
                                          style: TextStyle(fontSize: 16)),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () => _deleteProduct(product.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text("Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
