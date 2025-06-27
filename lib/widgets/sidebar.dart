import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

class AppSidebar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;
  final bool isDrawer;

  const AppSidebar({
    Key? key,
    required this.onItemSelected,
    required this.selectedIndex,
    this.isDrawer = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDrawer ? null : const Color(0xFF1F2937),
      child: Column(
        children: [
          // Header
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF1D4ED8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDrawer) 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40), // For balance
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_laundry_service,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cloud Laundry',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user?.name ?? 'Guest User',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Menu Items
          Expanded(
            child: Container(
              color: isDrawer ? Colors.white : const Color(0xFF1F2937),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    title: 'Home',
                    index: 0,
                  ),
                  _buildMenuItem(
                    icon: Icons.calendar_month_outlined,
                    activeIcon: Icons.calendar_month,
                    title: 'Schedule Pickup',
                    index: 1,
                  ),
                  _buildMenuItem(
                    icon: Icons.history_outlined,
                    activeIcon: Icons.history,
                    title: 'Order History',
                    index: 2,
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    title: 'Settings',
                    index: 3,
                  ),
                  const Divider(height: 32),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    title: 'Profile',
                    index: 4,
                    isSpecial: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    activeIcon: Icons.info,
                    title: 'About Us',
                    index: 5,
                    isSpecial: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    activeIcon: Icons.help,
                    title: 'Help & Support',
                    index: 6,
                    isSpecial: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    activeIcon: Icons.logout,
                    title: 'Logout',
                    index: 7,
                    isSpecial: true,
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required int index,
    bool isSpecial = false,
    bool isLogout = false,
  }) {
    final isSelected = selectedIndex == index && !isSpecial;
    final isDark = !isDrawer;

    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: ListTile(
          leading: Icon(
            isSelected ? activeIcon : icon,
            color: isLogout
                ? Colors.red[600]
                : isSelected
                ? const Color(0xFF3B82F6)
                : isDark
                ? Colors.white70
                : const Color(0xFF6B7280),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isLogout
                  ? Colors.red[600]
                  : isSelected
                  ? const Color(0xFF3B82F6)
                  : isDark
                  ? Colors.white
                  : const Color(0xFF374151),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          selected: isSelected,
          selectedTileColor: const Color(0xFF3B82F6).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () {
            if (isLogout) {
              _showLogoutDialog(context);
            } else if (isSpecial) {
              _handleSpecialNavigation(index, context);
            } else {
              onItemSelected(index);
            }
          },
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                
                // Navigate to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSpecialNavigation(int index, BuildContext context) {
    switch (index) {
      case 4: // Profile
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 5: // About Us
        _showAboutUsDialog(context);
        break;
      case 6: // Help & Support
        _showHelpSupportBottomSheet(context);
        break;
    }
  }

  void _showAboutUsDialog(BuildContext context) {
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
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_laundry_service,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text('About Cloud Laundry'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cloud Laundry - Your Trusted Laundry Partner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'We provide premium laundry and dry cleaning services with convenient pickup and delivery. Our mission is to save you time while keeping your clothes in perfect condition.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
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
                      Text(
                        'Our Services:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('• Wash & Fold\n• Dry Cleaning\n• Specialty Items\n• Comforters & Bedding'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Version 1.0.0\n© 2025 Cloud Laundry. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to contact or website
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Contact Us'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpSupportBottomSheet(BuildContext context) {
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.help,
                          color: Colors.green.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildHelpItem(
                          icon: Icons.phone,
                          title: 'Call Support',
                          subtitle: '24/7 Customer Service',
                          onTap: () {},
                        ),
                        _buildHelpItem(
                          icon: Icons.chat,
                          title: 'Live Chat',
                          subtitle: 'Chat with our support team',
                          onTap: () {},
                        ),
                        _buildHelpItem(
                          icon: Icons.email,
                          title: 'Email Support',
                          subtitle: 'support@cloudlaundry.com',
                          onTap: () {},
                        ),
                        const Divider(height: 32),
                        _buildHelpItem(
                          icon: Icons.help_outline,
                          title: 'FAQ',
                          subtitle: 'Frequently Asked Questions',
                          onTap: () => _showFAQDialog(context),
                        ),
                        _buildHelpItem(
                          icon: Icons.info_outline,
                          title: 'How It Works',
                          subtitle: 'Learn about our process',
                          onTap: () => _showHowItWorksDialog(context),
                        ),
                        _buildHelpItem(
                          icon: Icons.policy,
                          title: 'Terms & Privacy',
                          subtitle: 'Our policies and terms',
                          onTap: () {},
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

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF3B82F6),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF9CA3AF),
      ),
      onTap: onTap,
    );
  }

  void _showFAQDialog(BuildContext context) {
    Navigator.pop(context); // Close bottom sheet first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frequently Asked Questions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFAQItem(
                'How long does it take?',
                'Standard turnaround is 24-48 hours. Express service available.',
              ),
              _buildFAQItem(
                'What are your pickup hours?',
                'We offer pickup Monday-Friday 8AM-6PM, Saturday 9AM-4PM.',
              ),
              _buildFAQItem(
                'Is my first delivery free?',
                'Yes! We offer free delivery for orders over \$25.',
              ),
              _buildFAQItem(
                'What if my clothes are damaged?',
                'We have full insurance coverage for any damages.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHowItWorksDialog(BuildContext context) {
    Navigator.pop(context); // Close bottom sheet first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How It Works'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStepItem(1, 'Schedule', 'Choose your pickup time'),
              _buildStepItem(2, 'Pickup', 'We collect your laundry'),
              _buildStepItem(3, 'Clean', 'Professional cleaning process'),
              _buildStepItem(4, 'Deliver', 'Fresh clothes delivered back'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
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
}
