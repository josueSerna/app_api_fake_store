import 'package:flutter/material.dart';
import 'package:ds_atomic/ds_atomic.dart';
import 'package:fake_store_client/fake_store_client.dart';
import 'package:package_fake_store/pages/products_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final StoreService _service = StoreService();

  bool _isLoading = true;
  List<String>? _categories;
  ApiFailure? _failure;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final (categories, failure) = await _service.getCategories();

    setState(() {
      _isLoading = false;
      _categories = categories;
      _failure = failure;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const DsBaseTemplate(
        title: 'Categorías',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_failure != null) {
      return DsBaseTemplate(
        title: 'Categorías',
        body: Center(
          child: DSText(_failure!.message, style: DsTypography.body),
        ),
      );
    }

    final items = _categories!
        .map(
          (category) => CatalogItem(
            title: category[0].toUpperCase() + category.substring(1),
          ),
        )
        .toList();

    return DsCatalogPage(
      title: 'Categorías',
      items: items,
      onItemTap: (item) {
        final category = _categories![items.indexOf(item)];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductsPage(category: category)),
        );
      },
    );
  }
}
