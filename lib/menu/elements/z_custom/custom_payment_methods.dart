import 'package:flutter/material.dart';

class CustomPaymentMethods extends StatefulWidget {
  const CustomPaymentMethods({super.key});

  @override
  State<CustomPaymentMethods> createState() => _CustomPaymentMethodsState();
}

class _CustomPaymentMethodsState extends State<CustomPaymentMethods> {
  final urls = [
    'applepay.jpg',
    'googlepay.jpg',
    'link.jpg',
    'mastercard.jpg',
    'paypal.jpg',
    'stripe.jpg',
    'visadebitcard.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: urls.map<Widget>((item) {
          return ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Image.network(
                width: 70,
                'https://cdn.moonlinks.me/payment/$item',
                fit: BoxFit.cover,
              ));
        }).toList(),
      ),
    );
  }
}
