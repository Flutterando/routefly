import 'dart:math';

import 'package:flutter/material.dart';

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
    this.size = 80,
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
        return _LogoText(
          color: color,
          width: _sizeAnimation.value,
          height: _sizeAnimation.value * 0.27,
          lineWidth: _sizeAnimation.value * 0.01,
          scaleFactor: 1.7,
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  /// Creates a widget that paints the Routefly logo. 
  const _Logo({
    this.size = 100.0,
    this.color = const Color(0xFFFFFFFF),
    this.lineWidth = 0.0,
  });

  /// The size of the logo in logical pixels.
  final double size;
  final Color color;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    late double lW2;
    lineWidth == 0.0 ? lW2 = size * 0.01 : lW2 = lineWidth;

    return CustomPaint(
      size: Size(size, size),
      painter: _Butterfly(color: color, lineWidthBorder: lW2),
    );
  }
}

class _Butterfly extends CustomPainter {
  final Color color;
  final double lineWidthBorder;

  _Butterfly({
    required this.color,
    required this.lineWidthBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sizeLogo = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = lineWidthBorder;

    // Asa esquerda    
    const startAngle = pi / 2;
    const sweepAngle = 163 * pi / 180;
    const useCenter = false;
    final rect = Rect.fromLTRB(
      sizeLogo * 0.1339,
      sizeLogo * 0.634,
      sizeLogo * 0.4011,
      sizeLogo,
    );
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

    const startAngle1 = 181 * pi / 180;
    const sweepAngle1 = 38 * pi / 45;
    const useCenter1 = false;
    final rect2 = Rect.fromLTRB(
      sizeLogo * 0.1888,
      sizeLogo * 0.0,
      sizeLogo * 0.581,
      sizeLogo * 0.4911,
    );
    canvas.drawArc(rect2, startAngle1, sweepAngle1, useCenter1, paint);

    final path = Path()
      ..moveTo(sizeLogo * 0.2283, sizeLogo * 0.642)
      ..conicTo(
        sizeLogo * 0.308,
        sizeLogo * 0.6036,
        sizeLogo * 0.4298,
        sizeLogo * 0.661,
        1,
      )

      ..conicTo(
        sizeLogo * 0.20,
        sizeLogo * 0.5,
        sizeLogo * 0.1888,
        sizeLogo * 0.24,
        1,
      )

      ..moveTo(sizeLogo * 0.559, sizeLogo * 0.133)
      ..conicTo(
        sizeLogo * 0.5916,
        sizeLogo * 0.2,
        sizeLogo * 0.5996,
        sizeLogo * 0.371,
        1,
      )

      ..conicTo(
        sizeLogo * 0.6,
        sizeLogo * 0.55,
        sizeLogo * 0.5261,
        sizeLogo * 0.7293,
        1,
      )

      ..conicTo(
        sizeLogo * 0.42,
        sizeLogo,
        sizeLogo * 0.2652,
        sizeLogo,
        1,
      )

      //Asa direita

      ..moveTo(sizeLogo * 0.5361, sizeLogo * 0.9667)
      ..conicTo(
        sizeLogo * 0.495,
        sizeLogo * 0.9517,
        sizeLogo * 0.4873,
        sizeLogo * 0.8952,
        1,
      )

      ..conicTo(
        sizeLogo * 0.48,
        sizeLogo * 0.855,
        sizeLogo * 0.5361,
        sizeLogo * 0.704,
        1,
      )

      ..conicTo(
        sizeLogo * 0.6065,
        sizeLogo * 0.5006,
        sizeLogo * 0.781,
        sizeLogo * 0.3037,
        1,
      )

      ..conicTo(
        sizeLogo * 0.818,
        sizeLogo * 0.265,
        sizeLogo * 0.845,
        sizeLogo * 0.279,
        1,
      )

      ..conicTo(
        sizeLogo * 0.86,
        sizeLogo * 0.286,
        sizeLogo * 0.8661,
        sizeLogo * 0.332,
        1,
      )

      ..conicTo(
        sizeLogo * 0.88,
        sizeLogo * 0.5,
        sizeLogo * 0.68,
        sizeLogo * 0.6868,
        1,
      )

      ..conicTo(
        sizeLogo * 0.68,
        sizeLogo * 0.8,
        sizeLogo * 0.63,
        sizeLogo * 0.8866,
        1,
      )

      // parte 13
      ..conicTo(
        sizeLogo * 0.58,
        sizeLogo * 0.98,
        sizeLogo * 0.5361,
        sizeLogo * 0.9667,
        1,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _Butterfly oldDelegate) {
    return oldDelegate.color != color //
        ||
        oldDelegate.lineWidthBorder != lineWidthBorder;
  }
}

class _LogoText extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double lineWidth;
  final double scaleFactor;
  const _LogoText({
    this.color = const Color(0xFFFFFFFF),
    this.width = 230.0,
    this.height = 54.0,
    this.lineWidth = 0.0,
    this.scaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    late final double logoLineWidth;
    if (lineWidth == 0.0) {
      logoLineWidth = 0.01 * height * scaleFactor;
    } else {
      logoLineWidth = lineWidth * scaleFactor;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _Logo(
          size: height * scaleFactor,
          lineWidth: logoLineWidth,
          color: color,
        ),
        SizedBox(width: 0.03 * width * scaleFactor),
        CustomPaint(
          size: Size(0.698 * width * scaleFactor, 0.54 * height * scaleFactor),
          painter: _BrandLogo(
            color: color,
            fontWeight: logoLineWidth,
          ),
        ),
        SizedBox(width: 0.05 * width * scaleFactor),
      ],
    );
  }
}

class _BrandLogo extends CustomPainter {
  final Color color;
  final double fontWeight;

