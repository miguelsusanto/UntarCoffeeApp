class MenuItem {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
  });
}

// List of menu items
List<MenuItem> menuItems = [
  MenuItem(
    name: 'Americano',
    price: 15000.0,
    description: 'Espresso and Air Mineral.',
    imageUrl: 'assets/americano.jpg',
    rating: 4.5,
  ),
  MenuItem(
    name: 'Kopi Susu Gula Aren',
    price: 19000.0,
    description: 'Kopi, Susu & Gula Aren.',
    imageUrl: 'assets/kopisusu.jpg',
    rating: 4.7,
  ),
  MenuItem(
    name: 'Latte',
    price: 22000.0,
    description: 'Espresso, Susu Steamed.',
    imageUrl: 'assets/latte.jpg',
    rating: 4.3,
  ),
  MenuItem(
    name: 'Cappucino',
    price: 22000.0,
    description: 'Espresso, Susu Steamed, Buih Susu.',
    imageUrl: 'assets/cappucino.jpg',
    rating: 4.6,
  ),
  MenuItem(
    name: 'Matcha Latte',
    price: 22000.0,
    description: 'Perpaduan fresh milk dan high quality matcha powder.',
    imageUrl: 'assets/matcha.jpg',
    rating: 4.7,
  ),
  MenuItem(
    name: 'Milo Dinosaurus',
    price: 24000.0,
    description: 'Susu Milo dengan taburan bubuk Milo.',
    imageUrl: 'assets/milo.jpg',
    rating: 4.5,
  ),
  MenuItem(
    name: 'Raspberry Hibiscus',
    price: 22000.0,
    description: 'Teh buah raspberry dan lemon.',
    imageUrl: 'assets/raspberry.jpg',
    rating: 4.9,
  ),
  MenuItem(
    name: 'Earl Grey Tea',
    price: 15000.0,
    description: 'Teh Melati Earl Grey.',
    imageUrl: 'assets/earlgrey.jpg',
    rating: 4.7,
  ),
  MenuItem(
    name: 'Cloud Caramel Machiato',
    price: 28000.0,
    description: 'Espresso, susu, sirup caramel, dan cloud foam susu dengan topping saus caramel.',
    imageUrl: 'assets/caramel.jpg',
    rating: 4.7,
  ),
  MenuItem(
    name: 'Susu Boba Gula Aren',
    price: 24000.0,
    description: 'Susu dan gula aren asli indonesia dengan tambahan golden boba.',
    imageUrl: 'assets/susuboba.jpg',
    rating: 4.5,
  ),
  MenuItem(
    name: 'Mocha Latte',
    price: 28000.0,
    description: 'Perpaduan klasik antara cokelat asli belanda dengan espresso.',
    imageUrl: 'assets/mocha.jpg',
    rating: 4.8,
  ),
  MenuItem(
    name: 'Avocado Coffee',
    price: 28000.0,
    description: 'Perpaduan Alpukat dipadu dengan espresso.',
    imageUrl: 'assets/avocado.jpg',
    rating: 4.7,
  ),
  MenuItem(
    name: 'Oreo Shake',
    price: 26000.0,
    description: 'Susu vanilla dengan remah Oreo.',
    imageUrl: 'assets/oreo.jpg',
    rating: 4.5,
  ),
  MenuItem(
    name: 'Lemon Black Tea',
    price: 15000.0,
    description: 'Black tea dengan lemon.',
    imageUrl: 'assets/lemon.jpg',
    rating: 4.7,
  ),
];