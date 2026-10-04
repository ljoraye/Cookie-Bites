class Product {
  final String id;
  final String name;
  final double sellingPrice;
  final double costOfGoods;

  const Product({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.costOfGoods,
  });

  double get profitPerUnit => sellingPrice - costOfGoods;
}

/// A shared, in-memory product list used by both the Order Entry Form and
/// the Manage Products screen. This is mock/local for now — swap for a real
/// Supabase `products` table query once you're ready.
class ProductCatalog {
  ProductCatalog._();

  static final List<Product> items = [
    const Product(
        id: '1', name: 'Pistachio', sellingPrice: 140, costOfGoods: 70),
    const Product(
        id: '2', name: 'Matcha', sellingPrice: 110, costOfGoods: 55),
    const Product(
        id: '3', name: 'Biscoff', sellingPrice: 120, costOfGoods: 60),
  ];

  static void add(Product product) => items.add(product);

  static void remove(String id) => items.removeWhere((p) => p.id == id);
}
