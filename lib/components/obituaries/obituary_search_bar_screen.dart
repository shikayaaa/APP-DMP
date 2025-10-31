import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ObituarySearchBar extends StatefulWidget {
  final String searchTerm;
  final String selectedSection;
  final DateTime? dateFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSectionChanged;
  final ValueChanged<DateTime?> onDateChanged;

  const ObituarySearchBar({
    super.key,
    required this.searchTerm,
    required this.selectedSection,
    required this.dateFilter,
    required this.onSearchChanged,
    required this.onSectionChanged,
    required this.onDateChanged,
  });

  @override
  State<ObituarySearchBar> createState() => _ObituarySearchBarState();
}

class _ObituarySearchBarState extends State<ObituarySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> sections = [
    'All Sections',
    'Garden of Peace',
    'Memorial Gardens',
    'Rose Garden',
    'Serenity Section',
    'Heritage Lawn',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchTerm;
  }

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.dateFilter ?? now,
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
      helpText: 'Select Month',
    );
    if (picked != null) widget.onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0x1A00FF9C), // subtle neon glow
            Color(0x1A003B2F), // darker emerald tone
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x3300FF9C), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2200FF9C),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              return Wrap(
                runSpacing: 12,
                spacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  // 🔍 Search by name
                  _buildInputField(
                    icon: LucideIcons.search,
                    hint: 'Search by name...',
                    controller: _searchController,
                    onChanged: widget.onSearchChanged,
                    width:
                        isMobile ? double.infinity : constraints.maxWidth * 0.45,
                  ),

                  // 📅 Date filter
                  _buildDateField(
                    context,
                    icon: LucideIcons.calendar,
                    label: widget.dateFilter == null
                        ? 'Filter by date...'
                        : '${widget.dateFilter!.month}/${widget.dateFilter!.year}',
                    onTap: () => _selectMonth(context),
                    width:
                        isMobile ? double.infinity : constraints.maxWidth * 0.2,
                  ),

                  // 📍 Section dropdown
                  _buildDropdown(
                    icon: LucideIcons.mapPin,
                    value: widget.selectedSection.isEmpty
                        ? sections.first
                        : widget.selectedSection,
                    items: sections,
                    onChanged: widget.onSectionChanged,
                    width:
                        isMobile ? double.infinity : constraints.maxWidth * 0.25,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          // Mobile "Search" Button
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) return const SizedBox.shrink();
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.search, size: 20),
                  label: const Text(
                    'Search',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF9C),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .moveY(begin: 20, end: 0, curve: Curves.easeOut);
  }

  // --- Helper Widgets ---

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 56,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFF00FF9C), width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 56,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00FF9C), width: 2),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: label.contains('Filter') || label.contains('date')
                  ? Colors.grey.shade500
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 56,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00FF9C), width: 2),
          ),
        ),
        items: items
            .map(
              (section) => DropdownMenuItem(
                value: section,
                child: Text(section),
              ),
            )
            .toList(),
      ),
    );
  }
}
