import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/user_cubit.dart';
import '../cubits/wallet_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/marketplace_item.dart';
import '../models/transaction_item.dart';

class BuyDialog extends StatefulWidget {
  final MarketplaceItem item;

  const BuyDialog({super.key, required this.item});

  @override
  State<BuyDialog> createState() => _BuyDialogState();
}

class _BuyDialogState extends State<BuyDialog> {
  String paymentMethod = 'balance';
  final cardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state;
    final wallet = context.watch<WalletCubit>().state;

    final canUseBalance = wallet.balance >= widget.item.price;

    return AlertDialog(
      title: Text('Buy ${widget.item.name}'),
      content: SingleChildScrollView(

        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: [
            widget.item.imageUrl.startsWith('/')
                ? Image.file(File(widget.item.imageUrl), height: 120, fit: BoxFit.cover)
                : Image.asset(widget.item.imageUrl, height: 120, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text("Price: €${widget.item.price.toStringAsFixed(2)}"),
            const SizedBox(height: 16),
            RadioListTile(
              value: 'balance',
              groupValue: paymentMethod,
              onChanged: canUseBalance ? (v) => setState(() => paymentMethod = v as String) : null,
              title: Text("Pay from balance (€${wallet.balance.toStringAsFixed(2)})"),
              subtitle: !canUseBalance ? const Text("Insufficient funds", style: TextStyle(color: Colors.red)) : null,
            ),
            RadioListTile(
              value: 'card',
              groupValue: paymentMethod,
              onChanged: (v) => setState(() => paymentMethod = v as String),
              title: const Text("Pay with card"),
            ),
            if (paymentMethod == 'card')
              TextField(
                controller: cardController,
                decoration: const InputDecoration(
                  labelText: "Card number",
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final userId = user.userId;

            if (widget.item.sellerId == userId) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You can't buy your own item")),
              );
              return;
            }

            final cubit = context.read<MarketplaceCubit>();
            final walletCubit = context.read<WalletCubit>();

            cubit.buyItem(widget.item.id, userId);

            if (paymentMethod == 'balance') {
              walletCubit.addTransaction(TransactionItem(
                id: 'buy-${DateTime.now().millisecondsSinceEpoch}',
                description: 'Bought: ${widget.item.name}',
                amount: -widget.item.price,
                date: DateTime.now(),
              ));
            }

            Navigator.pop(context);
          },
          child: const Text("Confirm Purchase"),
        )
      ],
    );
  }
}
