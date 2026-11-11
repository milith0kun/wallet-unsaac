enum MovementType { income, expense }

class Movement {
  const Movement({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final MovementType type;
  final DateTime date;

  bool get isIncome => type == MovementType.income;
  double get signedAmount => isIncome ? amount : -amount;
}
