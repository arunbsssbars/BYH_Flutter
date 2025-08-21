import 'package:flutter/material.dart';
import 'package:one_stop_house_builder_app/screens/customer/customer_cart_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../../services/socket_service.dart';
import '../vendor/vendor_products.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});
  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<dynamic> products = [];
  List<dynamic> allProducts = [];
  String? selectedCategory;
  final api = ApiService('http://10.0.2.2:3000'); // change for device
  SocketService? socketService;

  // Example categories, replace with your own or fetch from API
  final List<String> categories = ['All', 'Electronics', 'Furniture', 'Tools', 'Paint'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    socketService = SocketService('http://10.0.2.2:3000');
    socketService?.connect(onProductUpdated: (data) {
      _loadProducts();
    });
  }

  @override
  void dispose() {
    socketService?.disconnect();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final p = await api.getProducts();
    setState(() {
      allProducts = p;
      products = _filterProducts(selectedCategory);
    });
  }

  List<dynamic> _filterProducts(String? category) {
    if (category == null || category == 'All') return allProducts;
    return allProducts.where((prod) => prod['category'] == category).toList();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      products = _filterProducts(category);
    });
    Navigator.pop(context); // Close the drawer
  }
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.electrical_services;
      case 'Furniture':
        return Icons.chair;
      case 'Tools':
        return Icons.build;
      case 'Paint':
        return Icons.format_paint;
      case 'All':
      default:
        return Icons.category;
    }
  }
  @override
  Widget build(BuildContext context) {
    
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
            ),
          ),
          child: Row(
            children: [
          const Icon(Icons.category, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          const Text(
            'Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 24, endIndent: 24),
            itemBuilder: (context, idx) {
          final cat = categories[idx];
          final selected = selectedCategory == cat || (cat == 'All' && selectedCategory == null);
          return ListTile(
            leading: Icon(
              _getCategoryIcon(cat),
              color: selected ? Colors.blueAccent : Colors.grey,
            ),
            title: Text(
              cat,
              style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.blueAccent : Colors.black87,
            fontSize: 18,
              ),
            ),
            selected: selected,
            selectedTileColor: Colors.blue.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () => _onCategorySelected(cat),
          );
            },
          ),
        ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Customer Home'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerCartScreen(),
                    ),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerCartScreen(),
                      ),
                    );
                  },               
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),                   
                        child: Text(
                          '${cart.items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ),
              ),  
            ],
          ),
        ],
      ),     
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (ctx, i) {
                  final p = products[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VendorProducts()),
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: p['id'],
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  'assets/images/images.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              p['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '₹${p['price']}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.add_shopping_cart, size: 18),
                              label: const Text('Add'),
                              onPressed: () {
                                cart.addItem(CartItem(
                                  id: p['id'],
                                  name: p['name'],
                                  price: (p['price'] as num).toDouble(),
                                  imageUrl: p['imageUrl'],
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${p['name']} added to cart'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
