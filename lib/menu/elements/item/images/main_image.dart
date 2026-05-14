import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class MainImage extends StatefulWidget {
  final String mainImg;
  final Function(String) onImageSelected;
  const MainImage(
      {super.key, required this.mainImg, required this.onImageSelected});

  @override
  State<MainImage> createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
  String imgPicked = '';
  @override
  void initState() {
    super.initState();
    if (widget.mainImg.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        imgPicked = widget.mainImg;
      });
    }
  }

  Future<void> _pickAndEditImage() async {
    final picked = await customPickImage(context, 19 / 15);

    widget.onImageSelected(picked);
    setState(() {
      imgPicked = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        GestureDetector(
          onTap: _pickAndEditImage,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: imgPicked == ''
                ? Icon(
                    Icons.image,
                    size: 100,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      '$customServerName$imgPicked',
                      width: 150,
                      height: 118.4,
                      fit: BoxFit.cover,
                    )),
          ),
        ),
        const SizedBox(height: 10),
        if (imgPicked != '')
          CustomMenuButton(
              child: AppLocalizations.of(context)!.menu_delete_image,
              onPressed: () => setState(() {
                    imgPicked = '';
                    widget.onImageSelected('');
                  }))
      ],
    ));
  }
}
