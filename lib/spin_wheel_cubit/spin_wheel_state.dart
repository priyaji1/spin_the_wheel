import 'package:equatable/equatable.dart';
import '../model/SpinItem.dart';

class SpinWheelState extends Equatable {
  final bool isSelected;
  final SpinItem? spinItemsValue;

  const SpinWheelState({
    this.spinItemsValue,
    this.isSelected=false,
  });

  SpinWheelState copyWith({
    bool? isSpinning,
    SpinItem? spinItemsValue,
    bool? isSelected,
  }) {
    return SpinWheelState(
      spinItemsValue: spinItemsValue ?? this.spinItemsValue,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
        spinItemsValue,
    isSelected
      ];
}