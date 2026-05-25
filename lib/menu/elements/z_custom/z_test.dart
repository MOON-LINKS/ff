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
/* 
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
 */

//HERO ANIMATION
/* import 'package:flutter/material.dart';

class ZTest extends StatelessWidget {
  const ZTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PageB()),
            );
          },
          child: Hero(
            tag: "box",
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: "box",
          child: Container(
            width: 300,
            height: 300,
            color: Colors.purple,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'hello \n welcome back',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
 */
//overall page trabsition:
/*
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (_, animation, secondaryAnimation) => const PageB(),

    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),

        child: child,
      );
    },
  ),
);
*/
//TEST PAGE
/* import 'package:flutter/material.dart';

class ZTest extends StatefulWidget {
  const ZTest({Key? key}) : super(key: key);

  @override
  _ZTestState createState() => _ZTestState();
}

class _ZTestState extends State<ZTest> with SingleTickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> scale;
  late Animation<double> fade;
  final scroll = ScrollController();
  double progress = 0;
  final dynamic cards = [Card(0), Card(1), Card(2), Card(3)];

  @override
  void initState() {
    super.initState();
    animation =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    scale = Tween<double>(begin: .5, end: 1).animate(CurvedAnimation(
        parent: animation, curve: Interval(0, 1, curve: Curves.bounceIn)));
    fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation, curve: Interval(0.0, 1, curve: Curves.bounceIn)));
    scroll.addListener(() {
      setState(() {
        progress = (scroll.offset / 300).clamp(0.0, 1.0);
      });
    });
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
              scale: scale.value,
              child: ListView(
                controller: scroll,
                children: cards.map((el, index) {
                  return cards[index];
                }).toList(),
              ));
        });
  }
}

class Page2 extends StatefulWidget {
  final int index;
  const Page2(this.index);

  @override
  Page2State createState() => Page2State();
}

class Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: widget.index.toString(),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromARGB(255, 0, 255, 13), width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                  width: 400,
                  height: 200,
                  color: Color.fromARGB(255, 62, 62, 248)),
              Text('test title',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 255, 255, 255))),
              Text('test subtitle',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 255, 255, 255))),
              ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('test btn')));
                  },
                  child: Text('test subtitle')),
            ],
          ),
        ));
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card(this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => Page2(index)));
      },
      child: Hero(
          tag: index.toString(),
          child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromARGB(255, 0, 0, 255), width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                    width: 200,
                    height: 100,
                    color: Color.fromARGB(255, 62, 62, 248)),
                Text('test title',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 255, 255, 255))),
                Text('test subtitle',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 255, 255, 255))),
                ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('test btn')));
                    },
                    child: Text('test subtitle')),
              ],
            ),
          )),
    );
  }
}
 */
/* | # | Topic                               | Why It Matters                                                       |
| - | ----------------------------------- | -------------------------------------------------------------------- |
| 1 | Flutter Rendering Pipeline        | Understand `Widget → Element → RenderObject` instead of only widgets | Widget = description => Element = live mounted identity/lifecycle => RenderObject = visual body
| 2 | State Management Internals        | Learn rebuild optimization and reactive architecture deeply          | 
| 3 | Slivers                           | Build advanced scroll systems and performant feeds                   | SingleChildScrollView or Column = simple scroll wrapper, while: ListView = optimized sliver list abstraction
| 4 | CustomPainter                     | Create graphics, charts, custom visuals, effects                     | Canvas = the drawing surface where Flutter renders graphics manually, and Paint = the styling/configuration used to control how those graphics are drawn (color, stroke, fill, effects); used when building custom visuals, charts, graphics, effects, or highly optimized rendering systems beyond normal widgets.
| 5 | Flutter Performance Engineering   | Master rebuilds, repainting, memory, rendering optimization          |
| 6 | Platform Channels                 | Connect Flutter with native Kotlin/Swift APIs                        |
| 7 | Flutter Engine & GPU Rendering    | Understand Skia, layers, frame scheduling, rendering internals       |
 */
