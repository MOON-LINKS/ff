import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogueItem extends ConsumerStatefulWidget {
  final dynamic item;
  final VoidCallback updateItem;
  final VoidCallback deleteItem;
  const CatalogueItem(
      {super.key,
      required this.item,
      required this.updateItem,
      required this.deleteItem});

  @override
  ConsumerState<CatalogueItem> createState() => _CatalogueItemState();
}

class _CatalogueItemState extends ConsumerState<CatalogueItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
