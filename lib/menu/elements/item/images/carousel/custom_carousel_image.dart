import 'package:flutter/material.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';

class CustomCarouselImage extends StatefulWidget {
  final String imageUrl;
  final VoidCallback deleteImage;
  const CustomCarouselImage(
      {super.key, required this.imageUrl, required this.deleteImage});

  @override
  State<CustomCarouselImage> createState() => _CustomCarouselImageState();
}

class _CustomCarouselImageState extends State<CustomCarouselImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Image.network(
              '$customServerName${widget.imageUrl}',
              width: 80,
              height: 63.1,
              fit: BoxFit.cover,
            )),
        Positioned(
            right: -20,
            bottom: -10,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: IconButton(
                    onPressed: widget.deleteImage,
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.purple,
                      size: 25,
                    ))))
      ],
    );
  }
}
