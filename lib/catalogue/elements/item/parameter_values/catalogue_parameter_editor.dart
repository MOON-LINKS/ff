import 'package:flutter/material.dart';

class CatalogueParameterEditor extends StatefulWidget {
  final dynamic parameters;
  final String? chosenParameter;
  final Function(Map<String, dynamic> parameter) addOrUpdateParameter;
  const CatalogueParameterEditor(
      {super.key,
      required this.parameters,
      this.chosenParameter,
      required this.addOrUpdateParameter});

  @override
  State<CatalogueParameterEditor> createState() =>
      _CatalogueParameterEditorState();
}

class _CatalogueParameterEditorState extends State<CatalogueParameterEditor> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
