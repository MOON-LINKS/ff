import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomLoader extends StatefulWidget {
  final String loader;
  final Function(String) loaderChange;

  const CustomLoader(
      {super.key, required this.loaderChange, required this.loader});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  late String loaderUrl;
  final menuAPI = MenuService();
  @override
  void initState() {
    super.initState();
    loaderUrl = widget.loader;
  }

  @override
  void didUpdateWidget(covariant CustomLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.loader != widget.loader) {
      setState(() {
        loaderUrl = widget.loader;
      });
    }
  }

  void pickImage() async {
    final url = await customPickImage(context, 1);
    if (url.isNotEmpty) {
      setState(() {
        loaderUrl = url;
        widget.loaderChange(loaderUrl);
      });
    }
  }

  void deleteloader() async {
    setState(() {
      loaderUrl = '';
      widget.loaderChange(loaderUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaderUrl != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(100),
                  child: Image.network(
                    '$customServerName$loaderUrl',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomMenuButton(
                      onPressed: pickImage,
                      child: AppLocalizations.of(context)!.menu_change),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomMenuButton(
                      onPressed: deleteloader,
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
