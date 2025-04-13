import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/wallet_cubit.dart';
import '../../cubits/user_cubit.dart';

class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({super.key});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  String? selectedAccount;
  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletCubit>().state;
    final user = context.watch<UserCubit>().state;

    return AlertDialog(
      title: const Text('Withdraw Funds'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Withdraw to'),
            value: selectedAccount,
            items: user.withdrawalAccounts.map((account) {
              return DropdownMenuItem(value: account, child: Text(account));
            }).toList(),
            onChanged: (value) => setState(() => selectedAccount = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final parsed = double.tryParse(value);
              setState(() => amount = parsed ?? 0.0);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (selectedAccount != null && amount > 0 && amount <= wallet.balance)
              ? () {
            context.read<WalletCubit>().withdraw(amount);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Withdrawal successful")),
            );
            Navigator.pop(context);
          }
              : null,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
