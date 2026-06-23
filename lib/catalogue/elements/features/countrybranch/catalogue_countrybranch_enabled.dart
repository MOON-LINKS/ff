import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/elements/features/countrybranch/catalogue_branch_editor.dart';
import 'package:moonlinks/catalogue/elements/features/countrybranch/catalogue_country_editor.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueCountryBranchEnabled extends ConsumerStatefulWidget {
  const CatalogueCountryBranchEnabled({super.key});

  @override
  ConsumerState<CatalogueCountryBranchEnabled> createState() =>
      _CatalogueCountryBranchEnabledState();
}

class _CatalogueCountryBranchEnabledState
    extends ConsumerState<CatalogueCountryBranchEnabled> {
  bool countryEditorOpen = false;
  void saveCountry(String newCountry) {
    final countryBranch =
        ref.read(catalogueProvider)['payload']['country-branch'];
    final List<dynamic> existingCountries = countryBranch['countries'];
    existingCountries.add({'country_name': newCountry, 'branches': []});
    ref.read(catalogueProvider.notifier).addOrUpdateInfo(
        'country-branch', {...countryBranch, 'countries': existingCountries});
    setState(() {
      countryEditorOpen = false;
    });
  }

  void deleteCountry(int countryId) {
    final countryBranch =
        ref.read(catalogueProvider)['payload']['country-branch'];
    final List<dynamic> existingCountries = countryBranch['countries'];
    existingCountries.removeAt(countryId);
    ref.read(catalogueProvider.notifier).addOrUpdateInfo(
        'country-branch', {...countryBranch, 'countries': existingCountries});
  }

  int countryId = 0;
  bool branchEditorOpen = false;
  void saveBranch(
      int countryId, String branchName, String branchLink, dynamic phoneInfo) {
    final countryBranch =
        ref.read(catalogueProvider)['payload']['country-branch'];
    final List<dynamic> existingCountries = countryBranch['countries'];
    final List<dynamic> existingBranches =
        existingCountries[countryId]['branches'];
    final newBranch = {
      'branch_name': branchName,
      'branch_link': branchLink,
      'branch_phone': phoneInfo
    };
    existingBranches.add(newBranch);
    ref.read(catalogueProvider.notifier).addOrUpdateInfo(
        'country-branch', {...countryBranch, 'countries': existingCountries});
    setState(() {
      branchEditorOpen = false;
    });
  }

  void deleteBranch(int index, int branchIndex) {
    final countryBranch =
        ref.read(catalogueProvider)['payload']['country-branch'];
    final List<dynamic> existingCountries = countryBranch['countries'];
    final List<dynamic> existingBranches = existingCountries[index]['branches'];
    existingBranches.removeAt(branchIndex);
    ref.read(catalogueProvider.notifier).addOrUpdateInfo(
        'country-branch', {...countryBranch, 'countries': existingCountries});
  }

  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    final catalogueNotifier = ref.read(catalogueProvider.notifier);
    bool enabled = catalogueState['payload']['country-branch']['enabled'];
    List<dynamic> countries =
        catalogueState['payload']['country-branch']['countries'] ?? [];
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
          children: [
            CustomMenuCheckbox(
                value: enabled,
                onChanged: (val) {
                  setState(() {
                    enabled = val;
                  });
                  catalogueNotifier.addOrUpdateInfo('country-branch',
                      {'enabled': enabled, 'countries': countries});
                })
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Stack(children: [
              Column(children: [
                CustomMenuButton(
                    onPressed: () {
                      setState(() {
                        countryEditorOpen = true;
                      });
                    },
                    child: countryEditorOpen
                        ? AppLocalizations.of(context)!.menu_adding_new_country
                        : AppLocalizations.of(context)!.menu_add_new_country),
                const SizedBox(height: 10),
                CatalogueCountryEditor(
                    isOpen: countryEditorOpen,
                    closeWidget: () {
                      setState(() {
                        countryEditorOpen = false;
                      });
                    },
                    save: saveCountry),
                const SizedBox(height: 10),
                CatalogueBranchEditor(
                    countryId: countryId,
                    closeWidget: () {
                      setState(() {
                        branchEditorOpen = false;
                      });
                    },
                    isOpen: branchEditorOpen,
                    save: saveBranch),
                const SizedBox(height: 10),
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
                                final index = entry.key;
                                LinkedHashMap<dynamic, dynamic> country =
                                    entry.value;
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
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      IconButton(
                                                          onPressed: () =>
                                                              deleteCountry(
                                                                  index),
                                                          icon: Icon(
                                                            Icons
                                                                .delete_outlined,
                                                            color:
                                                                Colors.purple,
                                                          ))
                                                    ]))),
                                            CustomMenuButton(
                                                onPressed: () {
                                                  setState(() {
                                                    branchEditorOpen = true;
                                                    countryId = index;
                                                  });
                                                },
                                                child: branchEditorOpen
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .menu_adding_branch
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .menu_add_branch)
                                          ],
                                        )),
                                    Column(children: [
                                      ...country['branches']
                                          .asMap()
                                          .entries
                                          .map((branch) {
                                        final branchIndex = branch.key;
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
                                                  Text(
                                                    '${branchValue['branch_phone']['countryCode']} / ${branchValue['branch_phone']['number']}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              )),
                                              IconButton(
                                                  onPressed: () => deleteBranch(
                                                      index, branchIndex),
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
              ]),
              if (!enabled)
                Positioned.fill(
                    child: Stack(children: [
                  Container(color: const Color.fromARGB(120, 155, 39, 176)),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ]))
            ]))
      ],
    );
  }
}
