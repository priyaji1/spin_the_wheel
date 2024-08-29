import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spin_game/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'spinning_wheel_page.dart';
import '../util/assets.dart';

const horizontalPaddingValue = 16.0;

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpinWheelCubit>(
      create: (context)=>SpinWheelCubit(),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPaddingValue),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24),
                  SpinningWheelPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
