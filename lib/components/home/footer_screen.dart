import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    final footerLinks = {
      'Services': [
        'Memorial Lots',
        'Cremation Services',
        'Mausoleums',
        'Pre-Planning',
      ],
      'Company': [
        'About Us',
        'Our Story',
        'Testimonials',
        'Careers',
      ],
      'Support': [
        'Contact Us',
        'FAQs',
        'Privacy Policy',
        'Terms of Service',
      ],
    };

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 10, 12, 15), // deep blackish green
            Color.fromARGB(255, 10, 11, 22),
            Color.fromARGB(255, 9, 14, 156),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // ✳️ Neon glow background accent
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromARGB(255, 185, 208, 214), // neon mint
                    Color.fromARGB(0, 12, 12, 12),
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                   Color.fromARGB(255, 185, 208, 214),
                     Color.fromARGB(0, 12, 12, 12),
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),

          // ✳️ Footer content
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isLarge = constraints.maxWidth > 900;
                    final isMedium = constraints.maxWidth > 600;

                    return Wrap(
                      spacing: 48,
                      runSpacing: 32,
                      children: [
                        // Logo & Description
                        SizedBox(
                          width: isLarge
                              ? constraints.maxWidth / 2.5
                              : isMedium
                                  ? constraints.maxWidth / 2
                                  : constraints.maxWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 27, 75, 194),
                                          Color.fromARGB(255, 8, 8, 109),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'DMP',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Dumaguete Memorial Park',
                                        style: TextStyle(
                                          color: Color(0xFFE8FFF4),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'A Place of Peace & Remembrance',
                                        style: TextStyle(
                                          color: Color(0xFFB8E1D0),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Honoring lives with dignity and compassion since 1990. We provide a serene sanctuary for families to remember and celebrate their loved ones.',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _socialIcon(
                                      LucideIcons.facebook,
                                      'https://www.facebook.com/DumagueteMemorialPark'),
                                  
                                  _socialIcon(
                                      LucideIcons.mail,
                                      'mailto:info@dumaguetememorial.com'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Footer links
                        ...footerLinks.entries.map((entry) {
                          return SizedBox(
                            width: isLarge
                                ? constraints.maxWidth / 6
                                : isMedium
                                    ? constraints.maxWidth / 3
                                    : constraints.maxWidth / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...entry.value.map(
                                  (link) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        link,
                                        style: const TextStyle(
                                          color: Color(0xFFB8E1D0),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),
                const Divider(color: Color.fromARGB(255, 7, 12, 11)),
                const SizedBox(height: 20),

                // Bottom bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '© $currentYear Dumaguete Memorial Park. All rights reserved.',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Made with ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 13,
                              ),
                            ),
                            Icon(
                              LucideIcons.heart,
                              color: Color.fromARGB(255, 0, 0, 0),
                              size: 14,
                            ),
                            Text(
                              ' for families in Negros Oriental',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOut),
          ),
        ],
      ),
    );
  }

  static Widget _socialIcon(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 22, 214, 236),
                Color.fromARGB(255, 19, 66, 141),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black, size: 20),
        ),
      ),
    );
  }
}
