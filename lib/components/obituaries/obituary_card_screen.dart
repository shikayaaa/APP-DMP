import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class Obituary {
  final String fullName;
  final String? photoUrl;
  final String birthDate;
  final String passingDate;
  final String? section;
  final String? shortTribute;

  Obituary({
    required this.fullName,
    this.photoUrl,
    required this.birthDate,
    required this.passingDate,
    this.section,
    this.shortTribute,
  });
}

class ObituaryCard extends StatelessWidget {
  final Obituary obituary;
  final int index;
  final VoidCallback onView;

  const ObituaryCard({
    super.key,
    required this.obituary,
    required this.index,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, yyyy');

    return GestureDetector(
      onTap: onView,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle hover overlay (green-black neon theme)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00FF9C).withOpacity(0.08), // neon green glow
                      const Color(0xFF003B2F).withOpacity(0.08), // deep emerald
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Photo with glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF00FF9C),
                              Color(0xFF007A5C),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3300FF9C),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 4,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              obituary.photoUrl ??
                                  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    obituary.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Dates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.calendar, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "${df.format(DateTime.parse(obituary.birthDate))} - ${df.format(DateTime.parse(obituary.passingDate))}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Section
                  if (obituary.section != null && obituary.section!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.mapPin, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          obituary.section!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // Tribute
                  if (obituary.shortTribute != null &&
                      obituary.shortTribute!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '"${obituary.shortTribute!}"',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00FF9C), // neon green tribute
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // View button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: onView,
                      icon: const Icon(LucideIcons.arrowRight, size: 18),
                      label: const Text(
                        'View Obituary',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00FF9C),
                        side: const BorderSide(color: Color(0xFF00FF9C), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: index * 100))
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}
