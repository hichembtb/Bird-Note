import 'package:flutter/cupertino.dart';

class SlideRight extends PageRouteBuilder {
  final Page;
  SlideRight({this.Page})
      : super(
          pageBuilder: (context, animation, animationtwo) => Page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, animationtwo, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class SlideLeft extends PageRouteBuilder {
  final Page;
  SlideLeft({this.Page})
      : super(
          pageBuilder: (context, animation, animationtwo) => Page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, animationtwo, child) {
            var begin = const Offset(-1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class AlignAnimation extends PageRouteBuilder {
  final Page;
  AlignAnimation({this.Page})
      : super(
          pageBuilder: (context, animation, animationtwo) => Page,
          transitionsBuilder: (context, animation, animationtwo, child) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            );
          },
        );
}

class AlignAnimationLog extends PageRouteBuilder {
  final Page;
  AlignAnimationLog({this.Page})
      : super(
          pageBuilder: (context, animation, animationtwo) => Page,
          transitionsBuilder: (context, animation, animationtwo, child) {
            return Align(
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            );
          },
        );
}

class FadeAnimation extends PageRouteBuilder {
  final Page;
  FadeAnimation({this.Page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, animationtwo) => Page,
          transitionsBuilder: (context, animation, animationtwo, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
