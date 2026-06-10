import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/api/catalogue_api.dart';
import 'package:moonlinks/catalogue/elements/custom_catalogue_publishbar.dart';
import 'package:moonlinks/catalogue/elements/custom_catalogue_logo.dart';
import 'package:moonlinks/catalogue/pages/catalogue_categories.dart';
import 'package:moonlinks/catalogue/pages/catalogue_domains.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_color_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_divider.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_google_acc.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_appbar.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_ordering_system.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueMain extends ConsumerStatefulWidget {
  final int subscribedServiceId;
  const CatalogueMain({super.key, required this.subscribedServiceId});

  @override
  ConsumerState<CatalogueMain> createState() => _CatalogueMainState();
}

class _CatalogueMainState extends ConsumerState<CatalogueMain> {
  final catalogueService = CatalogueApi();

  @override
  void initState() {
    super.initState();
    //_initCatalogue();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    final catalogueNotifier = ref.read(catalogueProvider.notifier);
    Map<String, dynamic> cloneMap(Map<String, dynamic> map) {
      return jsonDecode(jsonEncode(map)) as Map<String, dynamic>;
    }

    return Scaffold(
        appBar: CustomMenuAppbar(
          haveIcon: false,
        ),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Center(
                      child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(children: [
                            const SizedBox(height: 50),
                            const CustomDivider(),
                            //domain section
                            CustomTitleSection(
                              margin: 80,
                              title: AppLocalizations.of(context)!.menu_domain,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_domain_hint,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomMenuButton(
                                child: AppLocalizations.of(context)!
                                    .menu_your_domain,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CatalogueDomains()))),
                            const CustomDivider(),
                            //logo section
                            CustomTitleSection(
                              margin: 80,
                              title: AppLocalizations.of(context)!.menu_logo,
                              toolTip:
                                  AppLocalizations.of(context)!.menu_logo_hint,
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            CustomCatalogueImg(
                              img: catalogueState['payload']['logo'],
                              imgChange: (newLogo) async {
                                catalogueNotifier.addOrUpdateInfo(
                                    'logo', newLogo);
                              },
                              aspectRatio: 1,
                            ),
                            const CustomDivider(),
                            //bio section
                            CustomTitleSection(
                              margin: 80,
                              title: AppLocalizations.of(context)!.menu_bio,
                              toolTip:
                                  AppLocalizations.of(context)!.menu_bio_hint,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            /*  CustomMenuInput(
                              controller: bioController,
                              function: (value) {
                                catalogueNotifier.addOrUpdateInfo('bio', value);
                              },
                              hintText: AppLocalizations.of(context)!.menu_bio,
                            ), */
                            const SizedBox(
                              height: 15,
                            ),
                            const CustomDivider(),
                            //banner section
                            CustomTitleSection(
                              margin: 90,
                              title: AppLocalizations.of(context)!.menu_banner,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_banner_hint,
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            CustomCatalogueImg(
                              img: catalogueState['payload']['banner'],
                              imgChange: (newBanner) async {
                                catalogueNotifier.addOrUpdateInfo(
                                    'banner', newBanner);
                              },
                              aspectRatio: 16 / 10,
                            ),
                            const CustomDivider(),
                            //inner-banner section
                            CustomTitleSection(
                              margin: 120,
                              title: AppLocalizations.of(context)!
                                  .menu_inner_banner,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_inner_banner_hint,
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            CustomCatalogueImg(
                              img: catalogueState['payload']['inner-banner'],
                              imgChange: (newBanner) async {
                                catalogueNotifier.addOrUpdateInfo(
                                    'inner-banner', newBanner);
                              },
                              aspectRatio: 16 / 10,
                            ),
                            const CustomDivider(),
                            //loader
                            CustomTitleSection(
                              margin: 80,
                              title: AppLocalizations.of(context)!.menu_loader,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_loader_hint,
                            ),

                            const SizedBox(height: 15),
                            CustomCatalogueImg(
                              img: catalogueState['payload']['loader'],
                              imgChange: (newLoader) async {
                                catalogueNotifier.addOrUpdateInfo(
                                    'loader', newLoader);
                              },
                              aspectRatio: 1,
                            ),
                            const CustomDivider(),
                            //offer
                            CustomTitleSection(
                              margin: 80,
                              title: AppLocalizations.of(context)!.menu_offer,
                              toolTip:
                                  AppLocalizations.of(context)!.menu_offer_hint,
                            ),

                            const SizedBox(height: 15),
                            CustomCatalogueImg(
                                img: catalogueState['payload']['offer'],
                                imgChange: (newOffer) async {
                                  catalogueNotifier.addOrUpdateInfo(
                                      'offer', newOffer);
                                },
                                aspectRatio: 0.8),
                            const CustomDivider(),
                            //color section
                            CustomTitleSection(
                              margin: 110,
                              title: AppLocalizations.of(context)!
                                  .menu_main_colors,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_colors_hint,
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: [
                                CustomColorPicker(
                                    text: AppLocalizations.of(context)!
                                        .menu_primary,
                                    color: catalogueState['payload']['design']
                                        ['primary-color'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          catalogueState['payload']['design']);
                                      design['primary-color'] = newColor;

                                      catalogueNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                                CustomColorPicker(
                                    text: AppLocalizations.of(context)!
                                        .menu_secondary,
                                    color: catalogueState['payload']['design']
                                        ['secondary-color'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          catalogueState['payload']['design']);
                                      design['secondary-color'] = newColor;

                                      catalogueNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                                CustomColorPicker(
                                    text: AppLocalizations.of(context)!
                                        .menu_title_color,
                                    color: catalogueState['payload']['design']
                                        ['title-color'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          catalogueState['payload']['design']);
                                      design['title-color'] = newColor;

                                      catalogueNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                                CustomColorPicker(
                                    text:
                                        AppLocalizations.of(context)!.menu_text,
                                    color: catalogueState['payload']['design']
                                        ['text-color'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          catalogueState['payload']['design']);
                                      design['text-color'] = newColor;

                                      catalogueNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                              ],
                            ),
                            const CustomDivider(),
                            //currency
                            CustomTitleSection(
                              margin: 110,
                              title:
                                  AppLocalizations.of(context)!.menu_currency,
                              toolTip:
                                  AppLocalizations.of(context)!.menu_currency,
                            ),

                            const SizedBox(height: 15),

                            /*    CustomMenuInput(
                    controller: currencyController,
                    function: (value) {
                      catalogueNotifier.addOrUpdateInfo('currency', value);
                    },
                    hintText: AppLocalizations.of(context)!.menu_currency_input,
                    tooltipMessage:
                        AppLocalizations.of(context)!.menu_currency_hint,
                  ), */
                            const CustomDivider(),
                            //category button
                            CustomMenuButton(
                                fontSize: 25,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CatalogueCategories(),
                                    )),
                                child: AppLocalizations.of(context)!
                                    .menu_categories),
                            const SizedBox(height: 15),
                            Text(
                              AppLocalizations.of(context)!
                                  .menu_categories_hint,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            const CustomDivider(),
                            //font selector widget
                            //font selector widget
                            /*    MenuFontSelector(
                    function: (value) async {
                      await catalogueNotifier.addOrUpdateInfo('font', value);
                      ref.read(menuProvider)['payload']['font'];
                    },
                  ), */
                            const CustomDivider(),
                            //ordering system
                            CustomTitleSection(
                              margin: 110,
                              title:
                                  AppLocalizations.of(context)!.menu_ordering,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_ordering_hint,
                            ),
                            const SizedBox(height: 15),
                            CustomOrderingSystem(
                              countryCode: catalogueState['payload']['order']
                                  ['countryCode'],
                              countryISO: catalogueState['payload']['order']
                                  ['countryISOCode'],
                              phoneNumber: catalogueState['payload']['order']
                                  ['number'],
                              onNumChange: (phoneData) {
                                catalogueNotifier.addOrUpdateInfo('order', {
                                  'countryCode': phoneData.countryCode,
                                  'countryISOCode': phoneData.countryISO,
                                  'number': phoneData.number,
                                  'platforms': []
                                });
                              },
                            ),
                            const CustomDivider(),
                            //Google account
                            CustomTitleSection(
                              margin: 130,
                              title: AppLocalizations.of(context)!
                                  .menu_google_account,
                              toolTip: AppLocalizations.of(context)!
                                  .menu_google_account_hint,
                            ),
                            const SizedBox(height: 15),
                            CustomGoogleAcc(
                              mainAcc: catalogueState['payload']['google'],
                              onChange: (value) {
                                catalogueNotifier.addOrUpdateInfo(
                                    'google', value);
                              },
                            ),
                            const CustomDivider(),
                            //featuresCheck
                            //language
                            /*  catalogueNotifier.getFeatureLimit('language') != 0
                                ? CatalogueLanguageEnabled()
                                : CatalogueLanguageNotEnabled(),
                            const CustomDivider(),
                            //feedback
                            catalogueNotifier.canUseFeature('feedback_enabled')
                                ? CatalogueFeedbackEnabled()
                                : CatalogueFeedbackNotEnabled(),
                            const CustomDivider(),
                            //openclose
                            catalogueNotifier.canUseFeature('openclose_enabled')
                                ? CatalogueOpencloseEnabled()
                                : CatalogueOpencloseNotEnabled(),
                            const CustomDivider(),
                            //country branches
                            catalogueNotifier
                                    .canUseFeature('country_branch_enabled')
                                ? CatalogueCountryBranchEnabled()
                                : CatalogueCountryBranchNotEnabled(),
                            const CustomDivider(),
                            //social media icons
                            catalogueNotifier.getFeatureLimit('social_media') !=
                                    0
                                ? CatalogueSocialMediaEnabled()
                                : CatalogueSocialMediaNotEnabled(),
                            const CustomDivider(),
                            //Animation
                            catalogueNotifier.canUseFeature('animation')
                                ? CatalogueAnimationEnabled(
                                    animationChange: (value) async {
                                      await catalogueNotifier.addOrUpdateInfo(
                                          'animation', value);
                                    },
                                  )
                                : CatalogueAnimationNotEnabled(),
                            const CustomDivider(),
                            //Analytics
                            catalogueNotifier.canUseFeature('analytics')
                                ? CatalogueAnalyticsEnabled()
                                : CatalogueAnalyticsNotEnabled(),
                            const CustomDivider(), */
                          ]))))),
          CustomCataloguePublishbar(
              link: catalogueState['name'].toString().isNotEmpty
                  ? '${catalogueState['name']}.catalogue.moonlinks.me'
                  : 'catalogue.moonlinks.me',
              onPublish: () async {
                final result = await catalogueService.publish(
                    widget.subscribedServiceId, catalogueState['payload']);
                if (result['message'] == 'catalogue successfully published') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Center(
                          child: Text(AppLocalizations.of(context)!
                              .menu_publish_success))));
                }
              })
        ]));
  }
}
