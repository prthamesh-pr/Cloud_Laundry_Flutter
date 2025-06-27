import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/service_card.dart';
import '../widgets/status_card.dart';
import '../widgets/quick_action_button.dart';
import '../providers/auth_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/services_provider.dart';
import '../providers/notification_provider.dart';
import '../models/order.dart';
import 'main_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    servicesProvider.fetchServices();
    ordersProvider.fetchOrders();
    notificationProvider.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Status Card
          Consumer2<AuthProvider, OrdersProvider>(
            builder: (context, authProvider, ordersProvider, child) {
              final user = authProvider.user;
              final recentOrder = ordersProvider.orders.isNotEmpty
                  ? ordersProvider.orders.first
                  : null;

              return StatusCard(
                title: 'Welcome Back${user?.name != null ? ', ${user!.name.split(' ').first}!' : '!'}',
                subtitle: recentOrder != null
                    ? 'Your order #${recentOrder.id} is ${recentOrder.status}.'
                    : 'Ready to start your laundry service?',
                buttonText: recentOrder != null ? 'Track Order' : 'Place Order',
                onButtonPressed: () {
                  if (recentOrder != null) {
                    _showOrderTrackingDialog(context, recentOrder);
                  } else {
                    // Navigate to schedule screen
                    final mainContainer = context.findAncestorStateOfType<MainContainerState>();
                    if (mainContainer != null) {
                      mainContainer.goToPage(1); // Schedule page
                    }
                  }
                },
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Notifications Banner
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              final unreadCount = notificationProvider.unreadCount;
              if (unreadCount == 0) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You have $unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showNotificationsBottomSheet(context);
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              );
            },
          ),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.calendar_month,
                  text: 'Schedule Pickup',
                  iconColor: const Color(0xFF1D4ED8),
                  onTap: () {
                    final mainContainerState = context.findAncestorStateOfType<MainContainerState>();
                    if (mainContainerState != null) {
                      mainContainerState.goToPage(1);
                    } else {
                      Navigator.pushNamed(context, '/schedule');
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.receipt,
                  text: 'View History',
                  iconColor: const Color(0xFF16A34A),
                  onTap: () {
                    final mainContainerState = context.findAncestorStateOfType<MainContainerState>();
                    if (mainContainerState != null) {
                      mainContainerState.goToPage(2);
                    } else {
                      Navigator.pushNamed(context, '/history');
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Special Offer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Special Offer!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Get 20% off your first Dry Cleaning order. Limited time only!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1D4ED8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showOfferDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Claim Offer',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Services Section
          Consumer<ServicesProvider>(
            builder: (context, servicesProvider, child) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Our Popular Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        if (servicesProvider.isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (servicesProvider.error != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Failed to load services: ${servicesProvider.error}',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                            TextButton(
                              onPressed: () => servicesProvider.fetchServices(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    else if (servicesProvider.services.isEmpty && !servicesProvider.isLoading)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          ServiceCard(
                            icon: Icons.local_laundry_service,
                            title: 'Wash & Fold',
                            price: 'From \$2.50/lb',
                            color: const Color(0xFF3B82F6),
                            onTap: () => _navigateToServiceDetails(context, 'Wash & Fold'),
                          ),
                          ServiceCard(
                            icon: Icons.dry_cleaning,
                            title: 'Dry Cleaning',
                            price: 'From \$8.99',
                            color: const Color(0xFF10B981),
                            onTap: () => _navigateToServiceDetails(context, 'Dry Cleaning'),
                          ),
                          ServiceCard(
                            icon: Icons.king_bed,
                            title: 'Comforters',
                            price: 'From \$25.00',
                            color: const Color(0xFF8B5CF6),
                            onTap: () => _navigateToServiceDetails(context, 'Comforters'),
                          ),
                          ServiceCard(
                            icon: Icons.checkroom,
                            title: 'Specialty Items',
                            price: 'Custom Pricing',
                            color: const Color(0xFFF59E0B),
                            onTap: () => _navigateToServiceDetails(context, 'Specialty Items'),
                          ),
                        ],
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: servicesProvider.services.length > 4
                            ? 4
                            : servicesProvider.services.length,
                        itemBuilder: (context, index) {
                          final service = servicesProvider.services[index];
                          return ServiceCard(
                            icon: _getServiceIcon(service.name),
                            title: service.name,
                            price: 'From \$${service.basePrice.toStringAsFixed(2)}',
                            color: _getServiceColor(index),
                            onTap: () => _navigateToServiceDetails(context, service.name),
                          );
                        },
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _showAllServicesBottomSheet(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF3B82F6),
                          side: const BorderSide(color: Color(0xFF3B82F6)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View All Services',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Recent Activity
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer<OrdersProvider>(
                  builder: (context, ordersProvider, child) {
                    if (ordersProvider.orders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No recent activity',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final recentOrders = ordersProvider.orders.take(3).toList();
                    return Column(
                      children: recentOrders.map((order) {
                        return createActivityItem(order);
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createActivityItem(Order order) {
    IconData icon;
    Color color;
    String statusText;
    String timeText;

    switch (order.status) {
      case OrderStatus.delivered:
        icon = Icons.check_circle;
        color = const Color(0xFF10B981);
        statusText = 'delivered successfully';
        break;
      case OrderStatus.outForDelivery:
        icon = Icons.local_shipping;
        color = const Color(0xFF3B82F6);
        statusText = 'is out for delivery';
        break;
      case OrderStatus.inProcess:
        icon = Icons.hourglass_empty;
        color = const Color(0xFFF59E0B);
        statusText = 'is being processed';
        break;
      case OrderStatus.pickedUp:
        icon = Icons.check;
        color = const Color(0xFF8B5CF6);
        statusText = 'has been picked up';
        break;
      case OrderStatus.confirmed:
        icon = Icons.schedule;
        color = const Color(0xFF06B6D4);
        statusText = 'has been confirmed';
        break;
      case OrderStatus.pending:
        icon = Icons.pending;
        color = const Color(0xFF6B7280);
        statusText = 'is pending';
        break;
      case OrderStatus.readyForDelivery:
        icon = Icons.inventory;
        color = const Color(0xFF8B5CF6);
        statusText = 'is ready for delivery';
        break;
      case OrderStatus.cancelled:
        icon = Icons.cancel;
        color = const Color(0xFFEF4444);
        statusText = 'was cancelled';
        break;
    }

    final now = DateTime.now();
    final difference = now.difference(order.updatedAt);

    if (difference.inMinutes < 60) {
      timeText = '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      timeText = '${difference.inHours} hours ago';
    } else {
      timeText = '${difference.inDays} days ago';
    }

    return buildActivityItem(
      'Order #${order.id} $statusText',
      timeText,
      icon,
      color,
    );
  }

  Widget buildActivityItem(
      String title,
      String time,
      IconData icon,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('wash') || name.contains('fold')) {
      return Icons.local_laundry_service;
    } else if (name.contains('dry') || name.contains('clean')) {
      return Icons.dry_cleaning;
    } else if (name.contains('comforter') || name.contains('bed') || name.contains('blanket')) {
      return Icons.king_bed;
    } else if (name.contains('iron') || name.contains('press')) {
      return Icons.iron;
    } else if (name.contains('shoe') || name.contains('leather')) {
      return Icons.checkroom;
    } else if (name.contains('curtain') || name.contains('drape')) {
      return Icons.window;
    } else {
      return Icons.local_laundry_service;
    }
  }

  Color _getServiceColor(int index) {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
      const Color(0xFF84CC16),
      const Color(0xFFF97316),
    ];
    return colors[index % colors.length];
  }

  void _navigateToServiceDetails(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(serviceName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service: $serviceName'),
              const SizedBox(height: 8),
              const Text('Description: Professional laundry service with quick turnaround.'),
              const SizedBox(height: 8),
              const Text('Estimated time: 24-48 hours'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final mainContainerState = context.findAncestorStateOfType<MainContainerState>();
                if (mainContainerState != null) {
                  mainContainerState.goToPage(1);
                }
              },
              child: const Text('Schedule Pickup'),
            ),
          ],
        );
      },
    );
  }

  void _showOfferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Special Offer!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Congratulations! You can now get 20% off your first Dry Cleaning order.'),
              SizedBox(height: 16),
              Text('Offer Code: FIRST20'),
              SizedBox(height: 8),
              Text('Valid until the end of this month.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final mainContainerState = context.findAncestorStateOfType<MainContainerState>();
                if (mainContainerState != null) {
                  mainContainerState.goToPage(1);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Use Offer'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: const [
                        ListTile(
                          leading: Icon(Icons.local_offer, color: Colors.orange),
                          title: Text('Special Offer Available'),
                          subtitle: Text('Get 20% off your first dry cleaning order'),
                          trailing: Text('2h ago'),
                        ),
                        ListTile(
                          leading: Icon(Icons.local_laundry_service, color: Colors.blue),
                          title: Text('Order Update'),
                          subtitle: Text('Your order #12345 is ready for pickup'),
                          trailing: Text('1d ago'),
                        ),
                        ListTile(
                          leading: Icon(Icons.schedule, color: Colors.green),
                          title: Text('Pickup Reminder'),
                          subtitle: Text('Pickup scheduled for tomorrow at 2 PM'),
                          trailing: Text('2d ago'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAllServicesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'All Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      controller: scrollController,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        ServiceCard(
                          icon: Icons.local_laundry_service,
                          title: 'Wash & Fold',
                          price: 'From \$2.50/lb',
                          color: const Color(0xFF3B82F6),
                          onTap: () => _navigateToServiceDetails(context, 'Wash & Fold'),
                        ),
                        ServiceCard(
                          icon: Icons.dry_cleaning,
                          title: 'Dry Cleaning',
                          price: 'From \$8.99',
                          color: const Color(0xFF10B981),
                          onTap: () => _navigateToServiceDetails(context, 'Dry Cleaning'),
                        ),
                        ServiceCard(
                          icon: Icons.king_bed,
                          title: 'Comforters',
                          price: 'From \$25.00',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => _navigateToServiceDetails(context, 'Comforters'),
                        ),
                        ServiceCard(
                          icon: Icons.checkroom,
                          title: 'Specialty Items',
                          price: 'Custom Pricing',
                          color: const Color(0xFFF59E0B),
                          onTap: () => _navigateToServiceDetails(context, 'Specialty Items'),
                        ),
                        ServiceCard(
                          icon: Icons.iron,
                          title: 'Ironing & Pressing',
                          price: 'From \$3.99',
                          color: const Color(0xFFEF4444),
                          onTap: () => _navigateToServiceDetails(context, 'Ironing & Pressing'),
                        ),
                        ServiceCard(
                          icon: Icons.weekend,
                          title: 'Leather & Suede',
                          price: 'From \$15.99',
                          color: const Color(0xFF06B6D4),
                          onTap: () => _navigateToServiceDetails(context, 'Leather & Suede'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        final mainContainerState = context.findAncestorStateOfType<MainContainerState>();
                        if (mainContainerState != null) {
                          mainContainerState.goToPage(1);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Schedule Pickup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showOrderTrackingDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status.toString()).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(order.status.toString()),
                  color: _getStatusColor(order.status.toString()),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Status: ${order.status.toString().split('.').last}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getStatusColor(order.status.toString()),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrackingStep('Order Placed', true, Icons.shopping_bag),
                _buildTrackingStep('Pickup Scheduled', order.status.toString() != 'placed', Icons.schedule),
                _buildTrackingStep('In Progress', 
                    ['processing', 'ready', 'outForDelivery', 'delivered'].contains(order.status.toString().split('.').last), 
                    Icons.local_laundry_service),
                _buildTrackingStep('Ready for Delivery', 
                    ['ready', 'outForDelivery', 'delivered'].contains(order.status.toString().split('.').last), 
                    Icons.check_circle),
                _buildTrackingStep('Delivered', 
                    ['delivered'].contains(order.status.toString().split('.').last), 
                    Icons.home),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Details:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text('Service: ${order.items.isNotEmpty ? order.items[0].serviceName : "-"}'),
                      Text('Items: ${order.items.length} pieces'),
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                      Text('Date: ${order.createdAt.toLocal().toString().split(' ')[0]}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (order.status.toString().split('.').last != 'delivered')
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to history for full tracking
                  final mainContainer = context.findAncestorStateOfType<MainContainerState>();
                  if (mainContainer != null) {
                    mainContainer.goToPage(2);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Details'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTrackingStep(String title, bool isCompleted, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF10B981) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isCompleted ? Colors.white : Colors.grey.shade600,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
              color: isCompleted ? const Color(0xFF1F2937) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return Colors.blue;
      case 'picked up':
      case 'processing':
        return Colors.orange;
      case 'ready':
        return Colors.green;
      case 'out for delivery':
      case 'outfordelivery':
        return Colors.purple;
      case 'delivered':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return Icons.shopping_bag;
      case 'picked up':
      case 'processing':
        return Icons.local_laundry_service;
      case 'ready':
        return Icons.check_circle;
      case 'out for delivery':
      case 'outfordelivery':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.home;
      default:
        return Icons.info;
    }
  }

  void _showContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactItem(
                icon: Icons.phone,
                title: 'Call Us',
                subtitle: '+1 (555) 123-WASH',
                onTap: () {},
              ),
              _buildContactItem(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'support@cloudlaundry.com',
                onTap: () {},
              ),
              _buildContactItem(
                icon: Icons.chat,
                title: 'Live Chat',
                subtitle: 'Chat with our support team',
                onTap: () {},
              ),
              _buildContactItem(
                icon: Icons.location_on,
                title: 'Visit Us',
                subtitle: '123 Laundry St, Clean City',
                onTap: () {},
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF3B82F6),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}


