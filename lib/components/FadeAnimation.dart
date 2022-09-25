// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';
import 'package:simple_animations/timeline_tween/timeline_tween.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = TimelineTween<AniProps>()..addScene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 500))
             .animate(AniProps.opacity, tween: Tween(begin: 0.0, end: 1.0))
             ..addScene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut)
          .animate(AniProps.translateY, tween: Tween(begin: -30.0, end: 0.0));

    return PlayAnimation<TimelineValue<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, animation.get(AniProps.translateY)),
            child: child),
      ),
    );
  }
}
