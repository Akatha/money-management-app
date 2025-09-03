import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String type; // 'credit' or 'debit'
  final DateTime date;
  final String userId;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.userId,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'credit',
      userId: map['userId'] ?? '',
      date: map['date'] is String
          ? DateTime.parse(map['date'])
          : (map['date'] as Timestamp).toDate(), // Handles Firestore timestamp
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      'date': date,
      'userId': userId,
    };
  }
}
