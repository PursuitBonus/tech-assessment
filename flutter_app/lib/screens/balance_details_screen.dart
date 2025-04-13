import 'package:flutter/material.dart';
import '../../models/transaction_item.dart';

class BalanceDetailsScreen extends StatelessWidget {
  final List<TransactionItem> transactions;

  const BalanceDetailsScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Balance Details')),
      body: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final isPositive = tx.amount >= 0;
          final formattedAmount =
              "${isPositive ? '+' : '-'}${tx.amount.abs().toStringAsFixed(2)} €";

          return ListTile(
            title: Text(tx.description),
            subtitle: Text(
              '${tx.date.day}/${tx.date.month}/${tx.date.year}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              formattedAmount,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}
