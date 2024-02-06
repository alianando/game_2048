// ignore_for_file: non_constant_identifier_names

class BlockModel {
  int? value;
  double? x;
  double? y;
  double? x_last;
  double? y_last;
  BlockModel({
    this.value,
    this.x,
    this.y,
    this.x_last,
    this.y_last,
  });
}

class BlockLoc {
  double? x;
  double? y;
  BlockLoc({this.x, this.y});
}

class SingleBlockMoveDetails {
  BlockModel? updatedBlock;
  Map<double, bool>? combinationCertificate;
  bool? needAnimation;
  bool? needDublicateRemoval;
  SingleBlockMoveDetails({
    this.updatedBlock,
    this.combinationCertificate,
    this.needAnimation,
    this.needDublicateRemoval,
  });
}

class MovementDetails {
  List<BlockModel> blocks;
  bool needAnimation;
  bool needDublicateRemoval;
  MovementDetails({
    required this.blocks,
    required this.needAnimation,
    required this.needDublicateRemoval,
  });
}
