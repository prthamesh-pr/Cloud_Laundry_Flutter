import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _orderUpdates = true;
  bool _promotionalEmails = false;
  
  final _addressController = TextEditingController(text: '123 Main St, Anytown');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  String _selectedPaymentMethod = 'Visa **** 1234';
  String _selectedLanguage = 'English';

  final List<String> _paymentMethods = [
    'Visa **** 1234',
    'Mastercard **** 5678',
    'Add New Card...'
  ];

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Settings
          _buildSectionCard(
            'Account Settings',
            Icons.person,
            [
              _buildTextFieldSetting(
                'Default Address',
                _addressController,
                Icons.location_on,
              ),
              _buildTextFieldSetting(
                'Phone Number',
                _phoneController,
                Icons.phone,
              ),
              _buildDropdownSetting(
                'Language',
                _selectedLanguage,
                _languages,
                Icons.language,
                (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  // Update app language
                  _updateAppLanguage(value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Payment Settings
          _buildSectionCard(
            'Payment Settings',
            Icons.payment,
            [
              _buildDropdownSetting(
                'Default Payment Method',
                _selectedPaymentMethod,
                _paymentMethods,
                Icons.credit_card,
                (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                  if (value == 'Add New Card...') {
                    _showAddCardDialog();
                  }
                },
              ),
              _buildListTileSetting(
                'Billing History',
                'View past invoices and receipts',
                Icons.receipt_long,
                () {
                  // Handle billing history
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Notification Settings
          _buildSectionCard(
            'Notification Settings',
            Icons.notifications,
            [
              _buildSwitchSetting(
                'Push Notifications',
                'Receive notifications on your device',
                _notificationsEnabled,
                (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              _buildSwitchSetting(
                'Email Notifications',
                'Receive updates via email',
                _emailNotifications,
                (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              _buildSwitchSetting(
                'SMS Notifications',
                'Receive text message updates',
                _smsNotifications,
                (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),
              _buildSwitchSetting(
                'Order Updates',
                'Get notified about order status changes',
                _orderUpdates,
                (value) {
                  setState(() {
                    _orderUpdates = value;
                  });
                },
              ),
              _buildSwitchSetting(
                'Promotional Emails',
                'Receive offers and promotions',
                _promotionalEmails,
                (value) {
                  setState(() {
                    _promotionalEmails = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // App Settings
          _buildSectionCard(
            'App Settings',
            Icons.settings,
            [
              _buildListTileSetting(
                'Privacy Policy',
                'Read our privacy policy',
                Icons.privacy_tip,
                () {
                  _showPrivacyPolicyDialog();
                },
              ),
              _buildListTileSetting(
                'Terms of Service',
                'Read our terms and conditions',
                Icons.description,
                () {
                  _showTermsOfServiceDialog();
                },
              ),
              _buildListTileSetting(
                'Help & Support',
                'Get help or contact support',
                Icons.help,
                () {
                  // Handle help and support
                },
              ),
              _buildListTileSetting(
                'Rate the App',
                'Leave a review on the app store',
                Icons.star,
                () {
                  // Handle app rating
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Actions
          _buildSectionCard(
            'Account Actions',
            Icons.admin_panel_settings,
            [
              _buildListTileSetting(
                'Change Password',
                'Update your account password',
                Icons.lock,
                () {
                  _showChangePasswordDialog();
                },
              ),
              _buildListTileSetting(
                'Export Data',
                'Download your account data',
                Icons.download,
                () {
                  // Handle data export
                },
                textColor: const Color(0xFF3B82F6),
              ),
              _buildListTileSetting(
                'Delete Account',
                'Permanently delete your account',
                Icons.delete_forever,
                () {
                  _showDeleteAccountDialog();
                },
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showLogoutDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
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
              Icon(icon, color: const Color(0xFF3B82F6), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSetting(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> items,
    IconData icon,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildListTileSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: textColor ?? const Color(0xFF6B7280),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? const Color(0xFF374151),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF6B7280),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle password change
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Card'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle add card
            },
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _updateAppLanguage(String languageCode) {
    // Get the language code (first 2 characters)
    String code = languageCode.toLowerCase().substring(0, 2);
    if (languageCode.toLowerCase() == 'english') code = 'en';
    else if (languageCode.toLowerCase() == 'spanish') code = 'es';
    else if (languageCode.toLowerCase() == 'french') code = 'fr';
    else if (languageCode.toLowerCase() == 'german') code = 'de';

    // Update the settings provider
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final newSettings = settingsProvider.settings.copyWith(language: code);
    settingsProvider.updateSettings(newSettings);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to $languageCode'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  String _getLanguageCode(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return 'en';
      case 'spanish':
        return 'es';
      case 'french':
        return 'fr';
      case 'german':
        return 'de';
      default:
        return 'en';
    }
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cloud Laundry Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Last updated: January 2025\n\n'
                '1. Information We Collect\n'
                'We collect personal information you provide, including name, email, phone number, and address.\n\n'
                '2. How We Use Your Information\n'
                'We use your information to provide laundry services, process payments, and communicate with you.\n\n'
                '3. Data Security\n'
                'We implement appropriate security measures to protect your personal information.\n\n'
                '4. Contact Us\n'
                'If you have questions about this privacy policy, contact us at privacy@cloudlaundry.com',
                style: TextStyle(height: 1.5),
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

  void _showTermsOfServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cloud Laundry Terms of Service',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Last updated: January 2025\n\n'
                '1. Service Agreement\n'
                'By using our services, you agree to these terms and conditions.\n\n'
                '2. Service Availability\n'
                'Services are available Monday-Saturday. Pickup times may vary.\n\n'
                '3. Payment Terms\n'
                'Payment is due upon delivery. We accept major credit cards.\n\n'
                '4. Liability\n'
                'We are not responsible for items left in pockets or pre-existing damage.\n\n'
                '5. Contact\n'
                'For questions, contact us at terms@cloudlaundry.com',
                style: TextStyle(height: 1.5),
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

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
