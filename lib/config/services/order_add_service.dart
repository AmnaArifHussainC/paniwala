import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder({
    required String userId,
    required String userName,
    required String userPhone,
    required String userAddress,
    required String productName,
    required String quantitySize,
  }) async {
    try {
      final orderId = _firestore.collection('orders').doc().id;

      OrderModel newOrder = OrderModel(
        orderId: orderId,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        userAddress: userAddress,
        productName: productName,
        quantitySize: quantitySize,
        orderDate: DateTime.now(),
      );

      // Save the order in a subcollection under the user's document
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .set(newOrder.toFirestore());
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }
}
