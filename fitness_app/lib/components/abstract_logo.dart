import 'package:flutter/material.dart';
import 'dart:math' as math;

class AbstractLogo extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const AbstractLogo({
    Key? key,
    this.size = 200,
    this.primaryColor = const Color(0xFFFFD700), // Gold
    this.secondaryColor = const Color(0xFF1E90FF), // Dodger Blue
  }) : super(key: key);

  @override
  State<AbstractLogo> createState() => _AbstractLogoState();
}

class _AbstractLogoState extends State<AbstractLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi / 4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _AbstractLogoPainter(
                primaryColor: widget.primaryColor,
                secondaryColor: widget.secondaryColor,
                animation: _controller.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AbstractLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double animation;

  _AbstractLogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Gradient für den äußeren Ring
    final outerGradient = SweepGradient(
      colors: [
        primaryColor.withOpacity(0.8),
        secondaryColor.withOpacity(0.8),
        primaryColor.withOpacity(0.8),
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(animation * math.pi * 2),
    );

    // Äußerer Ring
    final outerPaint = Paint()
      ..shader = outerGradient.createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    // Innerer Ring mit gegenläufiger Animation
    final innerPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          secondaryColor.withOpacity(0.6),
          primaryColor.withOpacity(0.6),
          secondaryColor.withOpacity(0.6),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(-animation * math.pi * 2),
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius * 0.7,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    // Dynamische Punkte
    final pointPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Zeichne die Ringe
    canvas.drawCircle(center, radius, outerPaint);
    canvas.drawCircle(center, radius * 0.7, innerPaint);

    // Zeichne dynamische Punkte
    for (var i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi + animation * math.pi * 2;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      canvas.drawCircle(
        Offset(x, y),
        size.width * 0.03 * (1 + math.sin(animation * math.pi * 2) * 0.3),
        pointPaint,
      );
    }

    // Zeichne das "B" in der Mitte
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'B',
        style: TextStyle(
          fontSize: size.width * 0.4,
          fontWeight: FontWeight.bold,
          color: primaryColor.withOpacity(0.8),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _AbstractLogoPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
} 