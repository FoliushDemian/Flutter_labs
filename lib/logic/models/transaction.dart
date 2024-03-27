class Transaction  {
  final int id;
  final String title;
  final double amount;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
  };

  static Transaction fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as int,
    title: json['title'] as String,
    amount: json['amount'] as double,
  );
}
