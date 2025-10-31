import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ✅ Fixed imports - consistent with your structure
import '../components/home/footer_screen.dart';
import '../components/obituaries/condolence_form_screen.dart';
import '../entities/obituaryy_screen.dart';
import '../services/client_screen.dart';

class ObituaryDetailScreen extends StatefulWidget {
  final Obituary obituary;

  const ObituaryDetailScreen({super.key, required this.obituary});

  @override
  State<ObituaryDetailScreen> createState() => _ObituaryDetailScreenState();
}

class _ObituaryDetailScreenState extends State<ObituaryDetailScreen> {
  bool showCondolenceForm = false;
  bool isSubmitting = false;
  late List<Condolence> currentCondolences;

  @override
  void initState() {
    super.initState();
    currentCondolences = List.from(widget.obituary.condolences ?? []);
  }

  Future<void> handleCondolenceSubmit(Map<String, String> condolenceData) async {
    setState(() => isSubmitting = true);

    final newCondolence = Condolence(
      name: condolenceData['name'] ?? '',
      message: condolenceData['message'] ?? '',
      date: DateTime.now(),
    );

    final updatedCondolences = [...currentCondolences, newCondolence];

    try {
      final updatedObituary = Obituary(
        fullName: widget.obituary.fullName,
        birthDate: widget.obituary.birthDate,
        passingDate: widget.obituary.passingDate,
        photoUrl: widget.obituary.photoUrl,
        shortTribute: widget.obituary.shortTribute,
        fullObituary: widget.obituary.fullObituary,
        section: widget.obituary.section,
        galleryUrls: widget.obituary.galleryUrls,
        condolences: updatedCondolences,
      );

      await Client().updateObituary('obituary-id', updatedObituary);

      if (mounted) {
        setState(() {
          showCondolenceForm = false;
          currentCondolences = updatedCondolences;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your condolence'),
            backgroundColor: Color(0xFF00B86B),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final obituary = widget.obituary;

    return Scaffold(
      backgroundColor: const Color(0xFF001F1B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Gradient Header (emerald–teal glow)
            Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00FF9C),
                    Color(0xFF00B86B),
                    Color(0xFF00382F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Main content card
            Container(
              transform: Matrix4.translationValues(0, -100, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
                      label: const Text(
                        'Back to Obituaries',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromARGB(97, 0, 0, 0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ Dark glowing card container
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E1E1A),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        // Hero image with soft green overlay
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF00B86B).withOpacity(0.2),
                                    const Color(0xFF00382F).withOpacity(0.4),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Opacity(
                                opacity: 0.3,
                                child: Image.network(
                                  obituary.photoUrl != null && obituary.photoUrl!.isNotEmpty
                                      ? obituary.photoUrl!
                                      : 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                    obituary.photoUrl != null && obituary.photoUrl!.isNotEmpty
                                        ? obituary.photoUrl!
                                        : 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80',
                                  ),
                                  child: (obituary.photoUrl == null || obituary.photoUrl!.isEmpty)
                                      ? const Icon(Icons.person, size: 50)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Text + details
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                obituary.fullName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 18, color: Colors.white70),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${formatDate(obituary.birthDate)} - ${formatDate(obituary.passingDate)}',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),

                              if (obituary.section != null &&
                                  obituary.section!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.place,
                                        size: 18, color: Colors.white70),
                                    const SizedBox(width: 6),
                                    Text(
                                      obituary.section!,
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],

                              if (obituary.shortTribute != null &&
                                  obituary.shortTribute!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(
                                  '"${obituary.shortTribute}"',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF00FF9C),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        setState(() => showCondolenceForm = true),
                                    icon: const Icon(Icons.favorite),
                                    label: const Text('Leave Condolence'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00B86B),
                                      foregroundColor: Colors.white,
                                      shadowColor:
                                          const Color(0xFF00FF9C).withOpacity(0.4),
                                      elevation: 6,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Full obituary text
                              if (obituary.fullObituary != null &&
                                  obituary.fullObituary!.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    obituary.fullObituary!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),

                              

                              // Condolence form
                              if (showCondolenceForm)
                                CondolenceForm(
                                  onSubmit: handleCondolenceSubmit,
                                  onCancel: () =>
                                      setState(() => showCondolenceForm = false),
                                  isSubmitting: isSubmitting,
                                ),

                              // Condolence list
                              if (currentCondolences.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Text(
                                  'Condolences (${currentCondolences.length})',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...currentCondolences.map((condolence) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F2C25),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFF00B86B)
                                              .withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFF00B86B),
                                          child: Text(
                                            condolence.name.isNotEmpty
                                                ? condolence.name
                                                    .substring(0, 1)
                                                    .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    condolence.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  if (condolence.date != null)
                                                    Text(
                                                      formatDate(
                                                          condolence.date!),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                condolence.message,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
