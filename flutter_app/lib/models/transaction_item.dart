class TransactionItem {
  final String id;
  final String description;
  final double amount;
  final DateTime date;

  TransactionItem({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });
}