import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/main.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/features/analytics/analytics_enabled.dart';
import 'package:moonlinks/menu/elements/features/analytics/analytics_not_enabled.dart';
import 'package:moonlinks/menu/elements/features/animation/animation_enabled.dart';
import 'package:moonlinks/menu/elements/features/animation/animation_not_enabled.dart';
import 'package:moonlinks/menu/elements/features/language/language_enabled.dart';
import 'package:moonlinks/menu/elements/features/language/language_not_enabled.dart';
import 'package:moonlinks/menu/elements/menu_font_selector.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_banner.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_color_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_divider.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_google_acc.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_loader.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_logo.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_appbar.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/features/country_branch/country_branch_enabled.dart';
import 'package:moonlinks/menu/elements/features/country_branch/country_branch_not_enabled.dart';
import 'package:moonlinks/menu/elements/features/feedback/feedback_enabled.dart';
import 'package:moonlinks/menu/elements/features/feedback/feedback_not_enabled.dart';
import 'package:moonlinks/menu/elements/features/openclose/openclose_enabled.dart';
import 'package:moonlinks/menu/elements/features/openclose/openclose_not_enabled.dart';
import 'package:moonlinks/menu/elements/features/social_media/social_media_enabled.dart';
import 'package:moonlinks/menu/elements/features/social_media/social_media_not_enabled.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_publishbar.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_offer.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_ordering_system.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';
import 'package:moonlinks/menu/pages/menu_categories.dart';
import 'package:moonlinks/menu/pages/menu_domains.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class MenuMain extends ConsumerStatefulWidget {
  final int subscribedServiceId;
  const MenuMain({super.key, required this.subscribedServiceId});
  @override
  ConsumerState<MenuMain> createState() => _MenuMainState();
}

class _MenuMainState extends ConsumerState<MenuMain> {
  final menuService = MenuService();

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

