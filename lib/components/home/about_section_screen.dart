import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AboutSectionScreen extends StatefulWidget {
  const AboutSectionScreen({super.key});

  @override
  State<AboutSectionScreen> createState() => _AboutSectionScreenState();
}

class _AboutSectionScreenState extends State<AboutSectionScreen>
    with SingleTickerProviderStateMixin {
  bool inView = false;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => inView = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 💚 Background gradient
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF001F1B),
            Color(0xFF00382F),
            Color(0xFF005F4E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 800;

              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- LEFT SIDE IMAGE ---
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: isWide ? 40 : 0,
                        bottom: isWide ? 0 : 40,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                // ✅ Changed to use local asset image
                                Image.asset(
                                  'assets/images/office.jpg',
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                                // ✅ Retained gradient overlay
                                Container(
                                  width: double.infinity,
                                  height: 400,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xCC00382F),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate(target: inView ? 1 : 0)
                              .fadeIn(duration: 800.ms)
                              .slideX(begin: -0.2, end: 0),
                          Positioned(
                            bottom: -30,
                            right: -30,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00FF9C),
                                    Color(0xFF009E6D),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- RIGHT SIDE CONTENT ---
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "About Us" pill badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00FF9C),
                                Color(0xFF00B86B),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "About Us",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        )
                            .animate(target: inView ? 1 : 0)
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: 0.2, end: 0),

                        const SizedBox(height: 16),

                        // Heading
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                            children: [
                              const TextSpan(text: 'A Legacy of '),
                              TextSpan(
                                text: 'Compassion',
                                style: TextStyle(
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Color(0xFF00FF9C),
                                        Color(0xFF00B86B),
                                      ],
                                    ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 70)),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(target: inView ? 1 : 0)
                            .fadeIn(duration: 600.ms)
                            .then(delay: 200.ms)
                            .slideX(begin: 0.2, end: 0),

                        const SizedBox(height: 20),

                        // Paragraphs
                        const Text(
                          "Established in 1990, Dumaguete Memorial Park has been a sanctuary "
                          "of peace and remembrance for families in Negros Oriental. "
                          "Our beautifully landscaped grounds provide a serene environment "
                          "for honoring loved ones.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        )
                            .animate(target: inView ? 1 : 0)
                            .fadeIn(duration: 600.ms)
                            .then(delay: 300.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 12),

                        const Text(
                          "We understand that every family's needs are unique. "
                          "Our dedicated team is here to guide you through every step "
                          "with compassion, dignity, and respect, ensuring that each "
                          "memorial is as special as the life it celebrates.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        )
                            .animate(target: inView ? 1 : 0)
                            .fadeIn(duration: 600.ms)
                            .then(delay: 400.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 28),

                        // --- Features ---
                        Column(
                          children: [
                            _buildFeature(
                              icon: LucideIcons.heart,
                              title: "Compassionate Care",
                              description:
                                  "Dedicated staff providing support during difficult times",
                              delay: 500.ms,
                            ),
                            _buildFeature(
                              icon: LucideIcons.award,
                              title: "Established Excellence",
                              description:
                                  "Over 30 years of trusted service to the community",
                              delay: 600.ms,
                            ),
                            _buildFeature(
                              icon: LucideIcons.clock,
                              title: "Always Available",
                              description:
                                  "24/7 support and assistance whenever you need us",
                              delay: 700.ms,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
    required Duration delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00FF9C),
                  Color(0xFF00B86B),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          .animate(target: inView ? 1 : 0)
          .fadeIn(duration: 600.ms)
          .then(delay: delay)
          .slideY(begin: 0.2, end: 0),
    );
  }
}
