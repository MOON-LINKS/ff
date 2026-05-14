import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/item/images/image_carousel.dart';
import 'package:moonlinks/menu/elements/item/images/main_image.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class ItemImages extends StatefulWidget {
  final String mainImg;
  final List<String> images;
  final Function(String) mainImageChange;
  final Function(List<String>) imagesChange;
  const ItemImages(
      {super.key,
      required this.mainImg,
      required this.images,
      required this.mainImageChange,
      required this.imagesChange});

  @override
  State<ItemImages> createState() => _ItemImagesState();
}

class _ItemImagesState extends State<ItemImages> {
  late String mainImage;
  late List<String> imagesList;
  @override
  void initState() {
    super.initState();

    mainImage = widget.mainImg;
    imagesList = widget.images;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.mainImageChange(mainImage);
      widget.imagesChange(imagesList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CustomMenuTitle(child: AppLocalizations.of(context)!.menu_images),
        MainImage(
          mainImg: mainImage,
          onImageSelected: (path) {
            setState(() {
              mainImage = path;
            });
            widget.mainImageChange(mainImage);

            if (mainImage.isEmpty) {
              imagesList.clear();
              widget.imagesChange(imagesList);
            }
          },
        ),
        /* Image Carousel */
        if (mainImage.isNotEmpty)
          ImageCarousel(
            images: imagesList,
            newImages: (images) {
              setState(() {
                imagesList = images;
              });
            },
          )
      ],
    );
  }
}
