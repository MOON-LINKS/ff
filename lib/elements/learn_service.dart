import 'package:flutter/material.dart';
import '../web/webview_screen.dart';

class LearnService extends StatelessWidget {
  final String text;
  final List<VideoLearn> videos;
  const LearnService({super.key, required this.text, required this.videos});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80), topRight: Radius.circular(80)),
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 40),
              child: Text(
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                  text)),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80))),
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: videos))
        ],
      ),
    );
  }
}

class VideoLearn extends StatelessWidget {
  final String destination; // YouTube video ID

  const VideoLearn({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final maxRes = 'https://img.youtube.com/vi/$destination/maxresdefault.jpg';
    final fallback = 'https://img.youtube.com/vi/$destination/0.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => openExternalUrl(
          context,
          'https://www.youtube.com/watch?v=$destination',
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thumbnail
              Image.network(
                maxRes,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.network(
                  fallback,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              // Optional dark overlay
              Container(
                width: double.infinity,
                height: 200,
                color: const Color.fromARGB(103, 0, 0, 0),
              ),

              const Icon(
                Icons.play_circle_fill,
                size: 80,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
