// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:game_2048/game_configs.dart';

import 'block_model.dart';

class MovementLogic {
  static MovementDetails performMove(String dir, List<BlockModel> allBlocks) {
    List<BlockModel> blocks = allBlocks;

    if (dir == 'right') {
      final result = goRight(blocks);
      return result;
    }
    if (dir == 'left') {
      final result = goLeft(blocks);
      return result;
    }

    if (dir == 'bottom') {
      final result = goBottom(blocks);
      return result;
    }
    if (dir == 'top') {
      final result = goTop(blocks);
      return result;
    }

    /// if movement is not detected
    return MovementDetails(
      blocks: blocks,
      needAnimation: false,
      needDublicateRemoval: false,
    );
  }

  static MovementDetails goRight(List<BlockModel> allblocks) {
    List<BlockModel> blocks = [...allblocks];
    List<BlockModel> updatedBlocks = [];
    Map<double, bool> combinationCertificate = {};
    bool needAnimation = false;
    bool needDublicateRemoval = false;
    blocks.sort((a, b) => b.x!.compareTo(a.x!));
    for (int i = 0; i < blocks.length; i++) {
      final details = goRightSingeBlock(
        blocks[i],
        blocks,
        combinationCertificate,
      );
      combinationCertificate = details.combinationCertificate!;
      if (details.needAnimation!) needAnimation = true;
      if (details.needDublicateRemoval!) needDublicateRemoval = true;
      updatedBlocks.add(details.updatedBlock!);
    }
    final result = MovementDetails(
      blocks: updatedBlocks,
      needAnimation: needAnimation,
      needDublicateRemoval: needDublicateRemoval,
    );
    return result;
  }