  _BrandLogo({
    required this.color,
    required this.fontWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = fontWeight;

    final path = Path()
          //R
          ..moveTo(0, 0)
          ..lineTo(0, height)
          ..moveTo(0, 0)
          ..lineTo(0.05 * width, 0)
          ..conicTo(
            0.090 * width,
            0.018 * height,
            0.090 * width,
            0.266 * height,
            1,
          )
          ..conicTo(
            0.087 * width,
            0.506 * height,
            0.048 * width,
            0.525 * height,
            1,
          )
          ..lineTo(0, 0.525 * height)
          ..moveTo(0.048 * width, 0.528 * height)
          ..lineTo(0.099 * width, height)

          //O
          ..moveTo(0.182 * width, 0)
          ..conicTo(
            0.127 * width,
            0.018 * height,
            0.127 * width,
            0.5 * height,
            1,
          )
          ..conicTo(
            0.127 * width,
            0.980 * height,
            0.182 * width,
            height,
            1,
          )
          ..moveTo(0.182 * width, 0)
          ..conicTo(
            0.237 * width,
            0.018 * height,
            0.237 * width,
            0.500 * height,
            1,
          )
          ..conicTo(
            0.237 * width,
            0.980 * height,
            0.182 * width,
            height,
            1,
          )

          //U
          ..moveTo(0.265 * width, 0)
          ..lineTo(0.265 * width, 0.500 * height)
          ..conicTo(
            0.265 * width,
            height,
            0.314 * width,
            height,
            1,
          )
          ..moveTo(0.363 * width, 0)
          ..lineTo(0.363 * width, 0.500 * height)
          ..conicTo(
            0.363 * width,
            height,
            0.314 * width,
            height,
            1,
          )

          //T
          ..moveTo(0.446 * width, height)
          ..lineTo(0.446 * width, 0)
          ..moveTo(0.392 * width, 0)
          ..lineTo(0.503 * width, 0)

          //E
          ..moveTo(0.531 * width, height)
          ..lineTo(0.531 * width, 0)
          ..moveTo(0.531 * width, height)
          ..lineTo(0.626 * width, height)
          ..moveTo(0.531 * width, 0.5 * height)
          ..lineTo(0.612 * width, 0.5 * height)
          ..moveTo(0.531 * width, 0)
          ..lineTo(0.626 * width, 0)

          //F
          ..moveTo(0.654 * width, height)
          ..lineTo(0.654 * width, 0)
          ..moveTo(0.654 * width, 0.5 * height)
          ..lineTo(0.727 * width, 0.5 * height)
          ..moveTo(0.654 * width, 0)
          ..lineTo(0.741 * width, 0)

          //L
          ..moveTo(0.770 * width, height)
          ..lineTo(0.770 * width, 0)
          ..moveTo(0.770 * width, height)
          ..lineTo(0.860 * width, height)

          //Y
          ..moveTo(0.944 * width, height)
          ..lineTo(0.944 * width, 0.56 * height)
          ..moveTo(0.893 * width, 0.0 * height)
          ..lineTo(0.944 * width, 0.56 * height)
          ..moveTo(0.991 * width, 0)
          ..lineTo(0.944 * width, 0.56 * height)
        //
        ;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BrandLogo oldDelegate) {
    return oldDelegate.color != color //
        ||
        oldDelegate.fontWeight != fontWeight;
  }
}
