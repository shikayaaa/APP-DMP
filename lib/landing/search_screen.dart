import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'obituary_screen.dart';
import 'about_screen.dart';
import 'landingpage_screen.dart';
import 'gravefound_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch(BuildContext context) {
    String query = _searchController.text.trim().toLowerCase();

    if (query == 'juan' || query == 'juan dela cruz') {
      showDialog(
        context: context,
        builder: (context) => const GraveFoundScreen(
          name: 'Juan dela Cruz',
          location: 'Lawn Area - Premium',
          dateOfPassing: 'March 15, 2023',
          plotNumber: 'LA-P-125',
          section: 'Section A',
        ),
      );
    } else if (query == 'maria' || query == 'maria santos') {
      showDialog(
        context: context,
        builder: (context) => const GraveFoundScreen(
          name: 'Maria Santos',
          location: 'Memorial Garden - Special Premium',
          dateOfPassing: 'January 8, 2024',
          plotNumber: 'MG-SP-042',
          section: 'Section C',
        ),
      );
    } else if (query == 'carlos' || query == 'carlos reyes') {
      showDialog(
        context: context,
        builder: (context) => const GraveFoundScreen(
          name: 'Carlos Reyes',
          location: 'Family Estate - Premier',
          dateOfPassing: 'November 22, 2022',
          plotNumber: 'FE-PR-018',
          section: 'Section D',
        ),
      );
    } else if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name to search.')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Record Found'),
          content: Text('No grave record found for "$query".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openMap() async {
    // Dumaguete Memorial Park coordinates
    const String googleMapUrl =
        'https://maps.app.goo.gl/hTJ74CmkRGnc71tK7';

    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

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

            // Search Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search for the final resting place of your loved ones.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter Name of Deceased',
                      hintStyle: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 15,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFAAAAAA),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Button
                  ElevatedButton(
                    onPressed: () => _handleSearch(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB8A8),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🗺️ View Map Button
                  ElevatedButton.icon(
                    onPressed: _openMap,
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      'View Map',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 99, 90),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Results Section
            Expanded(
              child: Container(
                color: const Color(0xFFF8F8F8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Text(
                        'SAMPLE RESULTS',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          _buildResultCard(
                            name: 'Juan dela Cruz',
                            location: 'Lawn Area - Premium',
                            date: 'March 15, 2023',
                          ),
                          const SizedBox(height: 12),
                          _buildResultCard(
                            name: 'Maria Santos',
                            location: 'Memorial Garden - Special Premium',
                            date: 'January 8, 2024',
                          ),
                          const SizedBox(height: 12),
                          _buildResultCard(
                            name: 'Carlos Reyes',
                            location: 'Family Estate - Premier',
                            date: 'November 22, 2022',
                          ),
                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5F3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF4DB8A8),
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Log in to view complete details and map navigation.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                      height: 1.4,
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
        currentIndex: 1,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ObituaryScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Obituary'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String name,
    required String location,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Color(0xFF4DB8A8)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF4DB8A8)),
                    const SizedBox(width: 6),
                    Text(date,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.lock_outline, color: Color(0xFFCCCCCC), size: 22),
        ],
      ),
    );
  }
}
