import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/marketplace_item.dart';
import '../models/transaction_item.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../cubits/wallet_cubit.dart';
import '../widgets/item_tile.dart';
import '../widgets/login_inline_view.dart';
import 'balance_details_screen.dart';
import '../dialogs/withdraw_dialog.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedTab = 0;

  @override
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    if (authState is AuthInitial) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (authState is AuthLoggedOut || authState is AuthLoginError) {
      return const LoginInlineView();
    }

    final wallet = context.watch<WalletCubit>().state;
    final userId = "user"; //

    final items = context.watch<MarketplaceCubit>().state;
    final soldItems = items.itemsSold(userId);

    final soldTransactions = soldItems.map((item) {
      return TransactionItem(
        id: item.id,
        description: 'Sold: ${item.name}',
        amount: item.price,
        date: DateTime.now(), //TODO: Replace with item.soldAt
      );
    }).toList();

    final List<TransactionItem> transactions = [
      ...soldTransactions,
      ...wallet.transactions,
    ]..sort((a, b) => b.date.compareTo(a.date));

    List<MarketplaceItem> visibleItems;

    if (_selectedTab == 0) {
      visibleItems = items.itemsForSale(userId);
    } else if (_selectedTab == 1) {
      visibleItems = items.itemsSold(userId);
    } else {
      visibleItems = items.itemsBought(userId);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Column(
        children: [
          // Balance section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Balance",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "€${wallet.balance.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BalanceDetailsScreen(transactions: transactions),
                          ),
                        );
                      },
                      child: const Text("View Details"),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const WithdrawDialog(),
                        );
                      },
                      child: const Text("Withdraw"),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab("For Sale", 0),
                _buildTab("Sold", 1),
                _buildTab("Bought", 2),
              ],
            ),
          ),

          const Divider(),

          // Item List
          Expanded(
            child: ListView.builder(
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                return ItemTile(item: item);
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(height: 2, width: 40, color: Colors.blue)
        ],
      ),
    );
  }
}

