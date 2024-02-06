// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_2048/block_model.dart';
import 'package:game_2048/game_configs.dart';

class BlockUtils {
  static void printMovementSummary(String dir, List<BlockModel> blocks) {
    debugPrint('-------------movement Summary-----------------------');
    debugPrint('direction -> $dir');
    debugPrint('old matrics');
    debugPrint('-------------------------------');
    debugPrint(
      '1: ${p_nt_p(blocks, 0, 0)} ${p_nt_p(blocks, 100, 0)} ${p_nt_p(blocks, 200, 0)} ${p_nt_p(blocks, 300, 0)}',
    );
    debugPrint(
      '2: ${p_nt_p(blocks, 0, 100)} ${p_nt_p(blocks, 100, 100)} ${p_nt_p(blocks, 200, 100)} ${p_nt_p(blocks, 300, 100)}',
    );
    debugPrint(
      '3: ${p_nt_p(blocks, 0, 200)} ${p_nt_p(blocks, 100, 200)} ${p_nt_p(blocks, 200, 200)} ${p_nt_p(blocks, 300, 200)}',
    );
    debugPrint(
      '4: ${p_nt_p(blocks, 0, 300)} ${p_nt_p(blocks, 100, 300)} ${p_nt_p(blocks, 200, 300)} ${p_nt_p(blocks, 300, 300)}',
    );
    debugPrint('-------------------------------');
    debugPrint('--------------to---------------');
    debugPrint('new matrics');
    debugPrint('-------------------------------');
    debugPrint(
      '1: ${p_nt(blocks, 0, 0)} ${p_nt(blocks, 100, 0)} ${p_nt(blocks, 200, 0)} ${p_nt(blocks, 300, 0)}',
    );
    debugPrint(
      '2: ${p_nt(blocks, 0, 100)} ${p_nt(blocks, 100, 100)} ${p_nt(blocks, 200, 100)} ${p_nt(blocks, 300, 100)}',
    );
    debugPrint(
      '3: ${p_nt(blocks, 0, 200)} ${p_nt(blocks, 100, 200)} ${p_nt(blocks, 200, 200)} ${p_nt(blocks, 300, 200)}',
    );
    debugPrint(
      '4: ${p_nt(blocks, 0, 300)} ${p_nt(blocks, 100, 300)} ${p_nt(blocks, 200, 300)} ${p_nt(blocks, 300, 300)}',
    );
    debugPrint('-------------------------------');
    debugPrint('----------------------------------------------------');
  }

  static String p_nt_p(List<BlockModel> blocks, double x, double y) {
    List<BlockModel> targetBlocks = [];
    for (BlockModel b in blocks) {
      if (b.x_last == x && b.y_last == y) {
        targetBlocks.add(b);
      }
    }
    return targetBlocks.map((e) => e.value).toList().toString();
  }

  static String p_nt(List<BlockModel> blocks, double x, double y) {
    List<BlockModel> targetBlocks = [];
    for (BlockModel b in blocks) {
      if (b.x == x && b.y == y) {
        targetBlocks.add(b);
      }
    }
    return targetBlocks.map((e) => e.value).toList().toString();
  }

  /// remove dublicated from a list of blocks
  static List<BlockModel> removeDublicated(List<BlockModel> allblocks) {
    debugPrint('--------start of removeDublicate-----------');
    List<BlockModel> blocks = [...allblocks];
    debugPrint(
        'total blocks ${blocks.map((e) => e.value).toList().toString()}');
    for (int i = 0; i < allPossibleLocations.length; i++) {
      double targetX = allPossibleLocations[i].first;
      double targetY = allPossibleLocations[i].last;
      List<BlockModel> blocksHere = blocks.where((e) {
        double x = e.x ?? 0;
        double y = e.y ?? 0;
        return (x == targetX && y == targetY);
      }).toList();
      if (blocksHere.isEmpty || blocksHere.length == 1) {
        continue;
      }
      debugPrint(
        'blocks at $targetX, $targetY -> ${blocksHere.map((e) => e.value).toList().toString()}',
      );
      blocksHere.sort((a, b) => b.value!.compareTo(a.value!));
      blocksHere.removeAt(0);
      for (int j = 0; j < blocksHere.length; j++) {
        debugPrint('removing ${blocksHere[j].value} at $targetX, $targetY.');
        blocks.remove(blocksHere[j]);
      }
    }
    debugPrint(
      'after removing dublicates ${blocks.map((e) => e.value).toList().toString()}',
    );
    debugPrint('--------end of removeDublicate-----------');
    return blocks;
  }

  static BlockModel? addABlockInTheList(List<BlockModel> allblocks) {
    List<BlockModel> blocks = [...allblocks];
    List<List<double>> availableLocs = [];
    for (int i = 0; i < allPossibleLocations.length; i++) {
      final existingBlocks = blocks
          .where((e) =>
              e.x == allPossibleLocations[i].first &&
              e.y == allPossibleLocations[i].last)
          .toList();
      if (existingBlocks.isEmpty) {
        availableLocs.add(
          [allPossibleLocations[i].first, allPossibleLocations[i].last],
        );
      }
    }
    if (availableLocs.isEmpty) {
      return null;
    }
    int index = Random().nextInt(availableLocs.length);
    final newBlock = BlockModel(
      value: 2,
      x: availableLocs[index].first,
      y: availableLocs[index].last,
    );
    return newBlock;
  }
}
