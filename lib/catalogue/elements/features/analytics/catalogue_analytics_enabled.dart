import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/features/analytics/analytics_enabled.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_bar_chart.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueAnalyticsEnabled extends StatefulWidget {
  const CatalogueAnalyticsEnabled({super.key});

  @override
  State<CatalogueAnalyticsEnabled> createState() =>
      _CatalogueAnalyticsEnabledState();
}

class _CatalogueAnalyticsEnabledState extends State<CatalogueAnalyticsEnabled> {
  final menuService = MenuService();
  late dynamic response;
  List<AnalyticsDay>? catalogueAnalyticsDays;
  int selectedMonth = DateTime.now().month;
  int selectedYearValue = DateTime.now().year;
  final TextEditingController selectedYear =
      TextEditingController(text: DateTime.now().year.toString());
  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  void loadAnalytics() async {
    response = await menuService.getAnalytics();
    final allDays = (response['data'] as List)
        .map((e) => AnalyticsDay.fromJson(e))
        .toList();
    setState(() {
      catalogueAnalyticsDays = allDays
          .where((a) => a.month == selectedMonth && a.year == selectedYearValue)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 100,
          title: AppLocalizations.of(context)!.menu_analytics_title,
          toolTip: AppLocalizations.of(context)!.menu_analytics_tooltip,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.purple)),
                child: DropdownButton<int>(
                    value: selectedMonth,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    iconEnabledColor: Colors.purple,
                    underline: Container(
                      height: 2,
                      color: Colors.purple,
                    ),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                          value: index + 1,
                          child: Text([
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ][index]));
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMonth = value;
                          loadAnalytics();
                        });
                      }
                    })),
            SizedBox(
              width: 80,
              child: CustomMenuInput(
                controller: selectedYear,
                function: (value) {
                  setState(() {
                    selectedYearValue =
                        int.tryParse(value) ?? selectedYearValue;
                    loadAnalytics();
                  });
                },
                hintText: AppLocalizations.of(context)!.menu_year,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(10),
            width: context.screenWidth * (context.isWide ? 0.4 : 0.8),
            height: 200,
            child: catalogueAnalyticsDays != null
                ? CustomBarChart(analyticsDays: catalogueAnalyticsDays!)
                : const SizedBox.shrink())
      ],
    );
  }
}
