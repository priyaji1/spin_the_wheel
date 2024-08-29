import 'package:flutter/material.dart';
import 'package:spin_game/util/app_constant.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../model/SpinItem.dart';
import '../util/assets.dart';

class PrizeDialog extends StatefulWidget {
  final SpinItem? prize;
  const PrizeDialog({ required this.prize,super.key});

  @override
  State<PrizeDialog> createState() => _PrizeDialogState();
}

class _PrizeDialogState extends State<PrizeDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 15.0),
          borderRadius: BorderRadius.circular(45),
          color: widget.prize?.color
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(congratsText),
            const SizedBox(height: 16),
             Center(
              child: Text(
                  '${AppConstants.luckeyText} ${widget.prize?.label}', style: const TextStyle(fontSize: 18,color: Colors.black)
              ),
            ),
            const SizedBox(height: 16),
            MouseRegion(
              cursor: _isHovered ? SystemMouseCursors.click : SystemMouseCursors.basic,
              onHover: (event) => setState(() => _isHovered = true),
              onExit: (event) => setState(() => _isHovered = false),
              child: ZoomTapAnimation(
                key: const ValueKey(AppConstants.okButton),
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  okButton,
                  width: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}