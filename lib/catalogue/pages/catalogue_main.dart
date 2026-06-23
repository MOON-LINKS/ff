import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/api/catalogue_api.dart';
import 'package:moonlinks/catalogue/elements/custom_catalogue_publishbar.dart';
import 'package:moonlinks/catalogue/elements/custom_catalogue_img.dart';
import 'package:moonlinks/catalogue/elements/features/analytics/catalogue_analytics_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/analytics/catalogue_analytics_not_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/animation/catalogue_animation_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/animation/catalogue_animation_not_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/countrybranch/catalogue_countrybranch_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/countrybranch/catalogue_countrybranch_not_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/feedback/catalogue_feedback_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/feedback/catalogue_feedback_not_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/language/catalogue_language_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/language/catalogue_language_not_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/openclose/catalogue_openclose_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/openclose/catalogue_openclose_not_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/socialmedia/catalogue_socialmedia_enabled.dart';
import 'package:moonlinks/catalogue/elements/features/socialmedia/catalogue_socialmedia_not_enabled.dart';
import 'package:moonlinks/catalogue/pages/catalogue_categories.dart';
import 'package:moonlinks/catalogue/pages/catalogue_domains.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/menu_font_selector.dart';
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
  dynamic deepNormalize(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (e) => MapEntry(
            e.key.toString(),
            deepNormalize(e.value),
          ),
        ),
      );
    }

    if (value is List) {
      return value.map(deepNormalize).toList();
    }

    return value;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  String bioText = '';
  Future<void> _initCatalogue() async {
    final notifier = ref.read(catalogueProvider.notifier);

    final snapshot =
        await catalogueService.getCatalogueSnapshot(widget.subscribedServiceId);

    final snapshotData = snapshot['snapshot'];
    print(snapshotData);
    if (snapshotData != null) {
      final rawPayload = snapshotData['payload'];
      if (rawPayload == null) return;
      dynamic decoded =
          rawPayload is String ? jsonDecode(rawPayload) : rawPayload;

      final Map<String, dynamic> payload =
          deepNormalize(decoded) as Map<String, dynamic>;
      ref.read(catalogueProvider.notifier).updateCatalogue(payload);
      bioText = payload['bio'] ?? '';
      bioController.text = bioText;
      currencyController.text = payload['currency'] ?? '';
    }

    final addOnsResponse = await catalogueService.getAddOns();
    final addOns = addOnsResponse['data'];
    notifier.updateAddOns({
      'quantity': addOns['quantity'],
      'status': addOns['status'],
      'ends_at': addOns['ends_at'] != null
          ? addOns['ends_at'].toString().split('T').first
          : ''
    });
    ref.read(catalogueProvider.notifier).updateName(snapshot['name'] ?? '');

    await notifier.updateMeta('sameAsDatabase', true);
    final features = snapshot['features'];
    final featureMap = {
      for (var f in features) f['feature_key'].toString(): f['feature_value']
    };

    if (features != null) {
      notifier.updateFeatures(featureMap);
    }

    final assets = await catalogueService.getAssets();
    notifier.updateAssets(assets);
    await notifier.checkItems();

    nameController.text = snapshot['name'] ?? '';
    if (notifier.canUseFeature('analytics')) {
      notifier.addOrUpdateInfo('analytics', 1);
    } else {
      notifier.addOrUpdateInfo('analytics', 0);
    }
  }

  void setName(String name) async {
    try {
      if (formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.menu_checking_inputs)),
        );
        final response = await catalogueService.setName(name);
        final text = response['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text)),
        );
        if (response['status'] == 200) {
          await ref.read(catalogueProvider.notifier).updateName(name);
        }
      }
    } catch (e) {
      throw Exception('couldnt set name: $e');
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _initCatalogue();
  }

  @override
  void dispose() {
    nameController.dispose();
    currencyController.dispose();
    bioController.dispose();
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
                            CustomTitleSection(
                                title: AppLocalizations.of(context)!.menu_name,
                                toolTip: AppLocalizations.of(context)!
                                    .menu_name_unique_hint,
                                margin: 80),
                            const SizedBox(
                              height: 15,
                            ),
                            Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    CustomMenuInput(
                                      function: (val) {},
                                      hintText: AppLocalizations.of(context)!
                                          .menu_resto_name_hint,
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .field_required;
                                        }
                                        if (value.contains(
                                            RegExp(r'[^A-Za-z0-9-]'))) {
                                          return AppLocalizations.of(context)!
                                              .menu_name_validation;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomMenuButton(
                                        onPressed: () =>
                                            setName(nameController.text),
                                        child: AppLocalizations.of(context)!
                                            .menu_set_name),
                                  ],
                                )),

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
                            CustomMenuInput(
                              controller: bioController,
                              function: (value) {
                                catalogueNotifier.addOrUpdateInfo('bio', value);
                              },
                              hintText: AppLocalizations.of(context)!.menu_bio,
                            ),
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

                            CustomMenuInput(
                              controller: currencyController,
                              function: (value) {
                                catalogueNotifier.addOrUpdateInfo(
                                    'currency', value);
                              },
                              hintText: AppLocalizations.of(context)!
                                  .menu_currency_input,
                              tooltipMessage: AppLocalizations.of(context)!
                                  .menu_currency_hint,
                            ),
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
                            MenuFontSelector(
                              function: (value) async {
                                await catalogueNotifier.addOrUpdateInfo(
                                    'font', value);
                                ref.read(catalogueProvider)['payload']['font'];
                              },
                            ),
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
                            catalogueNotifier.getFeatureLimit('language') != 0
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
                            const CustomDivider(),
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
