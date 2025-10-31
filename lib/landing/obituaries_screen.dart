import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ✅ Import your existing files
import '../entities/obituaryy_screen.dart'; // Your Obituary model
import '../landing/obituary_detail_screen.dart';
import '../services/client_screen.dart';

class ObituariesScreen extends StatefulWidget {
  const ObituariesScreen({super.key});

  @override
  State<ObituariesScreen> createState() => _ObituariesScreenState();
}

class _ObituariesScreenState extends State<ObituariesScreen> {
  List<Obituary> obituaries = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchObituaries();
  }

  Future<void> _fetchObituaries() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedObituaries = await Client().fetchObituaries();

      if (mounted) {
        setState(() {
          obituaries = fetchedObituaries;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load obituaries: $e';
          isLoading = false;
        });
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081C15), // 🟢 dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3D2E), // 🟢 deep green header
        elevation: 0,
        title: const Text(
          'Obituaries',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C896)))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchObituaries,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C896),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : obituaries.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No obituaries found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: obituaries.length,
                      itemBuilder: (context, index) {
                        final obituary = obituaries[index];
                        return _ObituaryCard(
                          obituary: obituary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObituaryDetailScreen(
                                  obituary: obituary,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

// ✅ Card design with simple dark + neon green theme
class _ObituaryCard extends StatelessWidget {
  final Obituary obituary;
  final VoidCallback onTap;

  const _ObituaryCard({
    required this.obituary,
    required this.onTap,
  });

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0D261C), // 🟢 dark card color
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: const Color(0xFF00C896).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF00C896), width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: const Color(0xFF00C896).withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ✅ Photo
              CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xFF00C896).withOpacity(0.2),
                backgroundImage: NetworkImage(
                  obituary.photoUrl != null && obituary.photoUrl!.isNotEmpty
                      ? obituary.photoUrl!
                      : 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80',
                ),
                onBackgroundImageError: (error, stackTrace) {},
                child: (obituary.photoUrl == null || obituary.photoUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),

              // ✅ Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      obituary.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00E0A6), // 🟢 accent green
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Dates
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${formatDate(obituary.birthDate)} - ${formatDate(obituary.passingDate)}',
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    // Section
                    if (obituary.section != null && obituary.section!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              obituary.section!,
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Tribute
                    if (obituary.shortTribute != null && obituary.shortTribute!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '"${obituary.shortTribute!}"',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
