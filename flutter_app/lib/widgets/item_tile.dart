import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';

class ItemTile extends StatelessWidget {
  final MarketplaceItem item;

  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: item.imageUrl.startsWith('/')
            ? Image.file(File(item.imageUrl), fit: BoxFit.cover)
            : Image.asset(item.imageUrl, fit: BoxFit.cover)

      ),
      title: Text(item.name),
      subtitle: Text(item.description),
      trailing: Text("€${item.price.toStringAsFixed(2)}"),
    );
  }
}