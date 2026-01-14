class TransactionModel {
  final String id;
  final String type;
  final String amount;
  final String category;
  final String date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
  });

  /// Convert JSON → Object
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: json['type'],
      amount: json['amount'],
      category: json['category'],
      date: json['date'],
    );
  }

  /// Convert Object → JSON (for POST)
  Map<String, dynamic> toJson() {
    return {'type': type, 'amount': amount, 'category': category, 'date': date};
  }
}
