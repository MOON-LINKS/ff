/* 
//COMPUTE
import 'package:flutter/foundation.dart';

int firstNumber(List<int> numbers) {
  return numbers[0];
}

void main() async {
  int results = await compute(firstNumber, [1, 2, 3, 4]);
} */

/* 
//ISOLATE
import 'dart:isolate';

void heavyTask(SendPort sendPort) {
  int sum = 10;

  sendPort.send(sum);
}

void main() async {
  final recievePort = ReceivePort();

  await Isolate.spawn(heavyTask, recievePort.sendPort);
  final result = await recievePort.first;
  print(result);
}
 */

/* //LOADER RIVE
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _startApp();
  }

  Future<void> _startApp() async {
    // Simulate loading OR wait for animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: RiveAnimation.asset(
            'assets/loader.riv',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
} */

/*
RIVERPOD
Provider → exposes state
Notifier → controls state


import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final int quantity;

  CartItem({required this.id, required this.quantity});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier(super.state);
  //logic functions
  void addItem(CartItem item) {
    state = [...state, item];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
    (ref) => CartNotifier([]));
*/

/* TWEEN Animation */
/* import 'package:flutter/material.dart';

class ZTest extends StatefulWidget {
  const ZTest({super.key});

  @override
  State<ZTest> createState() => _ZTestState();
}

class _ZTestState extends State<ZTest> with TickerProviderStateMixin {
  late AnimationController controller1;
  late Animation<double> scale;
  late Animation<Offset> slide;
  late Animation<Color?> colorChange;
  @override
  void initState() {
    super.initState();

    controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    //Interval(START %, END % , curve: Curves.__)
    scale = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller1, curve: Interval(0, 1, curve: Curves.bounceIn)));
    slide = Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).animate(
        CurvedAnimation(
            parent: controller1,
            curve: Interval(0, 1, curve: Curves.bounceIn)));
    colorChange = ColorTween(
      begin: Colors.white,
      end: Colors.purple,
    ).animate(
      CurvedAnimation(
        parent: controller1,
        curve: const Interval(0, 1, curve: Curves.bounceIn),
      ),
    );
    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // AnimatedBuilder if ColorTween used and instead of ScaleTransition we use Transform.scale()
        // AnimatedBuilder(
        //   animation: controller1,
        //   builder: (context, child) {
        //     return Transform.__;
        //   },
        // );

        SlideTransition(
            position: slide,
            child: ScaleTransition(
                scale: scale,
                child: (Container(
                  width: 200,
                  height: 200,
                  color: colorChange.value,
                ))));
  }
}
 */

/* On Scroll Animation */
/* will use:
ScrollController
NotificationListener<ScrollNotification>
RenderBox
*/
/*
//BASIC
import 'package:flutter/material.dart';

class ZTest extends StatefulWidget {
  const ZTest({super.key});

  @override
  State<ZTest> createState() => _ZTestState();
}

class _ZTestState extends State<ZTest> with TickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  double progress = 0;
  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        progress = (controller.offset / 300).clamp(0.0, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: [
        Container(height: 500),
        Transform.scale(
            scale: (.5 + .5 * progress),
            child: Container(
              width: 150,
              height: 150,
              color: Colors.purple,
            )),
        Container(height: 1000),
      ],
    );
  }
}
*/
//advanced scroll trigger
//AIM is to create a reuasble scroll trigger
//code that will be called:

import 'package:flutter/material.dart';

class ScrollTrigger extends StatefulWidget {
  final Widget Function(double progress) builder;

  const ScrollTrigger({super.key, required this.builder});

  @override
  State<ScrollTrigger> createState() => _ScrollTriggerState();
}

class _ScrollTriggerState extends State<ScrollTrigger> {
  final ScrollController _controller = ScrollController();
  double progress = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (!_controller.hasClients) return;

      final max = _controller.position.maxScrollExtent;
      final current = _controller.offset;

      final p = max == 0 ? 0.0 : (current / max);

      setState(() {
        progress = p.clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      children: [
        widget.builder(progress),
      ],
    );
  }
}

//how to use it and call it
class ZTest extends StatefulWidget {
  const ZTest({super.key});

  @override
  State<ZTest> createState() => _ZTestState();
}

class _ZTestState extends State<ZTest> {
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    return ScrollTrigger(builder: (progress) {
      return Column(children: [
        Container(height: 500),
        Transform.scale(
          scale: 0.5 + progress * 0.5,
          child: Container(
            width: 150,
            height: 150,
            color: Colors.purple,
          ),
        ),
        Container(height: 1000),
      ]);
    });
  }
}
