import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String userName;
  final String userPhone;
  final String userAddress;
  final String productName;
  final String quantitySize;
  final DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.productName,
    required this.quantitySize,
    required this.orderDate,
  });

  // Convert Firestore data to OrderModel
  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      orderId: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userAddress: data['userAddress'] ?? '',
      productName: data['productName'] ?? '',
      quantitySize: data['quantitySize'] ?? '',
      orderDate: (data['orderDate'] as Timestamp).toDate(),
    );
  }

  // Convert OrderModel to Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'productName': productName,
      'quantitySize': quantitySize,
      'orderDate': orderDate,
    };
  }
}
