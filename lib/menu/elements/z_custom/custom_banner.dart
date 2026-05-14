import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomBanner extends StatefulWidget {
  final String banner;
  final Function(String) bannerChange;
  const CustomBanner(
      {super.key, required this.banner, required this.bannerChange});

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  late String bannerUrl;
  final menuAPI = MenuService();
  @override
  void initState() {
    super.initState();
    bannerUrl = widget.banner;
  }

  @override
  void didUpdateWidget(covariant CustomBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.banner != widget.banner) {
      setState(() {
        bannerUrl = widget.banner;
      });
    }
  }

  void pickImage() async {
    final url = await customPickImage(context, 16 / 10);
    if (url.isNotEmpty) {
      setState(() {
        bannerUrl = url;
        widget.bannerChange(bannerUrl);
      });
    }
  }

  void deleteBanner() async {
    setState(() {
      bannerUrl = '';
      widget.bannerChange(bannerUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return bannerUrl != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Image.network(
                '$customServerName$bannerUrl',
                width: context.isWide
                    ? context.screenWidth * .3
                    : context.screenWidth * .8,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  CustomMenuButton(
                      onPressed: pickImage,
                      child: AppLocalizations.of(context)!.menu_change),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomMenuButton(
                      onPressed: deleteBanner,
                      child: AppLocalizations.of(context)!.menu_delete)
                ],
              )
            ],
          )
        : Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: pickImage,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.black,
                      size: 50,
                    ))));
  }
}
