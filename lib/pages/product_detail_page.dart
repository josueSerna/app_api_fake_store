import 'package:flutter/material.dart';
import 'package:ds_atomic/ds_atomic.dart';
import 'package:fake_store_client/fake_store_client.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final StoreService _service = StoreService();

  bool _isLoading = true;
  Product? _product;
  ApiFailure? _failure;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final (product, failure) = await _service.getProductById(widget.productId);

    setState(() {
      _isLoading = false;
      _product = product;
      _failure = failure;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const DsBaseTemplate(
        title: 'Detalle',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_failure != null) {
      return DsBaseTemplate(
        title: 'Detalle',
        body: Center(
          child: DSText(_failure!.message, style: DsTypography.body),
        ),
      );
    }

    final productDetail = ProductDetail(
      imageUrl: _product!.image,
      title: _product!.title,
      price: '\$${_product!.price}',
      category:
          _product!.category[0].toUpperCase() + _product!.category.substring(1),
      description: _product!.description,
    );

    return DsProductDetailPage(
      product: productDetail,
      onAddToCart: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: DSText('${_product!.title} agregado al carrito')),
        );
      },
    );
  }
}
