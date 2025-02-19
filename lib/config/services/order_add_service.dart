import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/order_model.dart';

class OrderServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrderToFirestore({
    required String userId,
    required String supplierId,
    required String name,
    required String phoneNumber,
    required String address,
    required bool dailyDelivery,
    required String deliveryTime,
    required bool refill,
    required Map<String, dynamic> product,
    required int quantity,
    required String? selectedSize,
    required double totalPrice,
  }) async {
    try {
      DocumentReference orderRef = _firestore.collection("orders").doc();

      OrderModel order = OrderModel(
        id: orderRef.id, // Firestore generated ID
        userId: userId,
        supplierId: supplierId,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        dailyDelivery: dailyDelivery,
        deliveryTime: dailyDelivery ? deliveryTime : null,
        refill: refill,
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        totalPrice: totalPrice,
        timestamp: Timestamp.now(),
      );

      // Store order in global "orders" collection
      await orderRef.set(order.toMap());

      // Store order in user's subcollection
      await _firestore
          .collection("Users")
          .doc(userId)
          .collection("orders")
          .doc(orderRef.id)
          .set(order.toMap());

      // Store order in supplier's subcollection
      await _firestore
          .collection("suppliers")
          .doc(supplierId)
          .collection("orders")
          .doc(orderRef.id)
          .set(order.toMap());

    } catch (e) {
      throw Exception("Failed to place order: $e");
    }
  }
}
