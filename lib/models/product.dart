import '../main.dart';

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

/// Shared product list used by both the Order Entry Form and Manage
/// Products. Loaded once after login via [loadFromSupabase]; `items` then
/// acts as an in-memory cache so the rest of the app can read it
/// synchronously without every screen needing its own loading state.
class ProductCatalog {
  ProductCatalog._();

  static final List<Product> items = [];

  static Future<void> loadFromSupabase() async {
    final rows =
        await supabase.from('products').select().order('name', ascending: true);

    items
      ..clear()
      ..addAll((rows as List).map((row) => _fromRow(row as Map<String, dynamic>)));
  }

  static Future<void> add(Product product) async {
    final row = await supabase
        .from('products')
        .insert({
          'user_id': supabase.auth.currentUser!.id,
          'name': product.name,
          'selling_price': product.sellingPrice,
          'cost_of_goods': product.costOfGoods,
        })
        .select()
        .single();

    items.add(_fromRow(row));
  }

  static Future<void> remove(String id) async {
    await supabase.from('products').delete().eq('id', id);
    items.removeWhere((p) => p.id == id);
  }

  static Product _fromRow(Map<String, dynamic> row) {
    return Product(
      id: row['id'] as String,
      name: row['name'] as String,
      sellingPrice: (row['selling_price'] as num).toDouble(),
      costOfGoods: (row['cost_of_goods'] as num).toDouble(),
    );
  }
}