  Future<void> _initMenuHive() async {
    //await initMenuHive();
    final notifier = ref.read(menuProvider.notifier);
    String? token = await readToken();

    final snapshot =
        await menuService.getMenuSnapshot(token!, widget.subscribedServiceId);

    final snapshotData = snapshot['snapshot'];

    if (snapshotData != null) {
      final rawPayload = snapshotData['payload'];
      if (rawPayload == null) return;
      dynamic decoded =
          rawPayload is String ? jsonDecode(rawPayload) : rawPayload;

      final Map<String, dynamic> payload =
          deepNormalize(decoded) as Map<String, dynamic>;
      ref.read(menuProvider.notifier).updateMenu(payload);
      bioText = payload['bio'] ?? '';
      bioController.text = bioText;
      currencyController.text = payload['currency'] ?? '';
    }

    final addOnsResponse = await menuService.getAddOns();
    final addOns = addOnsResponse['data'];
    notifier.setAddOns({
      'quantity': addOns['quantity'],
      'status': addOns['status'],
      'ends_at': addOns['ends_at'].toString().split('T').first
    });
    ref.read(menuProvider.notifier).updateName(snapshot['name']);

    await notifier.updateMeta('sameAsDatabase', true);
    final features = snapshot['features'];
    final featureMap = {
      for (var f in features) f['feature_key'].toString(): f['feature_value']
    };

    if (features != null) {
      notifier.updateFeatures(featureMap);
    }

    final assets = await menuService.getAssets();
    notifier.updateAssets(assets);
    await notifier.checkItems();

    nameController.text = snapshot['name'] ?? '';
    if (notifier.canUseFeature('analytics')) {
      notifier.addOrUpdateInfo('analytics', 1);
    } else {
      notifier.addOrUpdateInfo('analytics', 0);
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initMenuHive();
  }

  @override
  void dispose() {
    nameController.dispose();
    currencyController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void setName(String name) async {
    try {
      if (formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.menu_checking_inputs)),
        );
        final response = await menuService.setName(name);
        final text = response['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text)),
        );
        if (response['status'] == 200) {
          await ref.read(menuProvider.notifier).updateName(name);
        }
      }
    } catch (e) {
      throw Exception('couldnt set name: $e');
    }
  }

  void goHome() {
    /* final sameAsDatabase =
        ref.read(menuProvider)['meta']['sameAsDatabase'] ?? false; */
    final sameAsDatabase = true;
    sameAsDatabase
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Main(),
            ))
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.purple,
                    width: 2,
                  ),
                ),
                title: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomMenuTitle(
                        child: AppLocalizations.of(context)!
                            .menu_unsaved_changes)),
                content: Text(
                    AppLocalizations.of(context)!.menu_unsaved_changes_message),
                actions: [
                  CustomMenuButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Main()),
                      );
                    },
                    child: AppLocalizations.of(context)!.menu_leave_anyway,
                  ),
                  CustomMenuButton(
                      onPressed: () {
                        //publishChanges();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Main()),
                        );
                      },
                      child: AppLocalizations.of(context)!.menu_publish_exit),
                ],
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final menuNotifier = ref.read(menuProvider.notifier);

    Map<String, dynamic> cloneMap(Map<String, dynamic> map) {
      return jsonDecode(jsonEncode(map)) as Map<String, dynamic>;
    }

    final menuName = menuState['name'] ?? '';
    final link = menuName.isNotEmpty
        ? '$menuName.menu.moonlinks.me'
        : 'menu.moonlinks.me';
    return Scaffold(
        appBar: CustomMenuAppbar(
          haveIcon: false,
        ),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding:
                  EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  CustomTitleSection(
                      title: AppLocalizations.of(context)!.menu_name,
                      toolTip:
                          AppLocalizations.of(context)!.menu_name_unique_hint,
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
                              if (value.contains(RegExp(r'[^A-Za-z0-9-]'))) {
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
                              onPressed: () => setName(nameController.text),
                              child:
                                  AppLocalizations.of(context)!.menu_set_name),
                        ],
                      )),
                  const CustomDivider(),
                  //domain section
                  CustomTitleSection(
                    margin: 80,
                    title: AppLocalizations.of(context)!.menu_domain,
                    toolTip: AppLocalizations.of(context)!.menu_domain_hint,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomMenuButton(
                      child: AppLocalizations.of(context)!.menu_your_domain,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuDomains()))),
                  const CustomDivider(),
                  //logo section
                  CustomTitleSection(
                    margin: 80,
                    title: AppLocalizations.of(context)!.menu_logo,
                    toolTip: AppLocalizations.of(context)!.menu_logo_hint,
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  CustomLogo(
                      logo: menuState['payload']['logo'],
                      logoChange: (newLogo) async {
                        menuNotifier.addOrUpdateInfo('logo', newLogo);
                        //await menuNotifier.imageCounter();
                      }),
                  const CustomDivider(),
                  //bio section
                  CustomTitleSection(
                    margin: 80,
                    title: AppLocalizations.of(context)!.menu_bio,
                    toolTip: AppLocalizations.of(context)!.menu_bio_hint,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomMenuInput(
                    controller: bioController,
                    function: (value) {
                      menuNotifier.addOrUpdateInfo('bio', value);
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
                    toolTip: AppLocalizations.of(context)!.menu_banner_hint,
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  CustomBanner(
                      banner: menuState['payload']['banner'],
                      bannerChange: (newBanner) async {
                        menuNotifier.addOrUpdateInfo('banner', newBanner);
                        //await menuNotifier.imageCounter();
                      }),
                  const CustomDivider(),
                  //inner-banner section
                  CustomTitleSection(
                    margin: 120,
                    title: AppLocalizations.of(context)!.menu_inner_banner,
                    toolTip:
                        AppLocalizations.of(context)!.menu_inner_banner_hint,
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  CustomBanner(
                      banner: menuState['payload']['inner-banner'],
                      bannerChange: (newBanner) async {
                        menuNotifier.addOrUpdateInfo('inner-banner', newBanner);
                        //await menuNotifier.imageCounter();
                      }),
                  const CustomDivider(),
                  //loader
                  CustomTitleSection(
                    margin: 80,
                    title: AppLocalizations.of(context)!.menu_loader,
                    toolTip: AppLocalizations.of(context)!.menu_loader_hint,
                  ),

                  const SizedBox(height: 15),
                  CustomLoader(
                      loader: menuState['payload']['loader'],
                      loaderChange: (newLoader) async {
                        menuNotifier.addOrUpdateInfo('loader', newLoader);
                        //await menuNotifier.imageCounter();
                      }),
                  const CustomDivider(),
                  //offer
                  CustomTitleSection(
                    margin: 80,
                    title: AppLocalizations.of(context)!.menu_offer,
                    toolTip: AppLocalizations.of(context)!.menu_offer_hint,
                  ),

                  const SizedBox(height: 15),
                  CustomOffer(
                      offer: menuState['payload']['offer'],
                      offerChange: (newOffer) async {
                        menuNotifier.addOrUpdateInfo('offer', newOffer);
                        //await menuNotifier.imageCounter();
                      }),
                  const CustomDivider(),
                  //color section
                  CustomTitleSection(
                    margin: 110,
                    title: AppLocalizations.of(context)!.menu_main_colors,
                    toolTip: AppLocalizations.of(context)!.menu_colors_hint,
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
                          text: AppLocalizations.of(context)!.menu_primary,
                          color: menuState['payload']['design']
                              ['primary-color'],
                          newColor: (newColor) {
                            final design =
                                cloneMap(menuState['payload']['design']);
                            design['primary-color'] = newColor;

                            menuNotifier.addOrUpdateInfo('design', design);
                          }),
                      CustomColorPicker(
                          text: AppLocalizations.of(context)!.menu_secondary,
                          color: menuState['payload']['design']
                              ['secondary-color'],
                          newColor: (newColor) {
                            final design =
                                cloneMap(menuState['payload']['design']);
                            design['secondary-color'] = newColor;

                            menuNotifier.addOrUpdateInfo('design', design);
                          }),
                      CustomColorPicker(
                          text: AppLocalizations.of(context)!.menu_title_color,
                          color: menuState['payload']['design']['title-color'],
                          newColor: (newColor) {
                            final design =
                                cloneMap(menuState['payload']['design']);
                            design['title-color'] = newColor;

                            menuNotifier.addOrUpdateInfo('design', design);
                          }),
                      CustomColorPicker(
                          text: AppLocalizations.of(context)!.menu_text,
                          color: menuState['payload']['design']['text-color'],
                          newColor: (newColor) {
                            final design =
                                cloneMap(menuState['payload']['design']);
                            design['text-color'] = newColor;

                            menuNotifier.addOrUpdateInfo('design', design);
                          }),
                    ],
                  ),
                  const CustomDivider(),
                  //currency
                  CustomMenuTitle(
                      child: AppLocalizations.of(context)!.menu_currency),
                  const SizedBox(height: 15),

                  CustomMenuInput(
                    controller: currencyController,
                    function: (value) {
                      menuNotifier.addOrUpdateInfo('currency', value);
                    },
                    hintText: AppLocalizations.of(context)!.menu_currency_input,
                    tooltipMessage:
                        AppLocalizations.of(context)!.menu_currency_hint,
                  ),
                  const CustomDivider(),
                  //font selector widget
                  MenuFontSelector(
                    function: (value) async {
                      await menuNotifier.addOrUpdateInfo('font', value);
                      ref.read(menuProvider)['payload']['font'];
                    },
                  ),
                  const CustomDivider(),
                  //category button
                  CustomMenuButton(
                      fontSize: 25,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuCategories(),
                          )),
                      child: AppLocalizations.of(context)!.menu_categories),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.menu_categories_hint,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const CustomDivider(),
                  //ordering system
                  CustomTitleSection(
                    margin: 110,
                    title: AppLocalizations.of(context)!.menu_ordering,
                    toolTip: AppLocalizations.of(context)!.menu_ordering_hint,
                  ),
                  const SizedBox(height: 15),
                  CustomOrderingSystem(
                    countryCode: menuState['payload']['order']['countryCode'],
                    countryISO: menuState['payload']['order']['countryISOCode'],
                    phoneNumber: menuState['payload']['order']['number'],
                    onNumChange: (phoneData) {
                      menuNotifier.addOrUpdateInfo('order', {
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
                    title: AppLocalizations.of(context)!.menu_google_account,
                    toolTip:
                        AppLocalizations.of(context)!.menu_google_account_hint,
                  ),
                  const SizedBox(height: 15),
                  CustomGoogleAcc(
                    mainAcc: menuState['payload']['google'],
                    onChange: (value) {
                      menuNotifier.addOrUpdateInfo('google', value);
                    },
                  ),
                  const CustomDivider(),
                  //featuresCheck
                  //language
                  menuNotifier.getFeatureLimit('language') != 0
                      ? LanguageEnabled()
                      : LanguageNotEnabled(),
                  const CustomDivider(),
                  //feedback
                  menuNotifier.canUseFeature('feedback_enabled')
                      ? FeedbackEnabled()
                      : FeedbackNotEnabled(),
                  const CustomDivider(),
                  //openclose
                  menuNotifier.canUseFeature('openclose_enabled')
                      ? OpencloseEnabled()
                      : OpencloseNotEnabled(),
                  const CustomDivider(),
                  //country branches
                  menuNotifier.canUseFeature('country_branch_enabled')
                      ? CountryBranchEnabled()
                      : CountryBranchNotEnabled(),
                  const CustomDivider(),
                  //social media icons
                  menuNotifier.getFeatureLimit('social_media') != 0
                      ? SocialMediaEnabled()
                      : SocialMediaNotEnabled(),
                  const CustomDivider(),
                  //Animation
                  menuNotifier.canUseFeature('animation')
                      ? AnimationEnabled(
                          animationChange: (value) async {
                            await menuNotifier.addOrUpdateInfo(
                                'animation', value);
                          },
                        )
                      : AnimationNotEnabled(),
                  const CustomDivider(),
                  //Analytics
                  menuNotifier.canUseFeature('analytics')
                      ? AnalyticsEnabled()
                      : AnalyticsNotEnabled(),
                  const CustomDivider(),
                  //Home
                  CustomMenuButton(
                    onPressed: goHome,
                    child: AppLocalizations.of(context)!.menu_go_home,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )),
          )),
          CustomMenuPublishbar(
              show: !menuState['meta']['isPublished'],
              link: link,
              onPublish: () async {
                final result = await menuService.publish(
                    widget.subscribedServiceId, menuState['payload']);
                if (result['message'] == 'menu successfully published') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Center(
                          child: Text(AppLocalizations.of(context)!
                              .menu_publish_success))));
                }
              })
        ]));
  }
}
