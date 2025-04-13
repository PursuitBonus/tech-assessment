import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/marketplace_item.dart';

class MarketplaceState {
  final List<MarketplaceItem> allItems;
  final String searchQuery;

  const MarketplaceState({
    this.allItems = const [],
    this.searchQuery = '',
  });

  List<MarketplaceItem> itemsForSale(String userId) =>
      allItems.where((item) => item.sellerId == userId && !item.isSold).toList();

  List<MarketplaceItem> itemsSold(String userId) =>
      allItems.where((item) => item.sellerId == userId && item.isSold).toList();

  List<MarketplaceItem> itemsBought(String userId) =>
      allItems.where((item) => item.buyerId == userId).toList();

  List<MarketplaceItem> get availableItems {
    final base = allItems.where((item) => !item.isSold).toList();
    if (searchQuery.isEmpty) return base;

    final query = searchQuery.toLowerCase();
    return base.where((item) =>
    item.name.toLowerCase().contains(query) ||
        item.location.toLowerCase().contains(query)
    ).toList();
  }

  MarketplaceState copyWith({
    List<MarketplaceItem>? allItems,
    String? searchQuery,
  }) {
    return MarketplaceState(
      allItems: allItems ?? this.allItems,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MarketplaceCubit extends Cubit<MarketplaceState> {
  MarketplaceCubit() : super(const MarketplaceState()) {
    loadItems();
  }

  Future<void> loadItems() async {
    final jsonString = await rootBundle.loadString('assets/data/items.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final items = jsonData.map((e) => MarketplaceItem.fromJson(e)).toList();
    emit(state.copyWith(allItems: items));
  }

  void addItem({
    required String name,
    required String location,
    required double price,
    required String imagePath,
    required String sellerId,
    required double latitude,
    required double longitude
  }) {
    final newItem = MarketplaceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      location: location,
      price: price,
      imageUrl: imagePath,
      description: '',
      quantity: 1,
      isSold: false,
      sellerId: sellerId,
      buyerId: '',
      latitude: latitude,
      longitude: longitude,

    );

    final updatedItems = [...state.allItems, newItem];

    emit(state.copyWith(allItems: updatedItems));
  }


  void buyItem(String itemId, String buyerId) {
    final updatedItems = state.allItems.map((item) {
      if (item.id == itemId && !item.isSold) {
        return MarketplaceItem(
          id: item.id,
          imageUrl: item.imageUrl,
          name: item.name,
          description: item.description,
          quantity: item.quantity,
          price: item.price,
          location: item.location,
          isSold: true,
          sellerId: item.sellerId,
          buyerId: buyerId,
          latitude: item.latitude,
          longitude: item.longitude,
        );
      }
      return item;
    }).toList();

    emit(state.copyWith(allItems: updatedItems));
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }
}

