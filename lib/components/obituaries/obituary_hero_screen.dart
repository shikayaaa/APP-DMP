import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ObituaryHero extends StatefulWidget {
  const ObituaryHero({super.key});

  @override
  State<ObituaryHero> createState() => _ObituaryHeroState();
}

class _ObituaryHeroState extends State<ObituaryHero> {
  double scrollY = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          setState(() {
            scrollY = notification.metrics.pixels;
          });
        }
        return true;
      },
      child: Stack(
        children: [
          // Background image with parallax
          Transform.translate(
            offset: Offset(0, scrollY * 0.3),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1495954484750-af469f2f9be5?w=1920&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ Updated gradient overlay with your teal/green theme
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xCC12BA99), // Your teal color with transparency
                  Color(0xB310A888), // Slightly darker teal
                  Color(0xE60E9677), // Even darker for depth
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Text content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'Honoring the Lives of\nOur Loved Ones',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms, delay: 300.ms)
                        .moveY(begin: 30, end: 0, curve: Curves.easeOut),

                    const SizedBox(height: 20),

                    // Subtitle
                    Text(
                      'Find and remember those who rest in our care',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms, delay: 500.ms)
                        .moveY(begin: 30, end: 0, curve: Curves.easeOut),
                  ],
                ),
              ),
            ),
          ),

          // Curved bottom divider (SVG shape replicated in Flutter Path)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _BottomCurvePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 100);
    path.quadraticBezierTo(size.width * 0.1, 80, size.width * 0.25, 70);
    path.quadraticBezierTo(size.width * 0.5, 60, size.width * 0.75, 65);
    path.quadraticBezierTo(size.width * 0.9, 80, size.width, 90);
    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..color = const Color(0xFFFAFAF9)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}