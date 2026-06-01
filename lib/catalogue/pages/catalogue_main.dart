import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogueMain extends ConsumerStatefulWidget {
  final int subscribedServiceId;
  const CatalogueMain({super.key, required this.subscribedServiceId});

  @override
  ConsumerState<CatalogueMain> createState() => _CatalogueMainState();
}

class _CatalogueMainState extends ConsumerState<CatalogueMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.subscribedServiceId.toString()),
    );
  }
}
