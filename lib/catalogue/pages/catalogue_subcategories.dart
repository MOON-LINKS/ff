import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogueSubcategories extends ConsumerStatefulWidget {
  final String catUuid;
  const CatalogueSubcategories({super.key, required this.catUuid});

  @override
  ConsumerState<CatalogueSubcategories> createState() =>
      _CatalogueSubcategoriesState();
}

class _CatalogueSubcategoriesState
    extends ConsumerState<CatalogueSubcategories> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
