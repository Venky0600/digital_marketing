import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      emoji: '🌉',
      title: 'Bridge the Gap',
      subtitle: 'Connect influencers with businesses, franchises, and personal brands — all in one place.',
      gradient: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
    ),
    _OnboardingPage(
      emoji: '📣',
      title: 'Discover Campaigns',
      subtitle: 'Find the perfect brand collaborations that match your niche and audience.',
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    ),
    _OnboardingPage(
      emoji: '🏪',
      title: 'Franchise Opportunities',
      subtitle: 'Explore investment-ready franchise opportunities from top Indian brands.',
      gradient: [Color(0xFF26C6DA), Color(0xFF00897B)],
    ),
    _OnboardingPage(
      emoji: '🤖',
      title: 'AI-Powered Matching',
      subtitle: 'Our AI analyses 12+ data points to match you with the best influencers or campaigns.',
      gradient: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
    ),
    _OnboardingPage(
      emoji: '🚀',
      title: 'Grow Your Brand',
      subtitle: 'Manage your personal brand page, showcase services, and connect with clients.',
      gradient: [Color(0xFF5C6BC0), Color(0xFFAB47BC)],
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _pages[i],
          ),
          // Bottom controls
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),
                  Row(children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pageCtrl.previousPage(
                            duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                          child: Container(
                            height: 52,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(child: Text('Back', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15))),
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 2,
                      child: GradientButton(
                        label: _currentPage == _pages.length - 1 ? 'Get Started 🚀' : 'Next',
                        onPressed: _next,
                        gradient: const LinearGradient(colors: [Colors.white24, Colors.white38]),
                        icon: _currentPage == _pages.length - 1 ? null : Icons.arrow_forward_rounded,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: Text('Skip', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 60, 32, 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 56))),
              ),
              const SizedBox(height: 40),
              Text(title, textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 16),
              Text(subtitle, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.85), height: 1.6)),
            ],
          ),
        ),
      ),
    );
  }
}
