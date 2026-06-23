import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moonlinks/catalogue/elements/features/socialmedia/catalogue_socialmedia_editor.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueSocialMediaEnabled extends ConsumerStatefulWidget {
  const CatalogueSocialMediaEnabled({super.key});

  @override
  ConsumerState<CatalogueSocialMediaEnabled> createState() =>
      _CatalogueSocialMediaEnabledState();
}

class _CatalogueSocialMediaEnabledState
    extends ConsumerState<CatalogueSocialMediaEnabled> {
  bool editorOpen = false;

  void deleteLink(int index) {
    final mediaState = ref.read(catalogueProvider)['payload']['social_media'];
    final medias = (mediaState['media'] as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    medias.removeAt(index);
    for (int i = 0; i < medias.length; i++) {
      medias[i]['order'] = i;
    }
    ref.read(catalogueProvider.notifier).addOrUpdateInfo(
        'social_media', {'enabled': mediaState['enabled'], 'media': medias});
  }

  @override
  Widget build(BuildContext context) {
    final mediaNumber =
        ref.watch(catalogueProvider)['features']['social_media'];
    final mediaState = ref.watch(catalogueProvider)['payload']['social_media'];
    final medias = mediaState['media'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 120,
          title: AppLocalizations.of(context)!.menu_social_media_title,
          toolTip: AppLocalizations.of(context)!.menu_social_media_tooltip,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomMenuCheckbox(
                value: mediaState['enabled'],
                onChanged: (val) {
                  ref.read(catalogueProvider.notifier).addOrUpdateInfo(
                      'social_media', {'enabled': val, 'media': medias});
                }),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${AppLocalizations.of(context)!.menu_used}: ${medias.length}/$mediaNumber',
          style: TextStyle(
              color: medias.length == mediaNumber
                  ? Colors.yellowAccent
                  : Colors.greenAccent),
        ),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Column(
                  spacing: 10,
                  children: [
                    if (medias.length < mediaNumber && !editorOpen)
                      CustomMenuButton(
                          onPressed: () {
                            setState(() {
                              editorOpen = true;
                            });
                          },
                          child: AppLocalizations.of(context)!.menu_add_link),
                    if (editorOpen)
                      CatalogueSocialMediaEditor(
                        closeEditor: () => setState(() {
                          editorOpen = false;
                        }),
                      ),
                    Container(
                        height: 200,
                        width:
                            context.screenWidth * (context.isWide ? 0.4 : .8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ReorderableListView(
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > oldIndex) newIndex--;
                              final updatedMedias = (medias as List)
                                  .map((e) => Map<String, dynamic>.from(e))
                                  .toList();
                              final media = updatedMedias.removeAt(oldIndex);
                              updatedMedias.insert(newIndex, media);
                              for (int i = 0; i < updatedMedias.length; i++) {
                                updatedMedias[i]['order'] = i;
                              }
                              ref
                                  .read(catalogueProvider.notifier)
                                  .addOrUpdateInfo(
                                'social_media',
                                {
                                  'enabled': mediaState['enabled'],
                                  'media': updatedMedias,
                                },
                              );
                            },
                            children: [
                              for (int i = 0; i < medias.length; i++)
                                ReorderableDragStartListener(
                                    key: ValueKey('$i-${medias[i]['url']}'),
                                    index: i,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        width: context.screenWidth *
                                            (context.isWide ? .4 : .8),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 2))),
                                        child: Column(
                                          spacing: 5,
                                          children: [
                                            Row(spacing: 10, children: [
                                              IconButton(
                                                  onPressed: () =>
                                                      deleteLink(i),
                                                  icon: Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: Colors.purple,
                                                  )),
                                              SvgPicture.network(
                                                'https://cdn.moonlinks.me/media/${medias[i]['icon']}',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            ]),
                                            Text(medias[i]['url'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14))
                                          ],
                                        )))
                            ])),
                  ],
                ),
                if (!mediaState['enabled'])
                  Positioned.fill(
                      child: Stack(
                    children: [
                      Container(
                        color: const Color.fromARGB(120, 155, 39, 176),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      )
                    ],
                  ))
              ],
            ))
      ],
    );
  }
}
