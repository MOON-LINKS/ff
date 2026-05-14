import 'package:flutter/material.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomOffer extends StatefulWidget {
  final String offer;
  final Function(String) offerChange;
  const CustomOffer(
      {super.key, required this.offer, required this.offerChange});

  @override
  State<CustomOffer> createState() => _CustomOfferState();
}

class _CustomOfferState extends State<CustomOffer> {
  late String offerUrl;
  final menuAPI = MenuService();
  @override
  void initState() {
    super.initState();
    offerUrl = widget.offer;
  }

  @override
  void didUpdateWidget(covariant CustomOffer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.offer != widget.offer) {
      setState(() {
        offerUrl = widget.offer;
      });
    }
  }

  void pickImage() async {
    final url = await customPickImage(context, .8);
    if (url.isNotEmpty) {
      setState(() {
        offerUrl = url;
        widget.offerChange(offerUrl);
      });
    }
  }

  void deleteoffer() async {
    setState(() {
      offerUrl = '';
      widget.offerChange(offerUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return offerUrl != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Image.network(
                    '$customServerName$offerUrl',
                    width: 200,
                    height: 250,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  CustomMenuButton(onPressed: pickImage, child: 'change'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomMenuButton(onPressed: deleteoffer, child: 'delete')
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
