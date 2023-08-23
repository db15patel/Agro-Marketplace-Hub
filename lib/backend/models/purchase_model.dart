import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  String productName;
  String amount;
  String totalAmount;
  String quantity;
  String purchaseId;
  Timestamp createdAt;

  PurchaseModel();

  PurchaseModel.fromMap(Map<String, dynamic> data) {
    productName = data['productName'];
    amount = data['amount'];
    totalAmount = data['totalAmount'];
    quantity = data['quantity'];
    purchaseId = data['purchaseId'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'amount': amount,
      'totalAmount': totalAmount,
      'quantity': quantity,
      'purchaseId': purchaseId,
      'createdAt': createdAt,
    };
  }
}
