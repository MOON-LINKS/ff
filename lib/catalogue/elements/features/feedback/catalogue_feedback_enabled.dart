import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/features/feedback/custom_feedback.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueFeedbackEnabled extends ConsumerStatefulWidget {
  const CatalogueFeedbackEnabled({
    super.key,
  });

  @override
  ConsumerState<CatalogueFeedbackEnabled> createState() =>
      _CatalogueFeedbackEnabledState();
}

class _CatalogueFeedbackEnabledState
    extends ConsumerState<CatalogueFeedbackEnabled> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    final catalogueNotifier = ref.read(catalogueProvider.notifier);
    bool feedback =
        catalogueState['payload']['feedback'] == true ? true : false;

    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 120,
          title: AppLocalizations.of(context)!.menu_feedbacks_title,
          toolTip: AppLocalizations.of(context)!.menu_feedbacks_tooltip,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomMenuCheckbox(
                value: feedback,
                onChanged: (val) {
                  setState(() {
                    catalogueNotifier.addOrUpdateInfo('feedback', val);
                  });
                })
          ],
        ),
        CustomFeedback(
          isEnabled: feedback,
          isLocked: false,
        )
      ],
    );
  }
}
