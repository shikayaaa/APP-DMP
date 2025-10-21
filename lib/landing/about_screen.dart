import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'obituary_screen.dart';
import 'landingpage_screen.dart'; // Add this import

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DB8A8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'DMP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Memorial Park',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF2C2C2C)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                    ),

                    // Local Asset Image (offline)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/office.jpg',
                          height: 600,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'For generations, Dumaguete Memorial Park has been a sanctuary of peace and remembrance. We are dedicated to providing compassionate care and dignified memorial services to families in their time of need.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Our beautifully maintained grounds offer a serene environment where families can honor and remember their loved ones with modern cemetery management technology.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Features
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            icon: Icons.favorite,
                            iconColor: const Color(0xFF4DB8A8),
                            title: 'Compassionate Care',
                            description:
                                'Honoring loved ones with dignity and respect.',
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.shield_outlined,
                            iconColor: const Color(0xFF4DB8A8),
                            title: 'Trusted Service',
                            description: 'Decades of memorial service experience.',
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.people_outline,
                            iconColor: const Color(0xFF4DB8A8),
                            title: 'Family-Centered',
                            description:
                                'Supporting families every step of the way.',
                          ),
                          
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contact Section
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2332),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4DB8A8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'DMP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Dumaguete Memorial Park',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Preserving memories with dignity and care. A peaceful sanctuary for remembrance and honor.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildContactItem(
                            icon: Icons.location_on,
                            text:
                                'Dumaguete City, Negros Oriental, Philippines',
                          ),
                          const SizedBox(height: 10),
                          _buildContactItem(
                            icon: Icons.phone,
                            text: '+63 (35) 123-4567',
                          ),
                          const SizedBox(height: 10),
                          _buildContactItem(
                            icon: Icons.email,
                            text: 'info@dumaguetememorial.com',
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                            //  _buildSocialButton(Icons.facebook),
                            //  const SizedBox(width: 12),
                             // _buildSocialButton(Icons.camera_alt),
                            //  const SizedBox(width: 12),
                             // _buildSocialButton(Icons.alternate_email),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              '© 2025 Dumaguete Memorial Park',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4DB8A8),
        unselectedItemColor: const Color(0xFF999999),
        currentIndex: 3, // About tab selected
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ObituaryScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Obituary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4DB8A8)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }

 
}
