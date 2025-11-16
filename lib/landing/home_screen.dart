import 'package:flutter/material.dart';

// ✅ Your sections
import '../components/home/hero_section_screen.dart';
import '../components/home/about_section_screen.dart';
import '../components/home/services_section_screen.dart';
import '../components/home/contact_section_screen.dart';
import '../components/home/footer_screen.dart';

// ✅ Import the obituaries screen
import '../landing/obituaries_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  // ✅ GlobalKeys for each section
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // ✅ Scrolls smoothly to a specific section
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero).dy +
          _scrollController.offset -
          100;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // ✅ Navigate to Obituaries page
  void _navigateToObituaries() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ObituariesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Right-side navigation drawer for mobile
      endDrawer: _MobileNavDrawer(
        onHomeClick: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        },
        onAboutClick: () {
          _scrollToSection(_aboutKey);
        },
        onServicesClick: () {
          _scrollToSection(_servicesKey);
        },
        onContactClick: () {
          _scrollToSection(_contactKey);
        },
        onObituariesClick: _navigateToObituaries,
      ),

      body: Stack(
        children: [
          // ✅ Scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroSectionScreen(
                  onExploreServices: () {
                    _scrollToSection(_servicesKey);
                  },
                  onPlanAhead: () {
                    _scrollToSection(_contactKey);
                  },
                ),

                // Attach sections
                AboutSectionScreen(key: _aboutKey),
                ServicesSectionScreen(key: _servicesKey),
                ContactSectionScreen(key: _contactKey),
                const FooterSection(),
              ],
            ),
          ),

          // 🔵 Simple Blue Header Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366).withOpacity(0.85), // simpler deep blue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/dmplogofinal.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isMobile ? "DMP" : "Dumaguete Memorial Park",
                            style: const TextStyle(
                              color: Colors.white, // simple white text
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      // Desktop buttons
                      if (!isMobile)
                        Row(
                          children: [
                            _NavButton(title: "Home", onTap: () {
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut,
                              );
                            }),
                            _NavButton(title: "Services", onTap: () {
                              _scrollToSection(_servicesKey);
                            }),
                            _NavButton(title: "Obituaries", onTap: _navigateToObituaries),
                            _NavButton(title: "About", onTap: () {
                              _scrollToSection(_aboutKey);
                            }),
                            _NavButton(title: "Contact", onTap: () {
                              _scrollToSection(_contactKey);
                            }),
                          ],
                        )
                      else
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            iconSize: 28,
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 🔵 Mobile Drawer — Simple Blue Theme
class _MobileNavDrawer extends StatelessWidget {
  final VoidCallback onHomeClick;
  final VoidCallback onAboutClick;
  final VoidCallback onServicesClick;
  final VoidCallback onContactClick;
  final VoidCallback onObituariesClick;

  const _MobileNavDrawer({
    required this.onHomeClick,
    required this.onAboutClick,
    required this.onServicesClick,
    required this.onContactClick,
    required this.onObituariesClick,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF003366), // simple blue
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/dmplogofinal.png',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "DMP",
                    style: TextStyle(
                      color: Colors.white, // simple white
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white54),

            _DrawerItem(title: "Home", onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), onHomeClick);
            }),
            _DrawerItem(title: "Services", onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), onServicesClick);
            }),
            _DrawerItem(title: "Obituaries", onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), onObituariesClick);
            }),
            _DrawerItem(title: "About", onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), onAboutClick);
            }),
            _DrawerItem(title: "Contact", onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), onContactClick);
            }),
          ],
        ),
      ),
    );
  }
}

// 🔵 Drawer Item
class _DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // simple white
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}

// 🔵 Nav Button — Desktop
class _NavButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // simple white
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
