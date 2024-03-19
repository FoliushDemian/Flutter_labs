class Transaction  {
  final String title;
  final double amount;

  Transaction({
    required this.title,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
  };

  static Transaction fromJson(Map<String, dynamic> json) => Transaction(
    title: json['title'] as String,
    amount: json['amount'] as double,
  );
}
