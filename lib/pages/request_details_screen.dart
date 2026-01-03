import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final String title;
  final String status;
  final String dateSubmitted;
  final String section;
  final String block;
  final String lotNumber;
  final String preferredDate;
  final String contactPerson;
  final String phoneNumber;
  final String notes;

  const RequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.title,
    required this.status,
    required this.dateSubmitted,
    required this.section,
    required this.block,
    required this.lotNumber,
    required this.preferredDate,
    required this.contactPerson,
    required this.phoneNumber,
    required this.notes,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Request Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Submitted on $dateSubmitted",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Deceased Information
            _buildInfoCard(
              title: "Deceased Information",
              children: [
                _buildInfoRow("Full Name", title),
              ],
            ),

            const SizedBox(height: 16),

            // Lot Information
            _buildInfoCard(
              title: "Lot Information",
              children: [
                _buildInfoRow("Section", section),
                _buildInfoRow("Block", block),
                _buildInfoRow("Lot Number", lotNumber),
              ],
            ),

            const SizedBox(height: 16),

            // Schedule Information
            _buildInfoCard(
              title: "Preferred Schedule",
              children: [
                _buildInfoRow("Date", preferredDate),
              ],
            ),

            const SizedBox(height: 16),

            // Contact Information
            _buildInfoCard(
              title: "Contact Person",
              children: [
                _buildInfoRow("Name", contactPerson),
                _buildInfoRow("Phone Number", phoneNumber),
              ],
            ),

            if (notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                title: "Additional Notes",
                children: [
                  Text(
                    notes,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            if (status.toLowerCase() == 'pending') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel Request"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cancel Request',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this interment request? This action cannot be undone.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No, Keep It',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog

                // Show feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request cancelled successfully'),
                    backgroundColor: Colors.orange,
                  ),
                );

                // Reload screen with updated status
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RequestDetailsScreen(
                      requestId: requestId,
                      title: title,
                      status: 'Cancelled',
                      dateSubmitted: dateSubmitted,
                      section: section,
                      block: block,
                      lotNumber: lotNumber,
                      preferredDate: preferredDate,
                      contactPerson: contactPerson,
                      phoneNumber: phoneNumber,
                      notes: notes,
                    ),
                  ),
                );
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}