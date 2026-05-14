import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_bar_chart.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class AnalyticsEnabled extends StatefulWidget {
  const AnalyticsEnabled({super.key});

  @override
  State<AnalyticsEnabled> createState() => _AnalyticsEnabledState();
}

class _AnalyticsEnabledState extends State<AnalyticsEnabled> {
  final menuService = MenuService();
  late dynamic response;
  List<AnalyticsDay>? analyticsDays;
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
      analyticsDays = allDays
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
            child: analyticsDays != null
                ? CustomBarChart(analyticsDays: analyticsDays!)
                : const SizedBox.shrink())
      ],
    );
  }
}

class AnalyticsDay {
  final int year;
  final int month;
  final int day;
  final int clicks;

  AnalyticsDay(
      {required this.year,
      required this.month,
      required this.day,
      required this.clicks});

  factory AnalyticsDay.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['event_date']).toLocal();

    return AnalyticsDay(
      year: date.year,
      month: date.month,
      day: date.day,
      clicks: json['clicks'],
    );
  }
}
