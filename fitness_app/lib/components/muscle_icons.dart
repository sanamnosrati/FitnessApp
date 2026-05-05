import 'package:flutter/material.dart';

class MuscleIcons {
  static CustomPainter getIcon(String muscleGroup) {
    switch (muscleGroup.toLowerCase()) {
      case 'upper body':
        return UpperBodyPainter();
      case 'core':
        return CorePainter();
      case 'lower body':
        return LowerBodyPainter();
      default:
        return FullBodyPainter();
    }
  }
}

class UpperBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw shoulders
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.25),
        width: size.width * 0.7,
        height: size.height * 0.2,
      ),
      3.14159,
      3.14159,
      false,
      paint,
    );

    // Draw chest muscles
    final leftPec = Path()
      ..moveTo(size.width * 0.35, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.4,
        size.width * 0.5,
        size.height * 0.45,
      );
    
    final rightPec = Path()
      ..moveTo(size.width * 0.65, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.4,
        size.width * 0.5,
        size.height * 0.45,
      );

    // Draw arms
    final leftArm = Path()
      ..moveTo(size.width * 0.15, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.1,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.7,
      );

    final rightArm = Path()
      ..moveTo(size.width * 0.85, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.5,
        size.width * 0.8,
        size.height * 0.7,
      );

    canvas.drawPath(leftPec, paint);
    canvas.drawPath(rightPec, paint);
    canvas.drawPath(leftArm, paint);
    canvas.drawPath(rightArm, paint);

    // Draw deltoids
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * 0.25),
        width: size.width * 0.2,
        height: size.height * 0.2,
      ),
      -0.5,
      -2.5,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.25),
        width: size.width * 0.2,
        height: size.height * 0.2,
      ),
      -2.5,
      2.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CorePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw upper abs
    _drawAbSection(canvas, size, 0.25, paint);
    
    // Draw middle abs
    _drawAbSection(canvas, size, 0.45, paint);
    
    // Draw lower abs
    _drawAbSection(canvas, size, 0.65, paint);

    // Draw obliques
    final leftOblique = Path()
      ..moveTo(size.width * 0.3, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.25,
        size.height * 0.8,
      );

    final rightOblique = Path()
      ..moveTo(size.width * 0.7, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.5,
        size.width * 0.75,
        size.height * 0.8,
      );

    canvas.drawPath(leftOblique, paint);
    canvas.drawPath(rightOblique, paint);
  }

  void _drawAbSection(Canvas canvas, Size size, double heightPercent, Paint paint) {
    // Left ab
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.4, size.height * heightPercent),
          width: size.width * 0.15,
          height: size.height * 0.15,
        ),
        const Radius.circular(5),
      ),
      paint,
    );

    // Right ab
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.6, size.height * heightPercent),
          width: size.width * 0.15,
          height: size.height * 0.15,
        ),
        const Radius.circular(5),
      ),
      paint,
    );

    // Center line
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * (heightPercent - 0.075)),
      Offset(size.width * 0.5, size.height * (heightPercent + 0.075)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LowerBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw quads
    _drawQuad(canvas, size, true, paint);  // Left quad
    _drawQuad(canvas, size, false, paint); // Right quad

    // Draw calves
    _drawCalf(canvas, size, true, paint);  // Left calf
    _drawCalf(canvas, size, false, paint); // Right calf

    // Draw knee details
    _drawKnee(canvas, size, true, paint);  // Left knee
    _drawKnee(canvas, size, false, paint); // Right knee
  }

  void _drawQuad(Canvas canvas, Size size, bool isLeft, Paint paint) {
    final x = isLeft ? size.width * 0.35 : size.width * 0.65;
    final controlX = isLeft ? size.width * 0.3 : size.width * 0.7;
    
    final quad = Path()
      ..moveTo(x, size.height * 0.2)
      ..quadraticBezierTo(
        controlX,
        size.height * 0.4,
        x,
        size.height * 0.5,
      );
    
    canvas.drawPath(quad, paint);
  }

  void _drawCalf(Canvas canvas, Size size, bool isLeft, Paint paint) {
    final x = isLeft ? size.width * 0.35 : size.width * 0.65;
    final controlX = isLeft ? size.width * 0.3 : size.width * 0.7;
    
    final calf = Path()
      ..moveTo(x, size.height * 0.5)
      ..quadraticBezierTo(
        controlX,
        size.height * 0.7,
        x,
        size.height * 0.9,
      );
    
    canvas.drawPath(calf, paint);
  }

  void _drawKnee(Canvas canvas, Size size, bool isLeft, Paint paint) {
    final x = isLeft ? size.width * 0.35 : size.width * 0.65;
    
    canvas.drawCircle(
      Offset(x, size.height * 0.5),
      size.width * 0.05,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FullBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.15),
        width: size.width * 0.2,
        height: size.height * 0.15,
      ),
      paint,
    );

    // Draw neck
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.22),
      Offset(size.width * 0.5, size.height * 0.28),
      paint,
    );

    // Draw torso
    final torso = Path()
      ..moveTo(size.width * 0.35, size.height * 0.28)
      ..lineTo(size.width * 0.65, size.height * 0.28)
      ..moveTo(size.width * 0.5, size.height * 0.28)
      ..lineTo(size.width * 0.5, size.height * 0.55)
      ..moveTo(size.width * 0.35, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.45,
        size.width * 0.4,
        size.height * 0.55,
      )
      ..moveTo(size.width * 0.65, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.45,
        size.width * 0.6,
        size.height * 0.55,
      );

    // Draw legs
    final legs = Path()
      ..moveTo(size.width * 0.4, size.height * 0.55)
      ..lineTo(size.width * 0.35, size.height * 0.9)
      ..moveTo(size.width * 0.6, size.height * 0.55)
      ..lineTo(size.width * 0.65, size.height * 0.9);

    // Draw arms
    final arms = Path()
      ..moveTo(size.width * 0.35, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.4,
        size.width * 0.25,
        size.height * 0.5,
      )
      ..moveTo(size.width * 0.65, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.4,
        size.width * 0.75,
        size.height * 0.5,
      );

    canvas.drawPath(torso, paint);
    canvas.drawPath(legs, paint);
    canvas.drawPath(arms, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 