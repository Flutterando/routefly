import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class RouteflyLogo extends ImplicitlyAnimatedWidget {
  final Color color;
  final double size;
  const RouteflyLogo({
    super.curve,
    super.duration = const Duration(milliseconds: 500),
    super.onEnd,
    super.key,
    this.size = 200,
    this.color = Colors.black,
  });

  @override
  ImplicitlyAnimatedWidgetState<RouteflyLogo> createState() {
    return _RouteflyLogoState();
  }
}

class _RouteflyLogoState extends ImplicitlyAnimatedWidgetState<RouteflyLogo> {
  Tween<double>? _scale;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _scale = visitor(_scale, widget.size, (dynamic value) {
      return Tween<double>(begin: value as double);
    }) as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _sizeAnimation = animation.drive(_scale!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return SvgPicture(
          colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
          width: _sizeAnimation.value,
          const AssetBytesLoader('assets/logo_text.svg.vec', packageName: 'routefly'),
        );
      },
    );
  }
}
