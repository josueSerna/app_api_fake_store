import 'package:flutter/material.dart';
import 'package:fake_store_client/fake_store_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final StoreService _service = StoreService();

  bool _isLoading = true;
  ApiFailure? _failure;
  List<Product>? _products;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final (products, failure) = await _service.getProducts();

    setState(() {
      _isLoading = false;
      _failure = failure;
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fake Store')),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _failure != null
              ? Center(
                  child: Text(
                    _failure!.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: _products!.length,
                  itemBuilder: (context, index) {
                    final product = _products![index];

                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
                    );
                  },
                ),
    );
  }
}
