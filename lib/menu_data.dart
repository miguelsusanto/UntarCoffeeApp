class MenuItem {
  final int? id; // id untuk menyimpan data unik di database
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;

  MenuItem({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
  });

  // Konversi object MenuItem menjadi map (untuk disimpan di database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }

  // Membaca object MenuItem dari map (diambil dari database)
  static MenuItem fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      rating: map['rating'],
    );
  }
}
