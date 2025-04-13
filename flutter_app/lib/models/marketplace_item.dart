//TODO: simplified of course, in real life there should be much more complex model
class MarketplaceItem {
  final String id;
  final String imageUrl;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String location;
  final bool isSold;
  final String sellerId;
  final String? buyerId;
  final double? latitude;
  final double? longitude;

  MarketplaceItem({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.location,
    required this.sellerId,
    this.isSold = false,
    this.buyerId,
    required this.latitude,
    required this.longitude,
  });

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['id'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      location: json['location'],
      sellerId: json['sellerId'],
      buyerId: json['buyerId'],
      isSold: json['isSold'] ?? false,
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'location': location,
      'isSold': isSold,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}
