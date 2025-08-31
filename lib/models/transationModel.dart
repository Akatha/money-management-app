import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String type; // "credit" or "debit"
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });

  // Convert Firestore -> Model
  factory TransactionModel.fromMap(Map<String, dynamic> map, String docId) {
    return TransactionModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'debit',
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  // Convert Model -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }
}
