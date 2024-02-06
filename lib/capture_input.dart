// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:game_2048/movement_provider.dart';
import 'package:game_2048/show_blocks.dart';
import 'package:provider/provider.dart';

class CaptureInput extends StatefulWidget {
  const CaptureInput({super.key});

  @override
  State<CaptureInput> createState() => _CaptureInputState();
}

class _CaptureInputState extends State<CaptureInput> {
  double x_start = 0;
  double x_end = 0;
  double y_start = 0;
  double y_end = 0;
  double dx = 0;
  double dy = 0;
  String direction = 'none';

  void _inputStart(PointerEvent details) {
    x_start = details.position.dx;
    y_start = details.position.dy;
  }

  void _inputEnd(PointerEvent details) {
    x_end = details.position.dx;
    y_end = details.position.dy;
    dx = (x_start - x_end);
    dy = (y_start - y_end);

    if (dx.abs() >= dy.abs()) {
      // swipe in x direction;
      if (dx >= 0) {
        // left to right direction;
        // change it to 'rightToleft', its acting up for some reason
        direction = 'left';
      } else {
        // right to left direction;
        // change it to 'leftToright', its acting up for some reason
        direction = 'right';
      }
    } else {
      // swipe in y direction;
      if (dy >= 0) {
        // bottom to top
        direction = 'top';
      } else {
        // top to bottom
        direction = 'bottom';
      }
    }
    Provider.of<MovementProvider>(context, listen: false).set_dir(direction);
    // Provider.of<MovementProvider>(context, listen: false).updateDeta(direction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Listener(
          onPointerDown: _inputStart,
          onPointerUp: _inputEnd,
          child: const ShowBlocks(),
        ),
      ),
    );
  }
}

class TestShowBlocks extends StatelessWidget {
  const TestShowBlocks({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
