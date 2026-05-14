import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/item/images/carousel/custom_carousel_image.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final Function(List<String>) newImages;
  const ImageCarousel(
      {super.key, required this.images, required this.newImages});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  bool isLoading = false;
  String? imgPicked;
  late List<String> imagesPicked;
  @override
  void initState() {
    super.initState();

    imagesPicked = widget.images;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.newImages(imagesPicked);
    });
  }

  Future<void> _pickAndEditImage() async {
    final picked = await customPickImage(context, 19 / 15);

    setState(() {
      isLoading = true;
      imgPicked = picked;
      imagesPicked.add(imgPicked!);
      widget.newImages(imagesPicked);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            Text(
              '${AppLocalizations.of(context)!.menu_image_carousel}: ',
              style: TextStyle(color: Colors.white),
            ),
            Wrap(
                spacing: 30,
                runSpacing: 30,
                children: imagesPicked.map<Widget>((image) {
                  return CustomCarouselImage(
                    imageUrl: image,
                    deleteImage: () {
                      setState(() {
                        imagesPicked.remove(image);
                        widget.newImages(imagesPicked);
                      });
                    },
                  );
                }).toList()),
            CustomMenuButton(
                onPressed: _pickAndEditImage,
                child: AppLocalizations.of(context)!.menu_add_image)
          ],
        ));
  }
}
