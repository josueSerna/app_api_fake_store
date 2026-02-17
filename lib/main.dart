import 'package:flutter/material.dart';
import 'package:ds_atomic/ds_atomic.dart';
import 'package:package_fake_store/pages/categories_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fake Store',
      theme: DsTheme.lightTheme,
      home: const CategoriesPage(),
    );
  }
}
