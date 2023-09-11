import 'package:flutter/cupertino.dart';

class AnimatedStopIcon extends StatefulWidget {
  const AnimatedStopIcon({super.key, this.isAnimating = false});
  final bool isAnimating;

  @override
  State<AnimatedStopIcon> createState() => _AnimatedStopIconState();
}

class _AnimatedStopIconState extends State<AnimatedStopIcon>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation =
        ColorTween(begin: CupertinoColors.black, end: CupertinoColors.systemRed)
            .animate(controller)
          ..addListener(_listener);
  }

  @override
  void dispose() {
    animation.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (widget.isAnimating) {
      controller.repeat(reverse: true);
    } else {
      controller
        ..stop()
        ..reset();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedStopIcon oldWidget) {
    _toggleAnimation();
    super.didUpdateWidget(oldWidget);
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      CupertinoIcons.stop,
      color: animation.value,
    );
  }
}
