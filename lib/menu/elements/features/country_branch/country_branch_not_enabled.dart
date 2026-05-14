import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CountryBranchNotEnabled extends StatefulWidget {
  const CountryBranchNotEnabled({super.key});

  @override
  State<CountryBranchNotEnabled> createState() =>
      _CountryBranhNotEnabledState();
}

class _CountryBranhNotEnabledState extends State<CountryBranchNotEnabled> {
  final List<Map<String, dynamic>> countries = [
    {
      'country_name': 'Country 1',
      'branches': [
        {'branch_name': 'Branch 1.1', 'branch_link': 'https://moonlinks.me'},
        {'branch_name': 'Branch 1.2', 'branch_link': 'https://moonlinks.me'},
      ],
    },
    {
      'country_name': 'Country 2',
      'branches': [
        {'branch_name': 'Branch 2.1', 'branch_link': 'https://moonlinks.me'},
      ],
    },
    {
      'country_name': 'Country 3',
      'branches': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 140,
          title: AppLocalizations.of(context)!.menu_country_branches_title,
          toolTip: AppLocalizations.of(context)!.menu_country_branches_tooltip,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CustomMenuCheckbox(value: false, onChanged: (_) {})],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      color: Colors.white,
                      height: 200,
                      width: context.screenWidth * (context.isWide ? .4 : .8),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          Column(children: [
                            ...countries.asMap().entries.map((entry) {
                              final country = entry.value;
                              return Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          border: BorderDirectional(
                                              bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 2))),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.all(
                                                          10),
                                                  child: Row(children: [
                                                    Text(
                                                      country['country_name'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.delete_outlined,
                                                          color: Colors.purple,
                                                        ))
                                                  ]))),
                                        ],
                                      )),
                                  Column(children: [
                                    ...country['branches']
                                        .asMap()
                                        .entries
                                        .map((branch) {
                                      final branchValue = branch.value;
                                      return Container(
                                        decoration: BoxDecoration(
                                            border: BorderDirectional(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context)!.name}: ${branchValue['branch_name']}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.link}: ${branchValue['branch_link']}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.delete_outlined,
                                                  color: Colors.purple,
                                                ))
                                          ],
                                        ),
                                      );
                                    })
                                  ]),
                                ],
                              );
                            })
                          ]),
                        ],
                      )))),
              Positioned.fill(
                child: Stack(
                  children: [
                    Container(color: const Color.fromARGB(120, 155, 39, 176)),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.transparent),
                    ),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_open,
                          color: Colors.purple,
                          size: 80,
                        ),
                        Text(
                          AppLocalizations.of(context)!.menu_go_pro_to_unlock,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
