import 'package:flutter/material.dart';

class InnerPriceCard extends StatefulWidget {
  final String planType;
  final List<String> durations;
  const InnerPriceCard({
    super.key,
    required this.planType,
    required this.durations,
  });
  @override
  State<InnerPriceCard> createState() => _InnerPriceCard();
}

class _InnerPriceCard extends State<InnerPriceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.planType),
              //dropdown menu where items are durations, when one chosen, change the price to
            ],
          ),
          Row(
            children: [
              Text('\$ price'),
              //ElevatedButton(onPressed: , child: Icon(key: //duration.id,))
            ],
          ),
        ],
      ),
    );
  }
}
