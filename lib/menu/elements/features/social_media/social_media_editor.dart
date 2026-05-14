import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class SocialMediaEditor extends ConsumerStatefulWidget {
  final VoidCallback closeEditor;
  const SocialMediaEditor({super.key, required this.closeEditor});

  @override
  ConsumerState<SocialMediaEditor> createState() => _SocialMediaEditorState();
}

class _SocialMediaEditorState extends ConsumerState<SocialMediaEditor> {
  String? icon;
  List<String> icons = [];
  final _mediaUrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    icons = List<String>.from(ref.read(menuProvider)['assets']['media']);
  }

  @override
  void dispose() {
    _mediaUrl.dispose();
    super.dispose();
  }

  String formattedUrl(String? icon, String input) {
    if (icon!.contains('whatsapp')) {
      return 'https://wa.me/$input';
    } else if (icon.contains('phone') || icon.contains('mobile')) {
      return 'tel:$input';
    }
    return input;
  }

  void saveMedia() {
    final media = ref.read(menuProvider)['payload']['social_media'];
    List<dynamic> existingMedia = (media['media'] as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (icon != null && icon!.isNotEmpty && _mediaUrl.text.isNotEmpty) {
      existingMedia.add({
        'icon': icon,
        'url': formattedUrl(icon, _mediaUrl.text),
        'order': existingMedia.length
      });
      ref.read(menuProvider.notifier).addOrUpdateInfo(
          'social_media', {'enabled': true, 'media': existingMedia});
      widget.closeEditor();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!
              .menu_social_media_validation_hint)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.screenWidth * (context.isWide ? .3 : .8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: widget.closeEditor,
                  icon: Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                  )),
            ),
            Row(
              spacing: 10,
              children: [
                //icon list
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: DropdownButtonFormField<String>(
                          value: icon,
                          isDense: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                          ),
                          itemHeight: 80,
                          selectedItemBuilder: (context) {
                            return icons.map((fileName) {
                              return Center(
                                  child: SizedBox(
                                width: 60,
                                child: SvgPicture.network(
                                  'https://cdn.moonlinks.me/media/$fileName',
                                  fit: BoxFit.contain,
                                ),
                              ));
                            }).toList();
                          },
                          items: icons.map((fileName) {
                            return DropdownMenuItem<String>(
                                value: fileName,
                                child: Center(
                                    child: SvgPicture.network(
                                  'https://cdn.moonlinks.me/media/$fileName',
                                  fit: BoxFit.contain,
                                )));
                          }).toList(),
                          onChanged: (value) => setState(() {
                                icon = value;
                              }),
                          icon: Icon(Icons.arrow_drop_down_circle_outlined,
                              color: Colors.purple),
                          focusColor: Colors.purple),
                    )),

                //url input
                Expanded(
                  flex: 4,
                  child: CustomMenuInput(
                    function: (_) {},
                    hintText: AppLocalizations.of(context)!.menu_link_url,
                    controller: _mediaUrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .menu_media_url_required;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            CustomMenuButton(
                onPressed: saveMedia,
                child: AppLocalizations.of(context)!.menu_save_media)
          ],
        ));
  }
}
