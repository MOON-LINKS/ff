import 'package:flutter/material.dart';

class RadialBackground extends StatelessWidget {
  final Widget child;
  const RadialBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [Colors.purple, Colors.black],
          stops: [0.0, .5],
        ),
      ),
      child: child,
    );
  }
}
