import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../utils/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: "Schedule Pickup",
      description: "Easy scheduling for pickup and delivery at your convenience. Choose your preferred time slots.",
      image: Icons.schedule,
      color: const Color(0xFF3B82F6),
      features: ["Flexible timing", "Same-day pickup", "SMS reminders"],
    ),
    OnboardingContent(
      title: "Quality Service",
      description: "Professional cleaning with care for your precious clothes. Eco-friendly processes and premium care.",
      image: Icons.star,
      color: const Color(0xFF10B981),
      features: ["Eco-friendly", "Premium care", "Quality guarantee"],
    ),
    OnboardingContent(
      title: "Fast Delivery",
      description: "Quick turnaround time with real-time tracking. Stay updated every step of the way.",
      image: Icons.delivery_dining,
      color: const Color(0xFF8B5CF6),
      features: ["Real-time tracking", "Fast delivery", "24/7 support"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFC),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _goToLogin(),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        localizations.skip,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Image/Icon Container
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  _pages[index].color.withOpacity(0.1),
                                  _pages[index].color.withOpacity(0.05),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(120),
                              boxShadow: [
                                BoxShadow(
                                  color: _pages[index].color.withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(120),
                                border: Border.all(
                                  color: _pages[index].color.withOpacity(0.1),
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background decoration
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          _pages[index].color.withOpacity(0.1),
                                          _pages[index].color.withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                  ),
                                  // Main icon
                                  Icon(
                                    _pages[index].image,
                                    size: 80,
                                    color: _pages[index].color,
                                  ),
                                  // Smaller decorative icons
                                  ...List.generate(3, (i) => Positioned(
                                    top: 40 + (i * 30),
                                    right: 20,
                                    child: Icon(
                                      Icons.circle,
                                      size: 4,
                                      color: _pages[index].color.withOpacity(0.3),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Title
                          Text(
                            _pages[index].title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          
                          // Description
                          Text(
                            _pages[index].description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          
                          // Features list
                          Column(
                            children: _pages[index].features.map((feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: _pages[index].color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    feature,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _pages[index].color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Page Indicators
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFE5E7EB),
                        boxShadow: _currentPage == index ? [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous Button
                    if (_currentPage > 0)
                      TextButton.icon(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        label: Text(localizations.previous),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6B7280),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      )
                    else
                      const SizedBox(width: 80),
                    
                    // Next/Get Started Button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _goToLogin();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF3B82F6).withOpacity(0.3),
                      ),
                      icon: Icon(
                        _currentPage == _pages.length - 1 
                            ? Icons.rocket_launch 
                            : Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      label: Text(
                        _currentPage == _pages.length - 1 
                            ? localizations.getStarted 
                            : localizations.next,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData image;
  final Color color;
  final List<String> features;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    required this.features,
  });
}
