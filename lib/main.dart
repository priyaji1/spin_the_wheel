import 'package:flutter/material.dart';
import 'package:spin_game/ui/spin_wheel_game.dart';
import 'package:spin_game/util/app_constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.spinngWheelGame,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpinWheelScreen(),
    );
  }
}
