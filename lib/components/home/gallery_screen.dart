import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GallerySectionScreen extends StatefulWidget {
  const GallerySectionScreen({super.key});

  @override
  State<GallerySectionScreen> createState() => _GallerySectionScreenState();
}

class _GallerySectionScreenState extends State<GallerySectionScreen> {
  bool inView = false;
  String? selectedImage;

  final List<Map<String, dynamic>> images = [
    {
      'url':
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800&q=80',
      'title': 'Peaceful Gardens',
      'cross': 2,
      'main': 2,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&q=80',
      'title': 'Natural Beauty',
      'cross': 1,
      'main': 1,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800&q=80',
      'title': 'Serene Pathways',
      'cross': 1,
      'main': 1,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&q=80',
      'title': 'Sunset Views',
      'cross': 1,
      'main': 2,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&q=80',
      'title': 'Memorial Spaces',
      'cross': 2,
      'main': 1,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
      'title': 'Tranquil Grounds',
      'cross': 1,
      'main': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulate "in view" fade-in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(300.ms, () {
        if (mounted) setState(() => inView = true);
      });
    });
  }

  void _openLightbox(String url) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(230, 0, 0, 0), // replaced with .withValues equivalent
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            Center(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              /// Header
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B3A4), Color(0xFF0077B6)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                      .animate(target: inView ? 1 : 0)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(text: 'A Place of '),
                        TextSpan(
                          text: 'Natural Beauty',
                          style: TextStyle(
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color(0xFF00B3A4),
                                  Color(0xFF0077B6),
                                ],
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Explore our beautifully maintained grounds designed to provide peace and comfort",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              )
                  .animate(target: inView ? 1 : 0)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 48),

              /// Gallery Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                  } else {
                    crossAxisCount = 1;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return GestureDetector(
                        onTap: () => _openLightbox(image['url'] as String),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(26, 0, 0, 0), // replaced with .withValues equivalent
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Image
                                Image.network(
                                  image['url'] as String,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                                // Gradient overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          const Color.fromARGB(153, 0, 0, 0), // replaced with .withValues equivalent
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Title
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Text(
                                    image['title'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .animate(target: inView ? 1 : 0)
                          .fadeIn(
                            duration: 600.ms,
                            delay: Duration(milliseconds: index * 100),
                          )
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
