import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';

class Cart extends ConsumerStatefulWidget {
  final VoidCallback openCart;
  const Cart({super.key, required this.openCart});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return Positioned(
        bottom: 20,
        right: 20,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              onPressed: widget.openCart,
              backgroundColor: Colors.purple,
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
              ),
            ),
            Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    '${cart.length}',
                    style: TextStyle(fontSize: 14),
                  ),
                ))
          ],
        ));
  }
}
