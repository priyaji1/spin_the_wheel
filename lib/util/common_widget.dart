
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'app_constant.dart';
import 'assets.dart';

List<Widget> buildLotties(context,defaultLottieController) {
  return [
    Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: IgnorePointer(
          child: Lottie.asset(
            defaultLottie,
            controller: defaultLottieController,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        ),
      ),
    ),
  ];
}

Widget elevatedButton({
  required final void Function() onPressed,
  required String text,
  required Key spinButtonKey,
}) {
  return  ElevatedButton(
    key:  spinButtonKey,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
  );
}


