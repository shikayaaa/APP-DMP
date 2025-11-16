import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSectionScreen extends StatefulWidget {
  const ContactSectionScreen({super.key});

  @override
  State<ContactSectionScreen> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtr = TextEditingController();
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _phoneCtr = TextEditingController();
  final TextEditingController _messageCtr = TextEditingController();

  bool _inView = false;
  bool _isSubmitting = false;

  final List<_ContactInfo> _contactInfo = [
    _ContactInfo(
      icon: Icons.location_on_rounded,
      title: 'Visit Us',
      content: 'Piapi Boulevard, Dumaguete City, Negros Oriental 6200',
    ),
    _ContactInfo(
      icon: Icons.phone_rounded,
      title: 'Call Us',
      content: '(035) 422-1234 / +63 917 123 4567',
    ),
    _ContactInfo(
      icon: Icons.mail_rounded,
      title: 'Email Us',
      content: 'info@dumaguetememorial.com',
    ),
    _ContactInfo(
      icon: Icons.access_time_rounded,
      title: 'Office Hours',
      content: 'Monday - Sunday: 6:00 AM - 7:00 PM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) setState(() => _inView = true);
      });
    });
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _phoneCtr.dispose();
    _messageCtr.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _nameCtr.clear();
      _emailCtr.clear();
      _phoneCtr.clear();
      _messageCtr.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent — we will contact you soon.')),
    );
  }

  Future<void> _openMap() async {
    final Uri mapUrl = Uri.parse('https://maps.app.goo.gl/ypPngKNTVF8kbhBK6');
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width >= 900;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 11, 40, 146), Color(0xFF00204A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4D9FFF), Color(0xFF1E63CC)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ).animate(target: _inView ? 1 : 0).fadeIn(duration: 500.ms),
                  const SizedBox(height: 14),
                  Text(
                    "We're Here to\nHelp",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isWide ? 40 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.08,
                    ),
                  )
                      .animate(target: _inView ? 1 : 0)
                      .fadeIn(duration: 600.ms, delay: 100.ms)
                      .slideY(begin: 0.15, end: 0),
                  const SizedBox(height: 12),
                  const Text(
                    'Reach out to our compassionate team for guidance and support',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  )
                      .animate(target: _inView ? 1 : 0)
                      .fadeIn(duration: 600.ms, delay: 200.ms),
                ],
              ),
              const SizedBox(height: 36),

              // Main content
              LayoutBuilder(builder: (context, constraints) {
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Contact Form
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Send us a Message',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _textField(_nameCtr, 'Full Name', 'John Doe'),
                                  const SizedBox(height: 12),
                                  _textField(
                                    _emailCtr,
                                    'Email Address',
                                    'john@example.com',
                                    type: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 12),
                                  _textField(
                                    _phoneCtr,
                                    'Phone Number',
                                    '+63 917 123 4567',
                                    type: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 12),
                                  _textField(
                                    _messageCtr,
                                    'Message',
                                    'How can we help you?',
                                    minLines: 4,
                                    maxLines: 6,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _isSubmitting ? null : _handleSubmit,
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 18),
                                        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                                        foregroundColor: const Color(0xFF00204A),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                      child: _isSubmitting
                                          ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(Colors.white),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(Icons.send_rounded, size: 18),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Send Message',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate(target: _inView ? 1 : 0).fadeIn(duration: 600.ms).slideX(begin: -0.12, end: 0),
                    ),

                    SizedBox(width: isWide ? 24 : 0, height: isWide ? 0 : 20),

                    // Right: Info + Map
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (isWide ? 2 : 1),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 3.2,
                            ),
                            itemCount: _contactInfo.length,
                            itemBuilder: (context, index) {
                              final info = _contactInfo[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.25),
                                      blurRadius: 12,
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF4D9FFF), Color(0xFF1E63CC)],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(info.icon, color: const Color.fromARGB(255, 0, 0, 0), size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(info.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromARGB(255, 0, 0, 0))),
                                          const SizedBox(height: 4),
                                          Text(info.content,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(179, 0, 0, 0), fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .animate(
                                      target: _inView ? 1 : 0,
                                      delay: Duration(milliseconds: 300 + index * 80))
                                  .fadeIn()
                                  .slideY(begin: 0.06, end: 0);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Map Container
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00336A), Color(0xFF001E3C)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 20,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/dmp.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    top: 16,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Dumaguete Memorial Park',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Piapi Boulevard, Dumaguete City',
                                          style: TextStyle(
                                              color: Colors.white70, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: _openMap,
                                      icon: const Icon(Icons.map_rounded),
                                      label: const Text('Open in Maps'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4D9FFF),
                                        foregroundColor: const Color(0xFF00204A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController ctr, String label, String hint,
      {TextInputType type = TextInputType.text, int minLines = 1, int? maxLines}) {
    return TextFormField(
      controller: ctr,
      keyboardType: type,
      minLines: minLines,
      maxLines: maxLines ?? minLines,
      style: const TextStyle(color: Color.fromARGB(255, 2, 1, 1)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(97, 0, 0, 0)),
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color.fromARGB(255, 68, 105, 158),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromARGB(255, 1, 10, 38).withOpacity(0.1), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF4D9FFF), width: 1.2),
        ),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Please enter $label' : null,
    );
  }
}

class _ContactInfo {
  final IconData icon;
  final String title;
  final String content;
  const _ContactInfo({
    required this.icon,
    required this.title,
    required this.content,
  });
}
