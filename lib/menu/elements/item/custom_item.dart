import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class CustomItem extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String? mainImageUrl;
  final dynamic badges;
  final int isActive;
  final int displayOrder;
  final dynamic types;
  final dynamic prices;
  final dynamic images;
  final VoidCallback updateItem;
  final VoidCallback deleteItem;
  const CustomItem(
      {super.key,
      required this.title,
      required this.description,
      this.mainImageUrl,
      this.badges,
      required this.isActive,
      required this.displayOrder,
      this.types,
      this.prices,
      required this.images,
      required this.updateItem,
      required this.deleteItem});

  @override
  ConsumerState<CustomItem> createState() => _CustomItemState();
}

class _CustomItemState extends ConsumerState<CustomItem> {
  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider)['payload'];
    Map<String, dynamic>? newBadge;
    Map<String, dynamic>? offerBadge;

    for (var b in widget.badges) {
      final map = Map<String, dynamic>.from(b);
      if (map['type'] == 'isNew') newBadge = map;
      if (map['type'] == 'offer') offerBadge = map;
    }
    final List<String> allImages = [
      if (widget.mainImageUrl != null) widget.mainImageUrl!,
      ...widget.images,
    ];
    Widget imageSection = ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: CarouselSlider(
            items: allImages.map((item) {
              return Builder(
                  builder: (_) => SizedBox.expand(
                        child: Image.network(
                          '$customServerName$item',
                          fit: BoxFit.cover,
                        ),
                      ));
            }).toList(),
            options: CarouselOptions(
                autoPlay: true,
                height: context.isWide ? 200 : 150,
                aspectRatio: 1,
                enableInfiniteScroll: true,
                viewportFraction: 1)));
    return Column(children: [
      MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Expanded(
                    flex: 3,
                    child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(20),
                        child: Stack(
                          children: [
                            widget.images == null || widget.images.length == 0
                                ? Image.network(
                                    widget.mainImageUrl != ''
                                        ? '$customServerName${widget.mainImageUrl}'
                                        : 'https://cdn.moonlinks.me/category/cat-icon-1.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : imageSection,
                            if (newBadge != null && newBadge['value'] == true)
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.red,
                                    child: Text(
                                        AppLocalizations.of(context)!.menu_new),
                                  )),
                            if (offerBadge != null &&
                                offerBadge['value'] == true &&
                                offerBadge['percent'] != null)
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.blueAccent,
                                    child: Text(
                                        '${AppLocalizations.of(context)!.menu_offer_b}: ${offerBadge['percent']}%'),
                                  ))
                          ],
                        ))),
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: EdgeInsetsGeometry.all(10),
                        child: Column(
                          spacing: 5,
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800)),
                            Text(widget.description,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                            Row(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.types.map<Widget>((type) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(type['backColor']),
                                    ),
                                    child: Text(
                                      type['title'],
                                      style: TextStyle(
                                          color: Color(type['textColor'])),
                                    ),
                                  );
                                }).toList()),
                            Row(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.prices.map<Widget>((price) {
                                  return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(menuState['design']
                                            ['primary-color']),
                                      ),
                                      child: Text(
                                        ' ${price['label']} ${menuState['currency']} ${price['amount']}',
                                        style: TextStyle(
                                          color: Color(menuState['design']
                                              ['text-color']),
                                        ),
                                      ));
                                }).toList())
                          ],
                        )))
              ]))),
      Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(spacing: 10, children: [
                CustomMenuTitle(child: (widget.displayOrder + 1).toString()),
                Text(
                    widget.isActive == 1
                        ? AppLocalizations.of(context)!.menu_item_active
                        : AppLocalizations.of(context)!.menu_item_inactive,
                    style: TextStyle(
                        color:
                            widget.isActive == 1 ? Colors.green : Colors.red)),
                widget.isActive == 0
                    ? CustomMenuTooltip(
                        message: AppLocalizations.of(context)!
                            .menu_item_images_overflow_warning)
                    : const SizedBox.shrink()
              ]),
              Row(spacing: 10, children: [
                CustomMenuButton(
                    onPressed: widget.updateItem,
                    child: AppLocalizations.of(context)!.menu_update),
                CustomMenuButton(
                    onPressed: widget.deleteItem,
                    child: AppLocalizations.of(context)!.menu_delete)
              ])
            ],
          )),
      const SizedBox(height: 10)
    ]);
  }
}
