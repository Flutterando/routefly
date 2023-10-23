import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// A widget for displaying the Routefly logo. It extends the
/// [ImplicitlyAnimatedWidget] to handle the implicit animations.
class RouteflyLogo extends ImplicitlyAnimatedWidget {
  /// The color of the logo. If null, the color
  /// is determined by the surrounding [IconTheme].
  final Color? color;

  /// The size of the logo. Defaults to 200.
  final double size;

  /// Constructs a RouteflyLogo widget.
  ///
  /// [curve], [duration], and [onEnd] are parameters
  /// that come from [ImplicitlyAnimatedWidget].
  /// [key] can be used to control the identity of the
  /// widget in the widget tree.
  /// [size] controls the size of the logo and defaults to 200 if not specified.
  /// [color] is an optional parameter to set the color of the logo.
  const RouteflyLogo({
    Key? key,
    Curve curve = Curves.linear,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onEnd,
    this.size = 200,
    this.color,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  @override
  ImplicitlyAnimatedWidgetState<RouteflyLogo> createState() {
    return _RouteflyLogoState();
  }
}

/// The state associated with the [RouteflyLogo] widget,
/// responsible for handling the animations.
class _RouteflyLogoState extends ImplicitlyAnimatedWidgetState<RouteflyLogo> {
  /// The tween defining the size animation.
  Tween<double>? _scale;

  /// The animation object associated with the size.
  late Animation<double> _sizeAnimation;

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
    final color = widget.color ?? Theme.of(context).iconTheme.color!;

    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return SvgPicture(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          width: _sizeAnimation.value,
          const AssetBytesLoader('assets/logo_text.svg.vec', packageName: 'routefly'),
        );
      },
    );
  }
}
