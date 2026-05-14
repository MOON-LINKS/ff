import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomLogo extends StatefulWidget {
  final String logo;
  final Function(String) logoChange;
  const CustomLogo({super.key, required this.logo, required this.logoChange});

  @override
  State<CustomLogo> createState() => _CustomLogoState();
}

class _CustomLogoState extends State<CustomLogo> {
  late String logoUrl;
  final menuAPI = MenuService();
  @override
  void initState() {
    super.initState();
    logoUrl = widget.logo;
  }

  @override
  void didUpdateWidget(covariant CustomLogo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.logo != widget.logo) {
      setState(() {
        logoUrl = widget.logo;
      });
    }
  }

  void pickImage() async {
    final url = await customPickImage(context, 1);
    if (url.isNotEmpty) {
      setState(() {
        logoUrl = url;
        widget.logoChange(logoUrl);
      });
    }
  }

  void deleteLogo() async {
    setState(() {
      logoUrl = '';
      widget.logoChange(logoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return logoUrl != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(100),
                  child: Image.network(
                    '$customServerName$logoUrl',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  CustomMenuButton(
                      onPressed: pickImage,
                      child: AppLocalizations.of(context)!.menu_change),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomMenuButton(
                      onPressed: deleteLogo,
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