  static SingleBlockMoveDetails goRightSingeBlock(
    BlockModel currentBlock,
    List<BlockModel> blocksInSameRow,
    Map<double, bool> combinationCertificate,
  ) {
    BlockModel block = currentBlock;
    List<BlockModel> blocksInGroup = [...blocksInSameRow];
    // get rid of all the blocks that are not in this row (or column)
    blocksInGroup.removeWhere((b) => b.y != block.y);
    // remove the current block
    blocksInGroup.remove(block);
    // after removing current block, if no blocks remain in the list,
    // then move the current block furthest, and we are done.
    if (blocksInGroup.isEmpty) {
      block.x_last = block.x;
      block.y_last = block.y;
      block.x = lastPositionX;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.x != block.x_last,
        needDublicateRemoval: false,
      );
    }
    // sort the block in order small x to big x
    blocksInGroup.sort((a, b) => a.x!.compareTo(b.x!));
    // if the current block has the biggest x in blocks then we can't move any further
    // so just return the block
    if (block.x! > blocksInGroup.last.x!) {
      block.x_last = block.x;
      block.y_last = block.y;
      block.x = lastPositionX;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.x != block.x_last,
        needDublicateRemoval: false,
      );
    }
    // some properties of current block
    double currentX = block.x ?? 0;
    double currentY = block.y ?? 0;
    double nextX = currentX;
    bool hasCombinePermission = checkCombinePermission(
      combinationCertificate,
      currentY,
    );
    // look at the other possible positions in the block
    while (true) {
      nextX = nextX + distanceBetweenTwoBlocks;
      bool blockExistHere = checkForBlockInALocation(
        blocksInGroup,
        nextX,
        currentY,
      );
      if (blockExistHere) {
        // check here if we should combine or not.
        if (hasCombinePermission) {
          // has combine permission
          final nextBlock = getBlockFromALocation(
            blocksInGroup,
            nextX,
            currentY,
          );
          // check if the value is same
          // if same value then combine
          if (nextBlock.value == block.value) {
            // blocksInGroup.remove(nextBlock);
            // nextBlock.value = nextBlock.value! * 2;
            // blocksInGroup.add(nextBlock);
            block.x_last = currentX;
            block.y_last = block.y;
            block.x = nextX;
            block.value = block.value! * 2;
            // final certificate = <double, bool>{currentY: true};
            // update cirtificate
            combinationCertificate[currentY] = true;
            // need animation and dublication removal
            return SingleBlockMoveDetails(
              updatedBlock: block,
              combinationCertificate: combinationCertificate,
              needAnimation: true,
              needDublicateRemoval: true,
            );
          }
        }
        nextX = nextX - distanceBetweenTwoBlocks;
        break;
      }
      if (nextX >= lastPositionX) {
        nextX = lastPositionX;
        break;
      }
    }
    block.x_last = currentX;
    block.y_last = block.y;
    block.x = nextX;
    return SingleBlockMoveDetails(
      updatedBlock: block,
      combinationCertificate: combinationCertificate,
      needAnimation: block.x != block.x_last,
      needDublicateRemoval: false,
    );
  }

  static MovementDetails goLeft(List<BlockModel> allblocks) {
    List<BlockModel> blocks = [...allblocks];
    List<BlockModel> updatedBlocks = [];
    Map<double, bool> combinationCertificate = {};
    bool needAnimation = false;
    bool needDublicateRemoval = false;
    blocks.sort((a, b) => a.x!.compareTo(b.x!));
    for (int i = 0; i < blocks.length; i++) {
      final details = goLeftSingeBlock(
        blocks[i],
        blocks,
        combinationCertificate,
      );
      combinationCertificate = details.combinationCertificate!;
      if (details.needAnimation!) needAnimation = true;
      if (details.needDublicateRemoval!) needDublicateRemoval = true;
      updatedBlocks.add(details.updatedBlock!);
    }
    final result = MovementDetails(
      blocks: updatedBlocks,
      needAnimation: needAnimation,
      needDublicateRemoval: needDublicateRemoval,
    );
    return result;
  }

  static SingleBlockMoveDetails goLeftSingeBlock(
    BlockModel currentBlock,
    List<BlockModel> blocksInSameRow,
    Map<double, bool> combinationCertificate,
  ) {
    BlockModel block = currentBlock;
    block.y_last = block.y;
    List<BlockModel> blocksInGroup = [...blocksInSameRow];
    blocksInGroup.removeWhere((b) => b.y != block.y);
    blocksInGroup.remove(block);
    if (blocksInGroup.isEmpty) {
      block.x_last = block.x;
      block.x = firstPositionX;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.x != block.x_last,
        needDublicateRemoval: false,
      );
    }
    blocksInGroup.sort((a, b) => a.x!.compareTo(b.x!));
    if (block.x! < blocksInGroup.first.x!) {
      block.x_last = block.x;
      block.x = firstPositionX;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.x != block.x_last,
        needDublicateRemoval: false,
      );
    }
    double currentX = block.x ?? 0;
    double currentY = block.y ?? 0;
    double nextX = currentX;
    bool hasCombinePermission = checkCombinePermission(
      combinationCertificate,
      currentY,
    );
    while (true) {
      nextX = nextX - distanceBetweenTwoBlocks;
      bool blockExistHere = checkForBlockInALocation(
        blocksInGroup,
        nextX,
        currentY,
      );
      if (blockExistHere) {
        if (hasCombinePermission) {
          final nextBlock = getBlockFromALocation(
            blocksInGroup,
            nextX,
            currentY,
          );
          // check if the value is same
          // if same value then combine
          if (nextBlock.value == block.value) {
            // blocksInGroup.remove(nextBlock);
            // nextBlock.value = nextBlock.value! * 2;
            // blocksInGroup.add(nextBlock);
            block.x_last = currentX;
            block.x = nextX;
            block.value = block.value! * 2;
            // final certificate = <double, bool>{currentY: true};
            // update cirtificate
            combinationCertificate[currentY] = true;
            // need animation and dublication removal
            return SingleBlockMoveDetails(
              updatedBlock: block,
              combinationCertificate: combinationCertificate,
              needAnimation: true,
              needDublicateRemoval: true,
            );
          }
        }
        nextX = nextX + distanceBetweenTwoBlocks;
        break;
      }
      if (nextX <= firstPositionX) {
        nextX = lastPositionX;
        break;
      }
    }
    block.x_last = currentX;
    block.x = nextX;
    return SingleBlockMoveDetails(
      updatedBlock: block,
      combinationCertificate: combinationCertificate,
      needAnimation: block.x != block.x_last,
      needDublicateRemoval: false,
    );
  }

  static MovementDetails goBottom(List<BlockModel> allblocks) {
    List<BlockModel> blocks = [...allblocks];
    List<BlockModel> updatedBlocks = [];
    Map<double, bool> combinationCertificate = {};
    bool needAnimation = false;
    bool needDublicateRemoval = false;
    blocks.sort((a, b) => b.y!.compareTo(a.y!));
    for (int i = 0; i < blocks.length; i++) {
      final details = goBottomSingeBlock(
        blocks[i],
        blocks,
        combinationCertificate,
      );
      combinationCertificate = details.combinationCertificate!;
      if (details.needAnimation!) needAnimation = true;
      if (details.needDublicateRemoval!) needDublicateRemoval = true;
      updatedBlocks.add(details.updatedBlock!);
    }
    final result = MovementDetails(
      blocks: updatedBlocks,
      needAnimation: needAnimation,
      needDublicateRemoval: needDublicateRemoval,
    );

    return result;
  }

  static SingleBlockMoveDetails goBottomSingeBlock(
    BlockModel currentBlock,
    List<BlockModel> blocksInSameRow,
    Map<double, bool> combinationCertificate,
  ) {
    BlockModel block = currentBlock;
    block.x_last = block.x;
    block.y_last = block.y;
    List<BlockModel> blocksInGroup = [...blocksInSameRow];
    blocksInGroup.removeWhere((b) => b.x != block.x);
    blocksInGroup.remove(block);
    if (blocksInGroup.isEmpty) {
      block.y = lastPositionY;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.y != block.y_last,
        needDublicateRemoval: false,
      );
    }
    blocksInGroup.sort((a, b) => b.y!.compareTo(a.y!));
    if (block.y! > blocksInGroup.first.y!) {
      block.y = lastPositionY;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.y != block.y_last,
        needDublicateRemoval: false,
      );
    }
    double currentX = block.x ?? 0;
    double currentY = block.y ?? 0;
    double nextY = currentY;
    bool hasCombinePermission = checkCombinePermission(
      combinationCertificate,
      currentX,
    );
    while (true) {
      nextY = nextY + distanceBetweenTwoBlocks;
      bool blockExistHere = checkForBlockInALocation(
        blocksInGroup,
        currentX,
        nextY,
      );
      if (blockExistHere) {
        if (hasCombinePermission) {
          final nextBlock = getBlockFromALocation(
            blocksInGroup,
            currentX,
            nextY,
          );
          if (nextBlock.value == block.value) {
            block.y = nextY;
            block.value = block.value! * 2;
            combinationCertificate[currentX] = true;
            return SingleBlockMoveDetails(
              updatedBlock: block,
              combinationCertificate: combinationCertificate,
              needAnimation: true,
              needDublicateRemoval: true,
            );
          }
        }
        nextY = nextY - distanceBetweenTwoBlocks;
        break;
      }
      if (nextY >= lastPositionY) {
        nextY = lastPositionY;
        break;
      }
    }
    block.y = nextY;
    return SingleBlockMoveDetails(
      updatedBlock: block,
      combinationCertificate: combinationCertificate,
      needAnimation: block.y != block.y_last,
      needDublicateRemoval: false,
    );
  }

  static MovementDetails goTop(List<BlockModel> allblocks) {
    debugPrint('going top');
    List<BlockModel> blocks = [...allblocks];
    List<BlockModel> updatedBlocks = [];
    Map<double, bool> combinationCertificate = {};
    bool needAnimation = false;
    bool needDublicateRemoval = false;
    blocks.sort((a, b) => a.y!.compareTo(a.y!));
    debugPrint('a-> ${blocks[0].y} b-> ${blocks.last.y}');
    for (int i = 0; i < blocks.length; i++) {
      final details = goTopSingeBlock(
        blocks[i],
        blocks,
        combinationCertificate,
      );
      combinationCertificate = details.combinationCertificate!;
      if (details.needAnimation!) needAnimation = true;
      if (details.needDublicateRemoval!) needDublicateRemoval = true;
      updatedBlocks.add(details.updatedBlock!);
    }
    final result = MovementDetails(
      blocks: updatedBlocks,
      needAnimation: needAnimation,
      needDublicateRemoval: needDublicateRemoval,
    );

    return result;
  }

  static SingleBlockMoveDetails goTopSingeBlock(
    BlockModel currentBlock,
    List<BlockModel> blocksInSameRow,
    Map<double, bool> combinationCertificate,
  ) {
    BlockModel block = currentBlock;
    block.x_last = block.x;
    List<BlockModel> blocksInGroup = [...blocksInSameRow];
    blocksInGroup.removeWhere((b) => b.x != block.x);
    blocksInGroup.remove(block);
    if (blocksInGroup.isEmpty) {
      block.y_last = block.y;
      block.y = firstPostionY;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.y != block.y_last,
        needDublicateRemoval: false,
      );
    }
    blocksInGroup.sort((a, b) => a.y!.compareTo(b.y!));
    if (block.y! < blocksInGroup.last.y!) {
      block.y_last = block.y;
      block.y = firstPostionY;
      return SingleBlockMoveDetails(
        updatedBlock: block,
        combinationCertificate: combinationCertificate,
        needAnimation: block.y != block.y_last,
        needDublicateRemoval: false,
      );
    }
    double currentX = block.x ?? 0;
    double currentY = block.y ?? 0;
    double nextY = currentY;
    bool hasCombinePermission = checkCombinePermission(
      combinationCertificate,
      currentX,
    );
    while (true) {
      nextY = nextY - distanceBetweenTwoBlocks;
      bool blockExistHere = checkForBlockInALocation(
        blocksInGroup,
        currentX,
        nextY,
      );
      if (blockExistHere) {
        if (hasCombinePermission) {
          final nextBlock = getBlockFromALocation(
            blocksInGroup,
            currentX,
            nextY,
          );
          if (nextBlock.value == block.value) {
            block.y_last = currentY;
            block.y = nextY;
            block.value = block.value! * 2;
            combinationCertificate[currentX] = true;
            return SingleBlockMoveDetails(
              updatedBlock: block,
              combinationCertificate: combinationCertificate,
              needAnimation: true,
              needDublicateRemoval: true,
            );
          }
        }
        nextY = nextY + distanceBetweenTwoBlocks;
        break;
      }
      if (nextY <= lastPositionY) {
        nextY = lastPositionY;
        break;
      }
    }
    block.y_last = currentY;
    block.y = nextY;
    return SingleBlockMoveDetails(
      updatedBlock: block,
      combinationCertificate: combinationCertificate,
      needAnimation: block.y != block.y_last,
      needDublicateRemoval: false,
    );
  }

  static bool checkForBlockInALocation(
    List<BlockModel> blocks,
    double x,
    double y,
  ) {
    for (BlockModel b in blocks) {
      if (b.x == x && b.y == y) {
        return true;
      }
    }
    return false;
  }

  static bool checkCombinePermission(
    Map<double, bool> combinationCertificate,
    double rowOrcolumn,
  ) {
    if (combinationCertificate.containsKey(rowOrcolumn)) {
      if (combinationCertificate[rowOrcolumn] == true) {
        return false;
      }
    }
    return true;
  }

  static BlockModel getBlockFromALocation(
    List<BlockModel> blocks,
    double x,
    double y,
  ) {
    final block = blocks.where((e) => e.x == x && e.y == y).first;
    return block;
  }
}
