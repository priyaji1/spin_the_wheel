
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spin_game/spin_wheel_cubit/spin_wheel_state.dart';
import 'package:spin_game/util/utils.dart';


class SpinWheelCubit extends Cubit<SpinWheelState> {

  SpinWheelCubit() : super(const SpinWheelState());

  void setSpinData(int spinIndex) {
    emit(state.copyWith(spinItemsValue: spinItems[spinIndex]));
  }
  void wheelSelected(bool isSelected){
    emit(state.copyWith(isSelected: isSelected));
  }
}