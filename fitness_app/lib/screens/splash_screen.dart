import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _flameAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _flameAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Animated Flames Background
          AnimatedBuilder(
            animation: _flameAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                painter: FlamesPainter(progress: _flameAnimation.value),
              );
            },
          ),
          // Logo and Content
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Custom Logo with Dumbbell
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryColor,
                                    Color(0xFFFFA000),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                            // Custom Dumbbell Icon
                            CustomPaint(
                              size: const Size(120, 60),
                              painter: DumbbellPainter(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // BFit Text with Custom Styling
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            Color(0xFFFFA000),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'BFit',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 64,
                            letterSpacing: 2,
                            shadows: [
                              const Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Dein Weg zu mehr Fitness',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Dumbbell Icon
class DumbbellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw the bar
    canvas.drawLine(
      Offset(size.width * 0.2, size.height / 2),
      Offset(size.width * 0.8, size.height / 2),
      paint,
    );

    // Draw the weights
    final leftWeight = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.2, size.height / 2),
          width: 20,
          height: 40,
        ),
        const Radius.circular(5),
      ));

    final rightWeight = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.8, size.height / 2),
          width: 20,
          height: 40,
        ),
        const Radius.circular(5),
      ));

    canvas.drawPath(leftWeight, paint);
    canvas.drawPath(rightWeight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for the Flames Background
class FlamesPainter extends CustomPainter {
  final double progress;

  FlamesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          AppTheme.primaryColor.withOpacity(0.3 * progress),
          const Color(0xFFFFA000).withOpacity(0.2 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    
    // Create flame effect
    for (var i = 0; i < 5; i++) {
      final xOffset = size.width * (0.2 + (0.15 * i));
      final height = size.height * (0.6 + (0.1 * (i % 2)));
      
      path.moveTo(xOffset, size.height);
      path.quadraticBezierTo(
        xOffset - 40,
        size.height - height * 0.3,
        xOffset,
        size.height - height * progress,
      );
      path.quadraticBezierTo(
        xOffset + 40,
        size.height - height * 0.3,
        xOffset,
        size.height,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FlamesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 