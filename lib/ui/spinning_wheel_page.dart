import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spin_game/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:spin_game/spin_wheel_cubit/spin_wheel_state.dart';
import '../util/app_constant.dart';
import '../util/common_widget.dart';
import '../util/utils.dart';
import 'my_spinner.dart';
import 'success_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class SpinningWheelPage extends StatefulWidget  {
  const SpinningWheelPage({super.key});

  @override
  SpinningWheelPageState createState() => SpinningWheelPageState();
}

class SpinningWheelPageState extends State<SpinningWheelPage> with TickerProviderStateMixin {
  late final AnimationController _defaultLottieController;
  final MySpinController mySpinController = MySpinController();

  @override
  void initState() {
    super.initState();
    _defaultLottieController = AnimationController(vsync: this)
      ..duration = const Duration(seconds: 3);
  }

  @override
  void dispose() {
    _defaultLottieController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
   return BlocConsumer<SpinWheelCubit, SpinWheelState>(
     listener: (context1,state)=>_spinListener(context1,state),
     builder: (context1, state) =>
         Column(
           children: [
             const SizedBox(height: 24),
             MySpinner(
               mySpinController: mySpinController,
               wheelSize: kIsWeb
                   ? MediaQuery.of(context).size.width * 0.3
                   : MediaQuery.of(context).size.width * 0.8,
               itemList: spinItems,
             ),
             const SizedBox(height: 24),
            elevatedButton(onPressed: () async {
            int rdm = Random().nextInt(6);
            await mySpinController.spinNow(luckyIndex: rdm + 1, totalSpin: 10, baseSpinDuration: 20,context: context1);
            }, text: AppConstants.spinNow,spinButtonKey: ValueKey(AppConstants.spinButtonKey))
           ],
         ),

   );

  }
  void _spinListener(BuildContext context, SpinWheelState state) {
    print("#######${state.isSelected}");
    if (state.isSelected) {
      if(state.spinItemsValue!=null){
        _showPrizeDialog(context, state);
        _playLottie();
      }
    }
  }

  void _showPrizeDialog(BuildContext context,state) {
    showDialog(
      context: context,
      builder: (_) => Stack(
        children: [
          Center(
            child: SizedBox(
              width: 500,
              child: PrizeDialog(  prize: state.spinItemsValue,),
            ),
          ),
          ...buildLotties(context,_defaultLottieController),
        ],
      ),
    );
  }

  void _playLottie() {
    _defaultLottieController.forward().then((value) => _defaultLottieController.reset());
  }
}





