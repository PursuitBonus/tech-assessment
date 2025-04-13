import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/sell_item_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/user_cubit.dart';
import '../dialogs/buy_dialog.dart';
import '../models/marketplace_item.dart';
import '../cubits/marketplace_cubit.dart';
import 'map_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<MarketplaceCubit>().state.availableItems;

    return Scaffold(
      appBar: AppBar(title: const Text("Marketplace")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final auth = context.read<AuthCubit>().state;
          if (auth is AuthLoggedIn) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SellItemScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please log in to sell an item")),
            );
          }
        },
        label: const Text("Sell now"),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (query) {
                      context.read<MarketplaceCubit>().search(query);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MapScreen()),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Map"),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 per row for phones
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _MarketplaceTile(item: item);
              },
            ),
          )
        ],
      ),
    );
  }
}


class _MarketplaceTile extends StatelessWidget {
  final MarketplaceItem item;

  const _MarketplaceTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 250,
      ),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: open item details
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image
              SizedBox(
                height: 120,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: item.imageUrl.startsWith('/')
                      ? Image.file(File(item.imageUrl), fit: BoxFit.cover)
                      : Image.asset(item.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => BuyDialog(item: item),
                          );
                        },
                        child: Text("Buy • €${item.price.toStringAsFixed(2)}"),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



