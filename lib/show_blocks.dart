// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:game_2048/block_model.dart';
import 'package:game_2048/block_widget.dart';
import 'package:game_2048/game_configs.dart';
import 'package:provider/provider.dart';

import 'movement_provider.dart';

class ShowBlocks extends StatelessWidget {
  const ShowBlocks({super.key});

  @override
  Widget build(BuildContext context) {
    const double totalHeight = 390;
    const double totalWidth = 400;
    return Scaffold(
      appBar: AppBar(
          // actions: [
          //   InkWell(
          //     onTap: () {
          //       Provider.of<MovementProvider>(context, listen: false).resetGame();
          //     },
          //     child: const Center(child: Icon(Icons.restore)),
          //   )
          // ],
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(width: 0),
              ScoreWidget(),
              SizedBox(width: 20),
              ResetButton(),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: totalHeight,
              width: totalWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 187, 173, 160),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GameFrame(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<MovementProvider>(context, listen: false);
    return InkWell(
      onTap: () => mp.resetGame(),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 205, 193, 180),
        ),
        child: const Center(
          child: Text(
            'Reset',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<MovementProvider>(context);
    return Container(
      height: 100,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 205, 193, 180),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Score',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          // const SizedBox(height: 0),
          Text(
            mp.score.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class GameFrame extends StatefulWidget {
  const GameFrame({super.key});

  @override
  State<GameFrame> createState() => _GameFrameState();
}

class _GameFrameState extends State<GameFrame> with TickerProviderStateMixin {
  late Animation<double> aniProporties;
  late AnimationController aniController;

  @override
  void initState() {
    super.initState();
    aniController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    aniProporties = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: aniController, curve: Curves.linear),
    );
    aniController.addListener(() {
      if (aniController.isCompleted) {
        final mp = Provider.of<MovementProvider>(context, listen: false);
        mp.removeDublicates();
        // if there are 16 blocks then game ends.
        mp.checkGameEnd();
        // add one extra block
        mp.addExtraBlock();
        // calculate score
        mp.calculateScore();
        // BlockUtils.printMovementSummary(mp.direction, mp.blocks);
      }
    });
    // aniController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var result = Provider.of<MovementProvider>(context).shouldAnimate;
    if (result == true) {
      if (aniController.isCompleted) {
        aniController.reset();
        aniController.forward();
      } else {
        aniController.forward();
      }
    }
  }

  double getTopLoc(BlockModel block, double animationVal) {
    double y = block.y ?? 0;
    double y_past = block.y_last ?? y;
    // if we did not move we dont need to use animationVal
    if (y == y_past) {
      return y;
    }
    return (y_past + (y - y_past) * animationVal);
  }

  double getLeftLoc(BlockModel block, double animationVal) {
    double x = block.x ?? 0;
    double x_past = block.x_last ?? x;
    // if we did not move we dont need to use animationVal
    if (x == x_past) {
      return x;
    }
    return (x_past + (x - x_past) * animationVal);
  }

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<MovementProvider>(context);
    return AnimatedBuilder(
      animation: aniProporties,
      // child: const BackGround(),
      builder: (_, child) {
        return Stack(
          children: [
            for (List<double> loc in allPossibleLocations)
              Positioned(
                top: loc.last,
                left: loc.first,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 205, 193, 180),
                  ),
                ),
              ),
            for (BlockModel block in mp.blocks)
              Positioned(
                top: getTopLoc(block, aniProporties.value),
                left: getLeftLoc(block, aniProporties.value),
                child: BlockWidget(value: block.value!),
              ),
          ],
        );
      },
    );
  }
}

// class BackGround extends StatelessWidget {
//   const BackGround({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: 16,
//       itemBuilder: (context, index) {
//         return Container(
//           height: 80,
//           width: 80,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: const Color.fromARGB(255, 205, 193, 180),
//           ),
//         );
//       },
//     );
//   }
// }


