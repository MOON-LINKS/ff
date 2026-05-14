import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_color_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:uuid/uuid.dart';

class CustomTypesEditor extends StatefulWidget {
  final bool isOpen;
  final dynamic type;
  final Function(Map<String, dynamic>) onSave;
  const CustomTypesEditor(
      {super.key, required this.isOpen, this.type, required this.onSave});

  @override
  State<CustomTypesEditor> createState() => _CustomTypesEditorState();
}

class _CustomTypesEditorState extends State<CustomTypesEditor> {
  late TextEditingController titleController;
  late Color backSelectedColor;
  late Color textSelectedColor;
  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.type != null ? widget.type!['title'] ?? '' : '',
    );

    backSelectedColor = widget.type != null && widget.type!['backColor'] != null
        ? Color(widget.type!['backColor'])
        : Colors.black;

    textSelectedColor = widget.type != null && widget.type!['textColor'] != null
        ? Color(widget.type!['textColor'])
        : Colors.white;
  }

  void saveType() {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(AppLocalizations.of(context)!.menu_title_cannot_be_empty)));
      return;
    }
    final newType = {
      'uuid': widget.type?['uuid'] ?? 'type-${Uuid().v4()}',
      'title': title,
      'backColor': backSelectedColor.toARGB32(),
      'textColor': textSelectedColor.toARGB32(),
    };
    widget.onSave(newType);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();
    final isNew = widget.type == null;
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.purple, width: 2),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        spacing: 10,
        children: [
          CustomMenuInput(
            controller: titleController,
            function: (_) {},
            hintText: AppLocalizations.of(context)!.menu_enter_type,
          ),
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomColorPicker(
                  color: backSelectedColor.toARGB32(),
                  newColor: (color) {
                    setState(() {
                      backSelectedColor = Color(color);
                    });
                  },
                  text: AppLocalizations.of(context)!.menu_background),
              CustomColorPicker(
                  color: textSelectedColor.toARGB32(),
                  newColor: (color) {
                    setState(() {
                      textSelectedColor = Color(color);
                    });
                  },
                  text: AppLocalizations.of(context)!.menu_text)
            ],
          ),
          const SizedBox(height: 10),
          CustomMenuButton(
              onPressed: saveType,
              child: isNew
                  ? AppLocalizations.of(context)!.menu_add_type
                  : AppLocalizations.of(context)!.menu_edit_type)
        ],
      ),
    );
  }
}
