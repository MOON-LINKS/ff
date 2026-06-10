import 'package:flutter/material.dart';
import 'package:moonlinks/catalogue/elements/catalogue_image_picker.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomCatalogueImg extends StatefulWidget {
  final String img;
  final Function(String) imgChange;
  final double aspectRatio;
  const CustomCatalogueImg(
      {super.key,
      required this.img,
      required this.imgChange,
      required this.aspectRatio});

  @override
  State<CustomCatalogueImg> createState() => _CustomCatalogueImgState();
}

class _CustomCatalogueImgState extends State<CustomCatalogueImg> {
  late String imgUrl;
  @override
  void initState() {
    super.initState();
    imgUrl = widget.img;
  }

  @override
  void didUpdateWidget(covariant CustomCatalogueImg oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.img != widget.img) {
      setState(() {
        imgUrl = widget.img;
      });
    }
  }

  void pickImage() async {
    final url = await catalogueCustomPickImage(context, 1);
    if (url.isNotEmpty) {
      setState(() {
        imgUrl = url;
        widget.imgChange(imgUrl);
      });
    }
  }

  void deleteImg() async {
    setState(() {
      imgUrl = '';
      widget.imgChange(imgUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return imgUrl != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(100),
                  child: Image.network(
                    '$customServerName$imgUrl',
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
                      onPressed: deleteImg,
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
