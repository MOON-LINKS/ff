import 'package:flutter/widgets.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/features/feedback/custom_feedback.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class FeedbackNotEnabled extends StatefulWidget {
  const FeedbackNotEnabled({super.key});

  @override
  State<FeedbackNotEnabled> createState() => _FeedbackNotEnabledState();
}

class _FeedbackNotEnabledState extends State<FeedbackNotEnabled> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * (context.isWide ? 0.4 : .8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          CustomTitleSection(
            margin: 120,
            title: AppLocalizations.of(context)!.menu_feedbacks_title,
            toolTip: AppLocalizations.of(context)!.menu_feedbacks_tooltip,
          ),
          CustomFeedback(isEnabled: false, isLocked: true)
        ],
      ),
    );
  }
}
