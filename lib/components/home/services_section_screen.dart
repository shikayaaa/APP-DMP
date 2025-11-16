import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../components/home/pricelistmodal_screen.dart';

class ServicesSectionScreen extends StatefulWidget {
  const ServicesSectionScreen({super.key});

  @override
  State<ServicesSectionScreen> createState() => _ServicesSectionScreenState();
}

class _ServicesSectionScreenState extends State<ServicesSectionScreen> {
  bool inView = false;

  final List<Map<String, dynamic>> services = [
    {
      'icon': LucideIcons.mapPin,
      'title': "Lawn Area",
      'description':
          "Beautiful plots in peaceful settings with perpetual care and maintenance",
      'features': ["Family estates", "Garden plots", "Premium locations"],
      'gradient': [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
    },
    {
      'icon': LucideIcons.flame,
      'title': "Memorial Garden",
      'description':
          "Dignified cremation with various memorial options for your loved ones",
      'features': ["Private services", "Urn selection", "Memorial gardens"],
      'gradient': [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
    },
    {
      'icon': LucideIcons.home,
      'title': "Garden Family Estate",
      'description':
          "Elegant above-ground structures for families seeking lasting tributes",
      'features': ["Private estates", "Climate controlled", "Custom designs"],
      'gradient': [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
    },
    {
      'icon': LucideIcons.flower2,
      'title': "Family Estate (Mausoleum)",
      'description':
          "Serene garden settings with personalized monuments and landscaping",
      'features': ["Custom markers", "Garden maintenance", "Seasonal flowers"],
      'gradient': [const Color(0xFF1E3A8A), const Color(0xFF60A5FA)],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(400.ms, () {
        if (mounted) setState(() => inView = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFDBEAFE),
            Color(0xFF93C5FD),
            Color(0xFF3B82F6)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: CustomPaint(
                painter: _CurvePainter(top: true),
                size: const Size(double.infinity, 120),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 40 : 80,
                horizontal: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 60),
                      _buildServiceGrid(isMobile),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 120,
              child: CustomPaint(
                painter: _CurvePainter(top: false),
                size: const Size(double.infinity, 120),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Text(
            "Our Services",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
              height: 1.3,
            ),
            children: [
              const TextSpan(text: 'Caring for Every '),
              TextSpan(
                text: 'Need',
                style: TextStyle(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                    ).createShader(
                      const Rect.fromLTWH(0, 0, 200, 70),
                    ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "From traditional burial services to modern cremation options, "
          "we provide comprehensive care tailored to your family's wishes.",
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Color.fromARGB(179, 0, 0, 0),  // <-- this is the color
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ],
    )
        .animate(target: inView ? 1 : 0)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildServiceGrid(bool isMobile) {
    if (isMobile) {
      return Column(
        children: services.asMap().entries.map((entry) {
          final index = entry.key;
          final s = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _ServiceCard(
              icon: s['icon'] as IconData,
              title: s['title'] as String,
              description: s['description'] as String,
              features: (s['features'] as List).cast<String>(),
              gradientColors: (s['gradient'] as List).cast<Color>(),
              delay: 0.1 * index,
              inView: inView,
            ),
          );
        }).toList(),
      );
    }

    // Desktop layout
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              for (int i = 0; i < 3; i++)
                SizedBox(
                  width: 320,
                  child: _ServiceCard(
                    icon: services[i]['icon'] as IconData,
                    title: services[i]['title'] as String,
                    description: services[i]['description'] as String,
                    features: (services[i]['features'] as List).cast<String>(),
                    gradientColors:
                        (services[i]['gradient'] as List).cast<Color>(),
                    delay: 0.1 * i,
                    inView: inView,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: 320,
              child: _ServiceCard(
                icon: services[3]['icon'] as IconData,
                title: services[3]['title'] as String,
                description: services[3]['description'] as String,
                features: (services[3]['features'] as List).cast<String>(),
                gradientColors:
                    (services[3]['gradient'] as List).cast<Color>(),
                delay: 0.4,
                inView: inView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final List<Color> gradientColors;
  final double delay;
  final bool inView;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.gradientColors,
    required this.delay,
    required this.inView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF), // ✅ Card background blue
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30), // ✅ icon white
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
                fontSize: 15, color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(LucideIcons.check, size: 18, color: gradientColors[0]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ View Pricing Button
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(LucideIcons.eye, color: Colors.white),
              label: const Text("View Pricing",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: gradientColors.last,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PriceListModal(serviceTitle: title),
                );
              },
            ),
          ),
        ],
      ),
    )
        .animate(target: inView ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: (delay * 1000).toInt()))
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}

class _CurvePainter extends CustomPainter {
  final bool top;
  _CurvePainter({required this.top});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFF3B82F6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    if (top) {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(
          size.width / 2, size.height - 60, size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else {
      path.moveTo(0, 0);
      path.quadraticBezierTo(size.width / 2, 60, size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
