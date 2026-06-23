import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class CatalogueOpencloseEnabled extends ConsumerStatefulWidget {
  const CatalogueOpencloseEnabled({super.key});

  @override
  ConsumerState<CatalogueOpencloseEnabled> createState() =>
      _CatalogueOpencloseEnabledState();
}

class _CatalogueOpencloseEnabledState
    extends ConsumerState<CatalogueOpencloseEnabled> {
  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    final catalogueNotifier = ref.read(catalogueProvider.notifier);
    bool isOpenclose = catalogueState['payload']['openclose']['enabled'] == true
        ? true
        : false;
    List<dynamic> hours = catalogueState['payload']['openclose']['hours'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 150,
          title: AppLocalizations.of(context)!.menu_open_close_hours_title,
          toolTip: AppLocalizations.of(context)!.menu_open_close_hours_tooltip,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomMenuCheckbox(
                value: isOpenclose,
                onChanged: (val) {
                  setState(() {
                    isOpenclose = val;
                  });
                  catalogueNotifier.addOrUpdateInfo(
                      'openclose', {'enabled': val, 'hours': hours});
                })
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Container(
                color: Colors.white,
                width: context.screenWidth * (context.isWide ? 0.4 : .9),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: hours.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final LinkedHashMap<dynamic, dynamic> dayInfo =
                            entry.value as LinkedHashMap<dynamic, dynamic>;

                        return Card(
                            margin: EdgeInsets.all(5),
                            child: Padding(
                              padding:
                                  EdgeInsetsGeometry.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                        dayInfo['day'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ))),
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () async {
                                        final TimeOfDay? picked =
                                            await showTimePicker(
                                          helpText:
                                              '${AppLocalizations.of(context)!.menu_opening_time_for}: ${dayInfo['day']}',
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                timePickerTheme:
                                                    TimePickerThemeData(
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                  hourMinuteColor:
                                                      Colors.purple[200],
                                                  hourMinuteTextColor:
                                                      Colors.black,
                                                  dialHandColor: Colors.black,
                                                  dialBackgroundColor:
                                                      Colors.purple[200],
                                                  dayPeriodColor:
                                                      Colors.purple[200],
                                                  dayPeriodTextColor:
                                                      Colors.black,
                                                  helpTextStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  cancelButtonStyle:
                                                      TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                  ),
                                                  confirmButtonStyle:
                                                      TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.purple,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            hours[index]['from'] =
                                                picked.format(context);
                                          });
                                          catalogueNotifier
                                              .addOrUpdateInfo('openclose', {
                                            'enabled': true,
                                            'hours': hours,
                                          });
                                        }
                                      },
                                      child: Text(
                                        dayInfo['from'] ??
                                            AppLocalizations.of(context)!
                                                .menu_from,
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () async {
                                        final TimeOfDay? picked =
                                            await showTimePicker(
                                          helpText:
                                              '${AppLocalizations.of(context)!.menu_closing_time_for}: ${dayInfo['day']}',
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                timePickerTheme:
                                                    TimePickerThemeData(
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                  hourMinuteColor:
                                                      Colors.purple[200],
                                                  hourMinuteTextColor:
                                                      Colors.black,
                                                  dialHandColor: Colors.black,
                                                  dialBackgroundColor:
                                                      Colors.purple[200],
                                                  dayPeriodColor:
                                                      Colors.purple[200],
                                                  dayPeriodTextColor:
                                                      Colors.black,
                                                  helpTextStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  cancelButtonStyle:
                                                      TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                  ),
                                                  confirmButtonStyle:
                                                      TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.purple,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            hours[index]['to'] =
                                                picked.format(context);
                                          });
                                          catalogueNotifier
                                              .addOrUpdateInfo('openclose', {
                                            'enabled': true,
                                            'hours': hours,
                                          });
                                        }
                                      },
                                      child: Text(
                                        dayInfo['to'] ??
                                            AppLocalizations.of(context)!
                                                .menu_to,
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              dayInfo['from'] = null;
                                              dayInfo['to'] = null;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.hourglass_disabled_rounded,
                                            color: dayInfo['from'] == null &&
                                                    dayInfo['to'] == null
                                                ? Colors.red
                                                : Colors.purple,
                                          )))
                                ],
                              ),
                            ));
                      }).toList(),
                    ),
                    if (!isOpenclose)
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
                ))),
      ],
    );
  }
}
