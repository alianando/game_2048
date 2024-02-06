// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:game_2048/block_model.dart';
import 'package:game_2048/block_utils.dart';
import 'package:game_2048/game_configs.dart';
import 'package:game_2048/movement_logic.dart';

class MovementProvider extends ChangeNotifier {
  String direction = '';
  bool shouldAnimate = false;
  bool shouldRemoveDublicate = false;
  bool gameEnd = false;
  int score = 0;

  List<BlockModel> blocks = [
    BlockModel(value: 2, x: 0, y: 0),
    BlockModel(value: 2, x: 95, y: 95),
    BlockModel(value: 2, x: 190, y: 190),
  ];

  void set_dir(String new_dir) {
    shouldAnimate = false;
    shouldRemoveDublicate = false;
    direction = new_dir;
    final result = MovementLogic.performMove(new_dir, blocks);
    blocks = result.blocks;
    // need to sort because it will show higher value at top.
    blocks.sort((a, b) => a.value!.compareTo(b.value!));
    if (result.needAnimation) {
      shouldAnimate = true;
    }
    if (result.needDublicateRemoval) {
      shouldRemoveDublicate = true;
    }
    debugPrint(
      'exicuted a move | animate?-> $shouldAnimate, total blocks-> ${blocks.length} | dublicate exists?-> $shouldRemoveDublicate',
    );
    notifyListeners();
  }

  void removeDublicates() {
    if (shouldRemoveDublicate) {
      blocks = BlockUtils.removeDublicated(blocks);
      shouldAnimate = false;
      notifyListeners();
    }
  }

  void addExtraBlock() {
    final newBlock = BlockUtils.addABlockInTheList(blocks);
    if (newBlock == null) {
      return;
    }
    blocks.add(newBlock);
    shouldAnimate = false;
    shouldRemoveDublicate = false;
    notifyListeners();
  }

  void checkGameEnd() {
    gameEnd = false;
    if (blocks.length == totalNumberOfBlocks) {
      gameEnd = true;
      shouldAnimate = false;
      shouldRemoveDublicate = false;
      notifyListeners();
    }
  }

  void calculateScore() {
    score = 0;
    for (BlockModel b in blocks) {
      score = score + b.value!;
    }
    shouldAnimate = false;
    shouldRemoveDublicate = false;
    notifyListeners();
  }

  void resetGame() {
    blocks = [];
    shouldAnimate = false;
    shouldRemoveDublicate = false;
    gameEnd = false;
    score = 0;
    for (int i = 0; i < 3; i++) {
      final newBlock = BlockUtils.addABlockInTheList(blocks);
      if (newBlock == null) {
        return;
      }
      blocks.add(newBlock);
    }
    notifyListeners();
  }
}
