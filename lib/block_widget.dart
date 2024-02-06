import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  final int value;
  const BlockWidget({super.key, required this.value});

  Color getColor(int value) {
    if (value == 0) {
      return const Color.fromARGB(255, 205, 193, 180);
    }
    if (value == 2) {
      return const Color.fromARGB(255, 238, 228, 218);
    }
    if (value == 4) {
      return const Color.fromARGB(255, 237, 224, 199);
    }
    if (value == 8) {
      return const Color.fromARGB(255, 242, 177, 122);
    }
    if (value == 16) {
      return const Color.fromARGB(255, 245, 149, 99);
    }
    if (value == 32) {
      return const Color.fromARGB(255, 255, 116, 85);
    }
    // rgb(187, 173, 160) - background
    // rgb(205, 193, 180) - 0
    // rgb(238, 228, 218)
    // rgb(237, 224, 199) - 4
    // rgb(242, 177, 122)
    // rgb(245, 149, 99)
    // rgb(255, 116, 85) - 32
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getColor(value),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
