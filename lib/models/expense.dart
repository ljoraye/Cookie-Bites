class Expense {
  final String id;
  final String name;
  final DateTime date;
  final String description;
  final String category;
  final double amount;

  const Expense({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    required this.category,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
        'expense_name': name,
        'description': description,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      name: map['expense_name'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
