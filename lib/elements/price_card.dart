import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

enum ServiceStatus {
  available,
  added,
  subscribed,
}

class PriceCard extends StatefulWidget {
  final String planType;
  final String price;
  final bool isAvailable;
  final String duration;
  final VoidCallback addToCart;
  const PriceCard(
      {super.key,
      required this.planType,
      required this.price,
      required this.duration,
      required this.addToCart,
      required this.isAvailable});

  @override
  State<PriceCard> createState() => _PriceCard();
}

class _PriceCard extends State<PriceCard> {
  final List<String> standard = [
    'feature_30_images',
    'feature_order_method',
    'feature_color_patterns',
    'feature_logo',
    'feature_banner',
    'feature_offer',
    'feature_unlimited_categories_items',
    'feature_fonts',
    'feature_qr_code_generated',
    'feature_moon_links_hosting',
  ];

  final List<String> pro = [
    'feature_150_images',
    'feature_color_patterns',
    'feature_order_method',
    'feature_logo',
    'feature_banner',
    'feature_offer',
    'feature_unlimited_categories_items',
    'feature_fonts',
    'feature_qr_code_generated',
    'feature_moon_links_hosting',
    'feature_open_close_timers',
    'feature_feedback',
    'feature_3_social_media_links',
  ];

  final List<String> premium = [
    'feature_300_images',
    'feature_color_patterns',
    'feature_order_method',
    'feature_logo',
    'feature_banner',
    'feature_offer',
    'feature_unlimited_categories_items',
    'feature_fonts',
    'feature_qr_code_generated',
    'feature_moon_links_hosting',
    'feature_open_close_timers',
    'feature_feedback',
    'feature_category_images_upload',
    'feature_unlimited_social_media_links',
    'feature_country_branch_locations',
    'feature_real_time_animations',
    'feature_analytics',
    'feature_translate_up_to_6_languages',
    'feature_unlimited_images_add_ons',
    'feature_enhanced_seo_digital_marketing',
    'feature_24_7_priority_support',
  ];
  String _translate(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      case 'feature_30_images':
        return l10n.feature_30_images;
      case 'feature_order_method':
        return l10n.feature_order_method;
      case 'feature_color_patterns':
        return l10n.feature_color_patterns;
      case 'feature_logo':
        return l10n.feature_logo;
      case 'feature_banner':
        return l10n.feature_banner;
      case 'feature_offer':
        return l10n.feature_offer;
      case 'feature_unlimited_categories_items':
        return l10n.feature_unlimited_categories_items;
      case 'feature_fonts':
        return l10n.feature_fonts;
      case 'feature_qr_code_generated':
        return l10n.feature_qr_code_generated;
      case 'feature_moon_links_hosting':
        return l10n.feature_moon_links_hosting;
      case 'feature_open_close_timers':
        return l10n.feature_open_close_timers;
      case 'feature_feedback':
        return l10n.feature_feedback;
      case 'feature_3_social_media_links':
        return l10n.feature_3_social_media_links;
      case 'feature_300_images':
        return l10n.feature_300_images;
      case 'feature_category_images_upload':
        return l10n.feature_category_images_upload;
      case 'feature_unlimited_social_media_links':
        return l10n.feature_unlimited_social_media_links;
      case 'feature_country_branch_locations':
        return l10n.feature_country_branch_locations;
      case 'feature_real_time_animations':
        return l10n.feature_real_time_animations;
      case 'feature_analytics':
        return l10n.feature_analytics;
      case 'feature_translate_up_to_6_languages':
        return l10n.feature_translate_up_to_6_languages;
      case 'feature_unlimited_images_add_ons':
        return l10n.feature_unlimited_images_add_ons;
      case 'feature_enhanced_seo_digital_marketing':
        return l10n.feature_enhanced_seo_digital_marketing;
      case 'feature_24_7_priority_support':
        return l10n.feature_24_7_priority_support;
      default:
        return key;
    }
  }

  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.isWide
            ? context.screenWidth * .3
            : context.screenWidth * .8,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(50)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
              widget.planType,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    '\$ ${widget.price} / ${widget.duration}'),
                widget.duration != 'month'
                    ? Text(
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        '(\$ ${widget.duration == '6months' ? double.parse(widget.price) / 6 : double.parse(widget.price) / 12} / month)')
                    : const SizedBox.shrink(),
                widget.isAvailable
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius:
                                    BorderRadiusGeometry.circular(30))),
                        onPressed: widget.addToCart,
                        child: Text(
                          AppLocalizations.of(context)!.add_to_cart,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ))
                    : const SizedBox.shrink(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      isOpen
                          ? const SizedBox.shrink()
                          : Text(AppLocalizations.of(context)!
                              .view_plan_description),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isOpen = !isOpen;
                            });
                          },
                          icon: Icon(
                            isOpen
                                ? Icons.arrow_upward_outlined
                                : Icons.arrow_downward_outlined,
                            color: Colors.white,
                            size: 30,
                          )),
                    ]),
                isOpen
                    ? ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: (widget.planType == 'STANDARD'
                                ? standard
                                : widget.planType == 'PRO'
                                    ? pro
                                    : premium)
                            .map((key) => Text(
                                  _translate(context, key),
                                  textAlign: TextAlign.center,
                                ))
                            .toList(),
                      )
                    : SizedBox.shrink()
              ],
            )
          ],
        ));
  }
}
