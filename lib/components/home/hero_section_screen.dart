import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HeroSectionScreen extends StatefulWidget {
  final VoidCallback? onExploreServices;
  final VoidCallback? onPlanAhead;

  const HeroSectionScreen({
    super.key,
    this.onExploreServices,
    this.onPlanAhead,
  });

  @override
  State<HeroSectionScreen> createState() => _HeroSectionScreenState();
}

class _HeroSectionScreenState extends State<HeroSectionScreen> {
  final ScrollController _scrollController = ScrollController();
  double scrollY = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollY = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          // --- Background Image with Parallax Effect ---
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, scrollY * 0.4),
              child: Image.asset(
                'assets/images/gate.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- Dark overlay for readability ---
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),

          // --- Glowing Green Gradient Overlay ---
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0x8800FF9C),
                    Color(0x5500B86B),
                    Color(0x330B0B0D),
                    Color(0xFF000000),
                  ],
                  center: Alignment(0.0, -0.3),
                  radius: 1.2,
                ),
              ),
            ),
          ),

          // --- Main Text and Buttons ---
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.1,
                vertical: height * 0.15,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A Place of Peace,\nMemory, and Legacy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: width > 1400
                            ? 60
                            : width > 1000
                                ? 50
                                : 42,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1.seconds)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 25),

                    Text(
                      'Honoring lives with dignity and compassion\nin a serene sanctuary of remembrance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width > 1400
                            ? 22
                            : width > 1000
                                ? 20
                                : 18,
                        height: 1.6,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1.seconds, delay: 0.3.seconds)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 50),

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF9C),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: widget.onExploreServices,
                          child: const Text(
                            'Explore Services',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Color(0xFF00FF9C), width: 1.5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: widget.onPlanAhead,
                          child: const Text(
                            'Plan Ahead',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 1.seconds, delay: 0.6.seconds)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ),
          ),

          // --- Scroll Indicator ---
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF00FF9C),
                size: 48,
              )
                  .animate(onPlay: (c) => c.repeat())
                  .moveY(begin: 0, end: 12, duration: 2.seconds)
                  .fadeIn(duration: 1.seconds, delay: 1.seconds),
            ),
          ),
        ],
      ),
    );
  }
}
