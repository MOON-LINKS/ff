import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/features/feedback/custom_feedback.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class FeedbackEnabled extends ConsumerStatefulWidget {
  const FeedbackEnabled({
    super.key,
  });

  @override
  ConsumerState<FeedbackEnabled> createState() => _FeedbackEnabledState();
}

class _FeedbackEnabledState extends ConsumerState<FeedbackEnabled> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final menuNotifier = ref.read(menuProvider.notifier);
    bool feedback = menuState['payload']['feedback'] == true ? true : false;

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
                    menuNotifier.addOrUpdateInfo('feedback', val);
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
