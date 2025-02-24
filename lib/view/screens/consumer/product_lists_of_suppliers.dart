// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:paniwala/view/consumer/product_details_with_orderScreen.dart';
//
// import '../complaints_feedback/complaintAndFeedback.dart';
//
// class SupplierProductListsForCustomers extends StatefulWidget {
//   final String supplierId;
//   final String companyName;
//   final String userId; // Ensure you pass the user's ID
//
//
//   SupplierProductListsForCustomers({
//     required this.supplierId,
//     required this.companyName,
//     required this.userId,
//   });
//
//   @override
//   _SupplierProductListsForCustomersState createState() =>
//       _SupplierProductListsForCustomersState();
// }
//
// class _SupplierProductListsForCustomersState
//     extends State<SupplierProductListsForCustomers> {
//   List<Map<String, dynamic>> products = [];
//   bool isLoading = true;
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//
//   Future<void> fetchProducts() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('suppliers')
//           .doc(widget.supplierId)
//           .collection('products')
//           .get();
//
//       final fetchedProducts = querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           'id': doc.id, // Include the document ID
//           'name': data['productName'] ?? 'Unnamed Product',
//           'price': data['productPrice'] ?? 'N/A',
//           'description': data['productDescription'] ?? 'No description available.', // Fetch description
//           'imageUrls': (data['imageUrls'] as List<dynamic>?) ?? [], // Ensure it's a list
//         };
//       }).toList();
//
//       setState(() {
//         products = fetchedProducts;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching products: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load products. Please try again.')),
//       );
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.companyName, style: TextStyle(color: Colors.white)),
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => RateSupplierScreen(
//                     supplierId: widget.supplierId,
//                     companyName: widget.companyName,
//                   ),
//                 ),
//               );
//             },
//             icon: Icon(CupertinoIcons.archivebox_fill, color: Colors.white),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : products.isEmpty
//           ? const Center(
//           child: Text('No products available for this supplier.'))
//           : Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // "All Products" Title
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "All Products",
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           // Product Grid
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.7,
//                 ),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final product = products[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(10)),
//                           child: product['imageUrls'].isNotEmpty
//                               ? Image.network(
//                             product['imageUrls'][0],
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Center(child: CircularProgressIndicator());
//                             },
//                             errorBuilder: (context, error, stackTrace) {
//                               print('Image load error: $error'); // Debugging
//                               return Container(
//                                 height: 120,
//                                 color: Colors.grey[300],
//                                 child: const Icon(
//                                     Icons.error, size: 50, color: Colors.red),
//                               );
//                             },
//                           )
//
//
//                               : Container(
//                             height: 120,
//                             color: Colors.grey[300],
//                             child: const Icon(Icons.image, size: 50),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product['name'],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 'Price: Rs.${product['price']}',
//                                 style: const TextStyle(color: Colors.blue),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ProductsDetailForConsumer(
//                                     product: {
//                                       ...product, // Pass all product details
//                                       'supplierId': widget.supplierId, // Ensure supplierId is included
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             ),
//                             child: const Text("Buy Now",
//                                 style: TextStyle(color: Colors.white)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
