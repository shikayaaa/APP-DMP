import 'package:flutter/material.dart';
import 'payment_screen.dart'; // Add this import
import 'contract_documents_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool showAll = true;
  Set<int> readNotifications = {}; // Track read notifications

  void markAllAsRead() {
    setState(() {
      // Mark all notifications as read (0-4 are the indices)
      readNotifications = {0, 1, 2, 3, 4};
    });
  }

  void markAsRead(int index) {
    setState(() {
      readNotifications.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Stay updated with your account',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: markAllAsRead,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Simplified: removed the Unread tab
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTab('All (5)', true),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildNotificationCard(
                  index: 0,
                  icon: Icons.payment,
                  iconColor: Colors.orange,
                  borderColor: Colors.orange,
                  title: 'Payment Due Reminder',
                  description:
                      'Your monthly payment of ₱2,500 for Garden Family Estate is due on March 15, 2024',
                  date: 'Mar 12',
                  hasRedDot: !readNotifications.contains(0),
                  buttons: [
                    _buildActionButton('Pay Now', isPrimary: true, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    }),
                    _buildActionButton('Mark as Read', onPressed: () => markAsRead(0)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  index: 1,
                  icon: Icons.description_outlined,
                  iconColor: Colors.blue,
                  borderColor: Colors.blue,
                  title: 'Contract Documents Ready',
                  description:
                      'Your Deed of Sale & Perpetual Care document is now available for download.',
                  date: 'Mar 8',
                  hasRedDot: !readNotifications.contains(1),
                  buttons: [
                    _buildActionButton(
                      'View Document',
                      isPrimary: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContractDocumentsPage(),
                          ),
                        );
                      },
                    ),
                    _buildActionButton('Mark as Read', onPressed: () => markAsRead(1)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  index: 2,
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  borderColor: Colors.green,
                  title: 'Payment Received',
                  description:
                      'Your payment of ₱2,500 for February 2024 has been successfully processed via GCash.',
                  date: 'Feb 16',
                  hasRedDot: !readNotifications.contains(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAll = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[600],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required int index,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String description,
    required String date,
    required bool hasRedDot,
    List<Widget> buttons = const [],
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (hasRedDot)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ],
          ),
          if (buttons.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                for (int i = 0; i < buttons.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  buttons[i],
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, {bool isPrimary = false, VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: TextButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF1B4332) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        side: isPrimary ? null : BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
