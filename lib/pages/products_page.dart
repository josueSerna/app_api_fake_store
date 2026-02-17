import 'package:flutter/material.dart';
import 'package:ds_atomic/ds_atomic.dart';
import 'package:fake_store_client/fake_store_client.dart';
import 'package:package_fake_store/pages/product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  final String category;

  const ProductsPage({super.key, required this.category});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final StoreService _service = StoreService();

  bool _isLoading = true;
  List<Product>? _products;
  ApiFailure? _failure;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final (products, failure) = await _service.getProductsByCategory(
      widget.category,
    );

    setState(() {
      _isLoading = false;
      _products = products;
      _failure = failure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryTitle =
        widget.category[0].toUpperCase() + widget.category.substring(1);

    if (_isLoading) {
      return DsBaseTemplate(
        title: categoryTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_failure != null) {
      return DsBaseTemplate(
        title: categoryTitle,
        body: Center(
          child: DSText(_failure!.message, style: DsTypography.body),
        ),
      );
    }

    final productItems = _products!
        .map(
          (product) => ProductItem(
            imageUrl: product.image,
            title: product.title,
            price: '\$${product.price}',
          ),
        )
        .toList();

    return DsProductsPage(
      title: categoryTitle,
      products: productItems,
      onProductTap: (item) {
        final product = _products![productItems.indexOf(item)];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(productId: product.id),
          ),
        );
      },
    );
  }
}
