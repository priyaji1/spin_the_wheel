import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spin_game/main.dart';
import 'package:spin_game/spin_wheel_cubit/spin_wheel_cubit.dart';
import '../util/assets.dart';
import '../model/SpinItem.dart';


class MySpinner extends StatefulWidget {
  final MySpinController mySpinController;
  final List<SpinItem> itemList;
  final double wheelSize;
  const MySpinner({
    super.key,
    required this.mySpinController,
    required this.itemList,
    required this.wheelSize,
  });

  @override
  State<MySpinner> createState() => _MySpinnerState();
}

class _MySpinnerState extends State<MySpinner> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    widget.mySpinController.initLoad(
      tickerProvider: this,
      itemList: widget.itemList,
    );

  }

  @override
  void dispose() {
    super.dispose();
    null;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      //alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: widget.mySpinController._baseAnimation,
            builder: (context, child) {
              double value = widget.mySpinController._baseAnimation.value;
              double rotationValue = (360 * value);
              return RotationTransition(
                turns: AlwaysStoppedAnimation( rotationValue / 360 ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                          width: widget.wheelSize,
                          height: widget.wheelSize,
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),

                            padding: const EdgeInsets.all(5),
                            child: CustomPaint(
                              painter: SpinWheelPainter(
                                  items: widget.itemList

                              ),
                            ),
                          )
                      ),
                    ),
                    ...widget.itemList.map((each) {
                      int index = widget.itemList.indexOf(each);
                      double rotateInterval = 360 / widget.itemList.length;
                      double rotateAmount = (index + 0.5) * rotateInterval;
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(rotateAmount/360),
                        child: Transform.translate(
                          offset: Offset(0,-widget.wheelSize/4),
                          child: RotatedBox(
                            quarterTurns: 8,

                            child: Text(each.label,style: each.labelStyle),
                          ),
                        ),
                      );
                    }),
                    Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(0),
            child:
            Image.asset(
              spinningPointer,
              width: 50,
              height: 50,
            ),
        ),
      ],
    );
  }
}

class MySpinController{

   late AnimationController _baseAnimation;
  late TickerProvider _tickerProvider;
  bool _xSpinning = false;
  List<SpinItem> _itemList = [];

  Future<void> initLoad({
    required TickerProvider tickerProvider,
    required List<SpinItem> itemList,
  }) async{
    _tickerProvider = tickerProvider;
    _itemList = itemList;
    await setAnimations(_tickerProvider);
  }

  Future<void> setAnimations(TickerProvider tickerProvider) async{
    _baseAnimation = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<void> spinNow({
    required int luckyIndex,
    int totalSpin = 10,
    int baseSpinDuration = 100,
    required BuildContext context,
  }) async{

    //getWhereToStop
    int itemsLength = _itemList.length; //the number of items (segments) on the wheel
    int factor = luckyIndex % itemsLength;//This calculates the index where the wheel should stop
    if(factor == 0) factor = itemsLength; //If the factor is 0, it's set to itemsLength to avoid indexing issues.
    double spinInterval = 1 / itemsLength; //calculates the portion of the spin animation
    double target = 1 - ( (spinInterval * factor) - (spinInterval/2)); //This calculates the exact point in the animation where the wheel should stop to land on the segment determined by luckyIndex
    if(!_xSpinning){ //Check if the Wheel is Already Spinning
      _xSpinning = true;
      int spinCount = 0;
      do{
        _baseAnimation.reset(); //Resets the animation controller to the starting point
        _baseAnimation.duration = Duration(milliseconds: baseSpinDuration);
        if(spinCount == totalSpin){ //wheel will spin for a number of iterations the last spin iteration
          await _baseAnimation.animateTo(target); //Spins the wheel to the exact position (i.e., the target) where it should stop.
          var spinIndex=  _itemList.indexWhere((element) => element.label == luckyIndex.toString());
          context.read<SpinWheelCubit>().setSpinData(spinIndex);
          context.read<SpinWheelCubit>().wheelSelected(true);
        }
        else{
          await _baseAnimation.forward();
        }

        baseSpinDuration = baseSpinDuration + 50;  //Increases the duration of the next spin, making the wheel slow down over time.
        _baseAnimation.duration = Duration(milliseconds: baseSpinDuration);

        spinCount++;
      }
      while(spinCount <= totalSpin);
      _xSpinning = false; //End of Spinning allowing a new spin to start if triggered.
      context.read<SpinWheelCubit>().wheelSelected(false);
    }
  }

}

class SpinWheelPainter extends CustomPainter {
  final List<SpinItem> items;

  SpinWheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25) // Adjust the shadow color and opacity as needed
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0); // Adjust the blur radius as needed

    const spaceBetweenItems = 0.05; // Adjust this value to set the desired space between items
    final totalSections = items.length;
    const totalAngle = 2 * math.pi;
    final sectionAngleWithSpace = (totalAngle - (totalSections * spaceBetweenItems)) / totalSections;
    const spaceOnBothSides = spaceBetweenItems / 2;

    for (var i = 0; i < items.length; i++) {
      final startAngle = i * (sectionAngleWithSpace + spaceBetweenItems) + spaceOnBothSides;

      paint.color = items[i].color;

      // Draw shadow before drawing the arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        shadowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        paint,
      );
    }

    // Draw a circle at the center of the wheel
    final centerCircleRadius = radius * 0.05; // Adjust the radius of the center circle as needed
    final centerCirclePaint = Paint()..color = Colors.white; // Adjust the color of the center circle as needed
    canvas.drawCircle(center, centerCircleRadius, centerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}