import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<AppNotification> _notifications = [];
  NotificationPreferences? _preferences;
  bool _isLoading = true;
  String _error = '';
  final ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final notifications = await NotificationService.getNotificationHistory(limit: _pageSize);
      final preferences = await NotificationService.getNotificationPreferences();

      setState(() {
        _notifications = notifications;
        _preferences = preferences;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final nextPage = _currentPage + 1;
      final newNotifications = await NotificationService.getNotificationHistory(
        limit: _pageSize,
      );

      if (newNotifications.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _notifications.addAll(newNotifications);
        _currentPage = nextPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _markAsRead(AppNotification notification) async {
    if (notification.read) return;

    try {
      await NotificationService.markNotificationAsRead(notification.id);
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = notification.copyWith(read: true);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark notification as read: $e')),
      );
    }
  }

  Future<void> _updatePreferences(NotificationPreferences newPreferences) async {
    try {
      final updatedPreferences = await NotificationService.updateNotificationPreferences(
        newPreferences,
      );
      setState(() {
        _preferences = updatedPreferences;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update preferences: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading && _notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_preferences != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey.shade100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notification Preferences',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              title: const Text('Budget Alerts'),
                              value: _preferences!.budgetAlerts,
                              onChanged: (value) {
                                _updatePreferences(NotificationPreferences(
                                  budgetAlerts: value,
                                  subscriptionAlerts: _preferences!.subscriptionAlerts,
                                  achievementAlerts: _preferences!.achievementAlerts,
                                  trendAlerts: _preferences!.trendAlerts,
                                  milestoneAlerts: _preferences!.milestoneAlerts,
                                ));
                              },
                            ),
                            SwitchListTile(
                              title: const Text('Subscription Alerts'),
                              value: _preferences!.subscriptionAlerts,
                              onChanged: (value) {
                                _updatePreferences(NotificationPreferences(
                                  budgetAlerts: _preferences!.budgetAlerts,
                                  subscriptionAlerts: value,
                                  achievementAlerts: _preferences!.achievementAlerts,
                                  trendAlerts: _preferences!.trendAlerts,
                                  milestoneAlerts: _preferences!.milestoneAlerts,
                                ));
                              },
                            ),
                            SwitchListTile(
                              title: const Text('Achievement Alerts'),
                              value: _preferences!.achievementAlerts,
                              onChanged: (value) {
                                _updatePreferences(NotificationPreferences(
                                  budgetAlerts: _preferences!.budgetAlerts,
                                  subscriptionAlerts: _preferences!.subscriptionAlerts,
                                  achievementAlerts: value,
                                  trendAlerts: _preferences!.trendAlerts,
                                  milestoneAlerts: _preferences!.milestoneAlerts,
                                ));
                              },
                            ),
                            SwitchListTile(
                              title: const Text('Trend Alerts'),
                              value: _preferences!.trendAlerts,
                              onChanged: (value) {
                                _updatePreferences(NotificationPreferences(
                                  budgetAlerts: _preferences!.budgetAlerts,
                                  subscriptionAlerts: _preferences!.subscriptionAlerts,
                                  achievementAlerts: _preferences!.achievementAlerts,
                                  trendAlerts: value,
                                  milestoneAlerts: _preferences!.milestoneAlerts,
                                ));
                              },
                            ),
                            SwitchListTile(
                              title: const Text('Milestone Alerts'),
                              value: _preferences!.milestoneAlerts,
                              onChanged: (value) {
                                _updatePreferences(NotificationPreferences(
                                  budgetAlerts: _preferences!.budgetAlerts,
                                  subscriptionAlerts: _preferences!.subscriptionAlerts,
                                  achievementAlerts: _preferences!.achievementAlerts,
                                  trendAlerts: _preferences!.trendAlerts,
                                  milestoneAlerts: value,
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _notifications.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _notifications.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final notification = _notifications[index];
                            return Dismissible(
                              key: Key(notification.id),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  _notifications.removeAt(index);
                                });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: notification.read
                                      ? Colors.grey.shade300
                                      : AppColors.primaryColor,
                                  child: Icon(
                                    _getNotificationIcon(notification.type),
                                    color: notification.read
                                        ? Colors.grey
                                        : Colors.white,
                                  ),
                                ),
                                title: Text(notification.title),
                                subtitle: Text(notification.message),
                                trailing: Text(
                                  _formatTimestamp(notification.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () => _markAsRead(notification),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'budget':
        return Icons.account_balance_wallet;
      case 'subscription':
        return Icons.subscriptions;
      case 'achievement':
        return Icons.emoji_events;
      case 'trend':
        return Icons.trending_up;
      case 'milestone':
        return Icons.flag;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
