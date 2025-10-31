import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
      color: Colors.transparent,
      child: Stack(
        children: [
          // Decorative blur circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(13, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(13, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                                      color: const Color.fromARGB(51, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'DMP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Dumaguete Memorial Park',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'A Place of Peace & Remembrance',
                                        style: TextStyle(
                                          color: Colors.white70,
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
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _socialIcon(
                                      LucideIcons.facebook,
                                      'https://facebook.com/dumaguetememorial'),
                                  _socialIcon(
                                      LucideIcons.instagram,
                                      'https://instagram.com/dumaguetememorial'),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...entry.value.map(
                                  (link) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        link,
                                        style: const TextStyle(
                                          color: Colors.white70,
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
                const Divider(color: Colors.white24),
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
                            color: Colors.white70,
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
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Icon(
                              LucideIcons.heart,
                              color: Colors.redAccent,
                              size: 14,
                            ),
                            Text(
                              ' for families in Negros Oriental',
                              style: TextStyle(
                                color: Colors.white70,
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
            ),
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
          decoration: BoxDecoration(
            color: const Color.fromARGB(51, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
