import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.local_laundry_service,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cloud Laundry',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Clothes, Our Care',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mission Section
            _buildSection(
              'Our Mission',
              'At Cloud Laundry, we are committed to providing exceptional laundry and dry cleaning services with unmatched convenience. Our mission is to give you more time for what matters most by taking care of your clothing needs with professional expertise and eco-friendly practices.',
              Icons.flag,
            ),
            const SizedBox(height: 24),

            // Features Section
            _buildSection(
              'Why Choose Us?',
              '',
              Icons.star,
              children: [
                _buildFeatureItem(
                  'Convenient Pickup & Delivery',
                  'Schedule pickup and delivery at your preferred time and location.',
                  Icons.local_shipping,
                ),
                _buildFeatureItem(
                  'Professional Quality',
                  'Expert care for all types of garments using premium equipment and techniques.',
                  Icons.verified,
                ),
                _buildFeatureItem(
                  'Eco-Friendly Process',
                  'We use environmentally safe cleaning products and energy-efficient processes.',
                  Icons.eco,
                ),
                _buildFeatureItem(
                  'Real-Time Tracking',
                  'Track your order status from pickup to delivery with live updates.',
                  Icons.track_changes,
                ),
                _buildFeatureItem(
                  'Affordable Pricing',
                  'Competitive rates with transparent pricing and no hidden fees.',
                  Icons.attach_money,
                ),
                _buildFeatureItem(
                  '24/7 Customer Support',
                  'Our dedicated support team is always ready to help you.',
                  Icons.support_agent,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // History Section
            _buildSection(
              'Our Story',
              'Founded in 2020, Cloud Laundry started with a simple idea: make laundry services accessible, convenient, and reliable for everyone. What began as a small local business has grown into a trusted service provider, serving thousands of satisfied customers across the city.\n\nOur team of experienced professionals is dedicated to providing the highest quality care for your garments while maintaining the convenience you deserve.',
              Icons.history,
            ),
            const SizedBox(height: 24),

            // Team Section
            _buildSection(
              'Meet Our Team',
              'Our experienced team is passionate about providing excellent service and taking care of your clothing needs.',
              Icons.group,
              children: [
                _buildTeamMember(
                  'Sarah Johnson',
                  'Founder & CEO',
                  'With over 15 years in the textile industry, Sarah founded Cloud Laundry to revolutionize laundry services.',
                ),
                _buildTeamMember(
                  'Michael Chen',
                  'Operations Manager',
                  'Michael ensures smooth operations and maintains our high-quality standards across all services.',
                ),
                _buildTeamMember(
                  'Emily Rodriguez',
                  'Customer Experience Lead',
                  'Emily leads our customer support team to ensure every customer has an exceptional experience.',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Contact Info
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
                  Row(
                    children: [
                      const Icon(
                        Icons.contact_phone,
                        color: Color(0xFF3B82F6),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Get in Touch',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildContactItem(Icons.email, 'Email', 'hello@cloudlaundry.com'),
                  _buildContactItem(Icons.phone, 'Phone', '+1 (555) 123-WASH'),
                  _buildContactItem(Icons.location_on, 'Address', '123 Clean Street, Laundry City, LC 12345'),
                  _buildContactItem(Icons.schedule, 'Hours', 'Mon-Sun: 7:00 AM - 10:00 PM'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Version
            Center(
              child: Text(
                'Cloud Laundry App v1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, {List<Widget>? children}) {
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
            children: [
              Icon(icon, color: const Color(0xFF3B82F6), size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],
          if (children != null) ...[
            const SizedBox(height: 16),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF3B82F6),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
