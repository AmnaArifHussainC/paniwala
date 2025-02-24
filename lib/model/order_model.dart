import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String userId; // Added User ID
  String supplierId; // Added Supplier ID
  String name;
  String phoneNumber;
  String address;
  bool dailyDelivery;
  String? deliveryTime;
  bool refill;
  Map<String, dynamic> product;
  int quantity;
  String? selectedSize;
  double totalPrice;
  Timestamp timestamp;

  OrderModel({
    required this.id,
    required this.userId,
    required this.supplierId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.dailyDelivery,
    this.deliveryTime,
    required this.refill,
    required this.product,
    required this.quantity,
    this.selectedSize,
    required this.totalPrice,
    required this.timestamp,
  });

  // Convert Firestore document to OrderModel
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      supplierId: data['supplierId'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      dailyDelivery: data['dailyDelivery'] ?? false,
      deliveryTime: data['deliveryTime'],
      refill: data['refill'] ?? false,
      product: data['product'] ?? {},
      quantity: data['quantity'] ?? 0,
      selectedSize: data['selectedSize'],
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert OrderModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "userId": userId, // Include User ID
      "supplierId": supplierId, // Include Supplier ID
      "name": name,
      "phoneNumber": phoneNumber,
      "address": address,
      "dailyDelivery": dailyDelivery,
      "deliveryTime": dailyDelivery ? deliveryTime : null,
      "refill": refill,
      "product": product,
      "quantity": quantity,
      "selectedSize": selectedSize,
      "totalPrice": totalPrice,
      "timestamp": timestamp,
    };
  }
}
