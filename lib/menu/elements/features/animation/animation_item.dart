import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class AnimationItem extends StatefulWidget {
  final String animationType;
  final Color color;
  final VoidCallback onAnimationFinished;
  final bool shouldAnimate;
  const AnimationItem(
      {super.key,
      required this.animationType,
      required this.color,
      required this.onAnimationFinished,
      required this.shouldAnimate});
  @override
  State<AnimationItem> createState() => _AnimationItemState();
}

class _AnimationItemState extends State<AnimationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  //items

  late List<Animation<double>> _opacityAnimations;
  late List<Animation<Offset>> _axisAnimations;
  final int _elCount = 6;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.animationType != 'none') {
      _opacityAnimations = List.generate(_elCount, (index) {
        final start = index * 0.2;
        final end = start + 0.5;
        return Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              start.clamp(0.0, 1.0),
              end.clamp(0.0, 1.0),
              curve: Curves.easeInOut,
            ),
          ),
        );
      });
      if (widget.animationType == 'x-axis') {
        _axisAnimations = List.generate(_elCount, (index) {
          final start = index * 0.2;
          final end = start + 0.5;
          return Tween<Offset>(begin: Offset(-.5, 0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                start.clamp(0.0, 1.0),
                end.clamp(0.0, 1.0),
                curve: Curves.easeInOut,
              ),
            ),
          );
        });
      } else if (widget.animationType == 'y-axis') {
        _axisAnimations = List.generate(_elCount, (index) {
          final start = index * 0.2;
          final end = start + 0.5;
          return Tween<Offset>(begin: Offset(0, .5), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                start.clamp(0.0, 1.0),
                end.clamp(0.0, 1.0),
                curve: Curves.easeInOut,
              ),
            ),
          );
        });
      } else {
        _axisAnimations = List.generate(_elCount, (index) {
          return Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ),
          );
        });
      }
    } else {
      _opacityAnimations = List.generate(_elCount, (index) {
        return Tween<double>(begin: 1, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
      });
      _axisAnimations = List.generate(_elCount, (index) {
        return Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
      });
    }

    _controller.forward(from: 0);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationFinished();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.shouldAnimate && widget.shouldAnimate) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 5, children: [
      Text(widget.animationType.toUpperCase(),
          style: TextStyle(color: widget.color, fontSize: 15)),
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              padding: EdgeInsets.only(bottom: 10),
              color: Colors.grey,
              child: Column(
                children: [
                  Stack(clipBehavior: Clip.none, children: [
                    SlideTransition(
                        position: _axisAnimations[0],
                        child: FadeTransition(
                            opacity: _opacityAnimations[0],
                            child: Container(
                                width: double.infinity,
                                height: 100,
                                color: Colors.blueGrey,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .menu_banner,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20)))))),
                    Positioned(
                        top: 75,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: FadeTransition(
                                opacity: _opacityAnimations[1],
                                child: SlideTransition(
                                    position: _axisAnimations[1],
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: widget.color,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                color: Colors.white, width: 2)),
                                        child: Center(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .menu_logo,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15))))))))
                  ]),
                  const SizedBox(height: 30),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 20,
                    runSpacing: 20,
                    children: List.generate(3, (index) {
                      return FadeTransition(
                        opacity: _opacityAnimations[index + 2],
                        child: SlideTransition(
                            position: _axisAnimations[index + 2],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 45,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: widget.color),
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.network(
                                      'https://cdn.moonlinks.me/category/burger-021.svg',
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.contain,
                                    ),
                                    Container(
                                      color: widget.color,
                                      child: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .menu_food,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    }),
                  )
                ],
              )))
    ]);
  }
}
