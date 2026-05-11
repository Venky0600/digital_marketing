import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user_model.dart';
import '../widgets/gradient_button.dart';
import '../services/auth_service.dart';
import 'campaign_list_screen.dart';
import 'franchise_screen.dart';
import 'product_marketing_screen.dart';
import 'personal_brand_screen.dart';
import 'ai_chat_screen.dart';
import 'home_screen.dart';
import 'influencer_list_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'analytics_screen.dart';
import 'login_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Business Owner tabs: Home | Influencers | Campaigns | Franchise | AI
  List<Widget> get _boScreens => const [
    HomeScreen(),
    InfluencerListScreen(),
    CampaignListScreen(),
    FranchiseScreen(),
    AiChatScreen(),
  ];

  // Influencer tabs: Home | Campaigns | My Brand | Products | AI
  List<Widget> get _infScreens => const [
    HomeScreen(),
    CampaignListScreen(),
    PersonalBrandScreen(),
    ProductMarketingScreen(),
    AiChatScreen(),
  ];

  // Business Owner nav items
  static const _boItems = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(Icons.people_outline, Icons.people_rounded, 'Influencers'),
    _NavItem(Icons.campaign_outlined, Icons.campaign_rounded, 'Campaigns', isCenter: true),
    _NavItem(Icons.store_outlined, Icons.store_rounded, 'Franchise'),
    _NavItem(Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'AI'),
  ];

  // Influencer nav items
  static const _infItems = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(Icons.search_outlined, Icons.search_rounded, 'Campaigns', isCenter: true),
    _NavItem(Icons.person_outline, Icons.person_rounded, 'My Brand'),
    _NavItem(Icons.inventory_2_outlined, Icons.inventory_2_rounded, 'Products'),
    _NavItem(Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'AI'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final isBO = provider.isBusinessOwner;
    final unread = provider.unreadCount;
    final user = provider.currentUser;

    // Role-specific color accent
    final accent = isBO ? const Color(0xFF5C6BC0) : const Color(0xFFAB47BC);
    final gradient = isBO ? AppColors.gradientPrimary : const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)]);

    final screens = isBO ? _boScreens : _infScreens;
    final items = isBO ? _boItems : _infItems;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2746) : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final item = items[i];
                if (item.isCenter) {
                  return _buildCenterTab(i, item, gradient, isDark);
                }
                return _buildTab(i, item, accent, isDark, unread);
              }),
            ),
          ),
        ),
      ),
      // Drawer
      endDrawer: _buildDrawer(context, provider, user, isDark, isBO, accent, gradient, unread),
    );
  }

  Widget _buildTab(int idx, _NavItem item, Color accent, bool isDark, int unread) {
    final isActive = _currentIndex == idx;
    final showBadge = idx == 0 && unread > 0; // home tab badge
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = idx),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? accent.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(isActive ? item.filledIcon : item.outlineIcon,
              color: isActive ? accent : (isDark ? Colors.white38 : Colors.black38), size: 24),
            if (showBadge)
              Positioned(right: -4, top: -4, child: Container(
                width: 14, height: 14,
                decoration: const BoxDecoration(color: Color(0xFFFF6B6B), shape: BoxShape.circle),
                child: Center(child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
              )),
          ]),
          const SizedBox(height: 2),
          Text(item.label, style: TextStyle(fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
            color: isActive ? accent : (isDark ? Colors.white38 : Colors.black38))),
        ]),
      ),
    );
  }

  Widget _buildCenterTab(int idx, _NavItem item, LinearGradient gradient, bool isDark) {
    final isActive = _currentIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = idx),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 56 : 50, height: isActive ? 56 : 50,
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: gradient.colors.first.withOpacity(0.45), blurRadius: isActive ? 16 : 10, offset: const Offset(0, 4))],
          ),
          child: Icon(isActive ? item.filledIcon : item.outlineIcon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 2),
        Text(item.label, style: TextStyle(fontSize: 10,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
          color: isActive ? gradient.colors.first : (isDark ? Colors.white38 : Colors.black38))),
      ]),
    );
  }

  Widget _buildDrawer(BuildContext ctx, AppProvider provider, AppUser? user, bool isDark, bool isBO, Color accent, LinearGradient gradient, int unread) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // User header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: gradient),
              child: Row(children: [
                CircleAvatar(radius: 28, backgroundImage: NetworkImage(user?.avatarUrl ?? 'https://i.pravatar.cc/100'),
                  onBackgroundImageError: (_, __) {}, backgroundColor: Colors.white24),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user?.name ?? 'User', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  Text(isBO ? (user?.company ?? 'Business Owner') : (user?.niche ?? 'Influencer'),
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: Text(isBO ? '🏢 Business Owner' : '📸 Influencer',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ])),
              ]),
            ),

            const SizedBox(height: 8),
            _drawerTile(Icons.notifications_outlined, 'Notifications', isDark, accent,
              badge: unread > 0 ? '$unread' : null,
              onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NotificationsScreen())); }),

            if (isBO)
              _drawerTile(Icons.inventory_2_outlined, 'Products', isDark, accent,
                onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ProductMarketingScreen())); })
            else
              _drawerTile(Icons.store_outlined, 'Franchise', isDark, accent,
                onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FranchiseScreen())); }),

            _drawerTile(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              isDark ? 'Light Mode' : 'Dark Mode', isDark, accent,
              onTap: () { Navigator.pop(ctx); provider.toggleTheme(); }),

            _drawerTile(Icons.bar_chart_rounded, 'Analytics', isDark, accent,
              onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AnalyticsDashboardScreen())); }),

            _drawerTile(Icons.settings_outlined, 'Settings', isDark, accent,
              onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SettingsScreen())); }),

            const Spacer(),

            // Switch Role
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accent.withOpacity(0.2)),
                  ),
                  child: Row(children: [
                    Icon(Icons.swap_horiz_rounded, color: accent, size: 20),
                    const SizedBox(width: 10),
                    Text('Switch Role', style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 14)),
                  ]),
                ),
              ),
            ),

            // Logout
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: GestureDetector(
                onTap: () async {
                  await AuthService.clearSession();
                  provider.logout();
                  Navigator.pushNamedAndRemoveUntil(ctx, '/login', (_) => false);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                    SizedBox(width: 10),
                    Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 14)),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String label, bool isDark, Color accent, {String? badge, VoidCallback? onTap}) {
    return ListTile(
      leading: Stack(clipBehavior: Clip.none, children: [
        Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
        if (badge != null)
          Positioned(right: -4, top: -4, child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: Color(0xFFFF6B6B), shape: BoxShape.circle),
            child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)))),
      ]),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
        color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
      onTap: onTap,
    );
  }
}

class _NavItem {
  final IconData outlineIcon;
  final IconData filledIcon;
  final String label;
  final bool isCenter;
  const _NavItem(this.outlineIcon, this.filledIcon, this.label, {this.isCenter = false});
}
