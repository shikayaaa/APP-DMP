import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payments_screen.dart';
import 'contract_documents_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() => _isLoading = true);

      final user = _auth.currentUser;
      if (user == null) return;

      List<Map<String, dynamic>> notifications = [];

      // 1. Check for upcoming payment due
      final agreementSnapshot = await _firestore
          .collection('preNeedAgreements')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (agreementSnapshot.docs.isNotEmpty) {
        final agreement = agreementSnapshot.docs.first.data();
        final nextPaymentDate = agreement['nextPaymentDate'] ?? '';
        final nextPaymentAmount = agreement['nextPaymentAmount'] ?? '₱0';
        
        notifications.add({
          'id': 'payment_due_${agreement['nextPaymentDate']}',
          'type': 'payment_due',
          'icon': Icons.payment,
          'iconColor': Colors.blue,
          'borderColor': Colors.blue,
          'title': 'Payment Due Reminder',
          'description': 'Your monthly payment of $nextPaymentAmount for ${agreement['location'] ?? 'Garden Family Estate'} is due on $nextPaymentDate',
          'date': _formatDateShort(DateTime.now()),
          'read': false,
          'timestamp': DateTime.now(),
          'hasActions': true,
        });
      }

      // 2. Get recent completed payments
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('paidAt', descending: true)
          .limit(3)
          .get();

      for (var doc in paymentsSnapshot.docs) {
        final payment = doc.data();
        final paidAt = (payment['paidAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        
        notifications.add({
          'id': doc.id,
          'type': 'payment_received',
          'icon': Icons.check_circle_outline,
          'iconColor': Colors.green,
          'borderColor': Colors.green,
          'title': 'Payment Received',
          'description': 'Your payment of ₱${_formatAmount(payment['amount'])} has been successfully processed via ${payment['paymentMethod'] ?? 'payment method'}.',
          'date': _formatDateShort(paidAt),
          'read': _isOlderThanThreeDays(paidAt),
          'timestamp': paidAt,
          'hasActions': false,
        });
      }

      // 3. Contract documents notification (if plan exists)
      if (agreementSnapshot.docs.isNotEmpty) {
        final agreement = agreementSnapshot.docs.first.data();
        final createdAt = (agreement['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        
        notifications.add({
          'id': 'contract_${agreementSnapshot.docs.first.id}',
          'type': 'contract_ready',
          'icon': Icons.description_outlined,
          'iconColor': Colors.blue,
          'borderColor': Colors.blue,
          'title': 'Contract Documents Ready',
          'description': 'Your Deed of Sale & Perpetual Care document for ${agreement['planTitle'] ?? 'your plan'} is now available.',
          'date': _formatDateShort(createdAt.add(const Duration(days: 1))),
          'read': _isOlderThanSevenDays(createdAt),
          'timestamp': createdAt.add(const Duration(days: 1)),
          'hasActions': true,
        });
      }

      // Sort by timestamp (newest first)
      notifications.sort((a, b) => 
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime)
      );

      // Count unread
      final unread = notifications.where((n) => n['read'] == false).length;

      setState(() {
        _notifications = notifications;
        _unreadCount = unread;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() => _isLoading = false);
    }
  }

  bool _isOlderThanThreeDays(DateTime date) {
    return DateTime.now().difference(date).inDays > 3;
  }

  bool _isOlderThanSevenDays(DateTime date) {
    return DateTime.now().difference(date).inDays > 7;
  }

  String _formatAmount(dynamic amount) {
    final value = (amount as num?)?.toDouble() ?? 0.0;
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatDateShort(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
      _unreadCount = 0;
    });
  }

  void markAsRead(int index) {
    setState(() {
      _notifications[index]['read'] = true;
      _unreadCount = _notifications.where((n) => n['read'] == false).length;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      if (!_notifications[index]['read']) {
        _unreadCount--;
      }
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Stay updated with your account',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: markAllAsRead,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Mark All Read',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildTab('All (${_notifications.length})', true),
                if (_unreadCount > 0) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_unreadCount unread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                : _notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildNotificationCard(
                              index: index,
                              notification: notification,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black54,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required int index,
    required Map<String, dynamic> notification,
  }) {
    final hasRedDot = !(notification['read'] as bool);
    final hasActions = notification['hasActions'] as bool;
    final type = notification['type'] as String;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (notification['iconColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['iconColor'],
                  size: 22,
                ),
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
                            notification['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (hasRedDot)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification['description'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification['date'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[400]),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => deleteNotification(index),
              ),
            ],
          ),
          if (hasActions) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (type == 'payment_due') ...[
                  Expanded(
                    child: _buildActionButton('Pay Now', isPrimary: true, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentsScreen(),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                ],
                if (type == 'contract_ready') ...[
                  Expanded(
                    child: _buildActionButton('View Document', isPrimary: true, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContractDocumentsPage(),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: _buildActionButton('Mark as Read', onPressed: () => markAsRead(index)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, {bool isPrimary = false, VoidCallback? onPressed}) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.blue,
          side: isPrimary ? null : const BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}