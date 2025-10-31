import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ObituaryGallery extends StatefulWidget {
  final List<String> images;

  const ObituaryGallery({super.key, required this.images});

  @override
  State<ObituaryGallery> createState() => _ObituaryGalleryState();
}

class _ObituaryGalleryState extends State<ObituaryGallery> {
  void _openLightbox(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Image with scale animation
              Animate(
                effects: [
                  FadeEffect(duration: 300.ms),
                  ScaleEffect(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1.0, 1.0),
                    duration: 300.ms,
                  ),
                ],
                child: GestureDetector(
                  onTap: () {}, // stop tap propagation
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 40,
                right: 24,
                child: IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 2 on small screens, 4 on large
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final image = widget.images[index];
        return Animate(
          effects: [
            FadeEffect(duration: 300.ms, delay: (index * 100).ms),
            ScaleEffect(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOut,
            ),
          ],
          child: GestureDetector(
            onTap: () => _openLightbox(image),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Image
                  Positioned.fill(
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay on hover
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0077B6).withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
