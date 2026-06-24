import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogueItems extends ConsumerStatefulWidget {
  final String catUuid;
  final String subcatUuid;
  const CatalogueItems(
      {super.key, required this.catUuid, required this.subcatUuid});

  @override
  ConsumerState<CatalogueItems> createState() => _CatalogueItemsState();
}

class _CatalogueItemsState extends ConsumerState<CatalogueItems> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
