import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/features/animation/animation_item.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueAnimationEnabled extends ConsumerStatefulWidget {
  final Function(String) animationChange;
  const CatalogueAnimationEnabled({super.key, required this.animationChange});

  @override
  ConsumerState<CatalogueAnimationEnabled> createState() =>
      _CatalogueAnimationEnabledState();
}

class _CatalogueAnimationEnabledState
    extends ConsumerState<CatalogueAnimationEnabled> {
  final List<String> animationTypes = ['none', 'opacity', 'x-axis', 'y-axis'];
  bool shouldAnimate = false;
  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    String selectedAnimation = catalogueState['payload']['animation'] ?? 'none';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 100,
          title: AppLocalizations.of(context)!.menu_animation_title,
          toolTip: AppLocalizations.of(context)!.menu_animation_tooltip,
        ),
        const SizedBox(height: 10),
        Container(
          width: context.screenWidth * (context.isWide ? 0.4 : .9),
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            spacing: 15,
            children: animationTypes.map((type) {
              bool itemShouldAnimate =
                  selectedAnimation == type && shouldAnimate;
              return RadioListTile<String>(
                activeColor: Colors.purple,
                title: AnimationItem(
                  animationType: type,
                  color: selectedAnimation == type
                      ? Colors.purple
                      : Colors.blueGrey,
                  shouldAnimate: itemShouldAnimate,
                  onAnimationFinished: () {
                    setState(() {
                      shouldAnimate = false;
                    });
                  },
                ),
                value: type,
                groupValue: selectedAnimation,
                onChanged: (value) async {
                  await widget.animationChange(value!);
                  setState(() {
                    selectedAnimation = value;
                    shouldAnimate = true;
                  });
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
