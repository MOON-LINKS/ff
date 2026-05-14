import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/item/types/custom_type.dart';
import 'package:moonlinks/menu/elements/item/types/custom_types_editor.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class ItemTypes extends StatefulWidget {
  final dynamic types;
  final Function(List<Map<String, dynamic>>)? onTypeChanged;
  const ItemTypes({super.key, required this.types, this.onTypeChanged});

  @override
  State<ItemTypes> createState() => _ItemTypesState();
}

class _ItemTypesState extends State<ItemTypes> {
  bool isEditorOpen = false;
  Map<String, dynamic>? selectedType;
  List<Map<String, dynamic>> editedTypes = [];
  @override
  void initState() {
    super.initState();
    editedTypes = widget.types != null
        ? List<Map<String, dynamic>>.from(
            (widget.types as List).map((e) => Map<String, dynamic>.from(e)))
        : [];
    if (widget.onTypeChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTypeChanged!(editedTypes);
      });
    }
  }

  void addNewType() {
    setState(() {
      selectedType = null;
      isEditorOpen = !isEditorOpen;
    });
  }

  void onSaveType(Map<String, dynamic> newType) {
    setState(() {
      if (selectedType != null) {
        final index =
            editedTypes.indexWhere((t) => t['uuid'] == newType['uuid']);
        if (index != -1) editedTypes[index] = newType;
      } else {
        editedTypes.add(newType);
      }
      isEditorOpen = false;
      selectedType = null;
      widget.onTypeChanged!(editedTypes);
    });
  }

  void onDeleteType(String id) {
    setState(() {
      editedTypes.removeWhere((t) => t['uuid'] == id);
      widget.onTypeChanged!(editedTypes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CustomMenuTitle(child: '${AppLocalizations.of(context)!.menu_types}:'),
        CustomMenuButton(
            onPressed: addNewType, child: isEditorOpen ? '-' : '+'),

        CustomTypesEditor(
            key: ValueKey(selectedType != null ? selectedType!['uuid'] : 'new'),
            isOpen: isEditorOpen,
            type: selectedType,
            onSave: onSaveType),
        //list of types
        editedTypes.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: editedTypes.map<Widget>((itemType) {
                  return CustomType(
                    itemType: itemType,
                    onDelete: () => onDeleteType(itemType['uuid']),
                    onEdit: () {
                      setState(() {
                        selectedType = Map<String, dynamic>.from(itemType);
                        isEditorOpen = true;
                      });
                    },
                  );
                }).toList(),
              )
      ],
    );
  }
}
