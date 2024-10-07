class CartItem {
  final String name;
  final double price;
  final String sugarLevel;
  final String iceLevel;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.sugarLevel,
    required this.iceLevel,
    required this.quantity,
  });

  CartItem copyWith({
    String? name,
    double? price,
    String? sugarLevel,
    String? iceLevel,
    int? quantity,
  }) {
    return CartItem(
      name: name ?? this.name,
      price: price ?? this.price,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      iceLevel: iceLevel ?? this.iceLevel,
      quantity: quantity ?? this.quantity,
    );
  }
}
