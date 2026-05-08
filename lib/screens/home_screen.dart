import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/app_provider.dart';
import '../models/campaign_model.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_card.dart';
import 'matchmaking_screen.dart';
import 'notifications_screen.dart';
import 'mock_chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final unread = provider.unreadCount;
    final isBO = provider.isBusinessOwner;
    final user = provider.currentUser;

    final gradient = isBO
        ? AppColors.gradientPrimary
        : const LinearGradient(
            colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
          );

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor:
                isBO ? const Color(0xFF3949AB) : const Color(0xFF7B1FA2),
            automaticallyImplyLeading: false,

            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),

                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 26,
                    ),

                    if (unread > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                ),
              ),

              const SizedBox(width: 4),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                ),

                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      isBO
                          ? 'Business Dashboard 🏢'
                          : 'Creator Hub 📸',

                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    Text(
                      user?.name ?? 'Welcome!',

                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      isBO
                          ? 'Manage campaigns & find influencers'
                          : 'Discover campaigns & grow your brand',

                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),

            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // TOP CARDS
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        label: 'Influencers',
                        value: '${provider.influencers.length}',
                        icon: Icons.people_rounded,
                        color: const Color(0xFF5C6BC0),
                        trend: '+2 this week',
                        isDark: isDark,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: StatsCard(
                        label: 'Campaigns',
                        value: '${provider.campaigns.length}',
                        icon: Icons.campaign_rounded,
                        color: const Color(0xFFFF6B6B),
                        trend: '${provider.activeCampaigns} active',
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

       
                Row(
                  children: [
                    Container(
                      child: Expanded(
                        child: StatsCard(
                          label: 'Total Reach',
                          value: _formatNumber(provider.totalReach),
                          icon: Icons.bar_chart_rounded,
                          color: const Color(0xFF26C6DA),
                          trend: '+12.4%',
                          isDark: isDark,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        height: 150,
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),

                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6A11CB),
                              Color(0xFF2575FC),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,

                              children: [
                                Text(
                                  "Business Reach",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "3.1M",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "+18.2% this month",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Expanded(
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: 6,
                                  minY: 0,
                                  maxY: 6,

                                  gridData:
                                      const FlGridData(show: false),

                                  titlesData:
                                      const FlTitlesData(show: false),

                                  borderData:
                                      FlBorderData(show: false),

                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 1),
                                        FlSpot(1, 3),
                                        FlSpot(2, 2),
                                        FlSpot(3, 5),
                                        FlSpot(4, 3.8),
                                        FlSpot(5, 4.5),
                                        FlSpot(6, 5.2),
                                      ],

                                      isCurved: true,
                                      color: Colors.white,
                                      barWidth: 4,

                                      dotData:
                                          const FlDotData(show: false),

                                      belowBarData: BarAreaData(
                                        show: true,

                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.4),
                                            Colors.white.withOpacity(0.05),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // QUICK ACTIONS
                Text(
                  'Quick Actions',

                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color:
                        isDark
                            ? Colors.white
                            : const Color(0xFF1A1A2E),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _quickAction(
                      context,
                      '🤖',
                      'AI Matchmaking',
                      isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MatchmakingScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    _quickAction(
                      context,
                      '💬',
                      'Messages',
                      isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MockChatScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    _quickAction(
                      context,
                      '📊',
                      'Analytics',
                      isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Analytics coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),


const SizedBox(height: 20),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Campaigns', style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 17,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All', style: TextStyle(color: Color(0xFF5C6BC0), fontSize: 13)),
                    ),
                  ],
                ),
                ...provider.campaigns.take(3).map((c) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2746) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(c.logoUrl, width: 44, height: 44, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 44, height: 44,
                          color: const Color(0xFF5C6BC0).withOpacity(0.2),
                          child: const Icon(Icons.business, color: Color(0xFF5C6BC0)))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                      Text(c.businessName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: c.status.displayName == 'Open'
                          ? const Color(0xFF4CAF50).withOpacity(0.1)
                          : const Color(0xFFFFB347).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(c.status.displayName,
                        style: TextStyle(
                          color: c.status.displayName == 'Open' ? const Color(0xFF4CAF50) : const Color(0xFFFFB347),
                          fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                )),

                const SizedBox(height: 20),

                // Top Influencers
                Text('Top Influencers', style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 17,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.influencers.length > 6 ? 6 : provider.influencers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final inf = provider.influencers[i];
                      return Container(
                        width: 90,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E2746) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Stack(children: [
                            CircleAvatar(radius: 26, backgroundImage: NetworkImage(inf.profileImageUrl),
                              onBackgroundImageError: (_, __) {}),
                            if (inf.isVerified)
                              Positioned(bottom: 0, right: 0, child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.verified, color: Color(0xFF5C6BC0), size: 11),
                              )),
                          ]),
                          const SizedBox(height: 6),
                          Text(inf.name.split(' ').first, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11,
                            color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                          Text(inf.followersFormatted, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ]),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                GradientButton(
                  label: '🤖 Run AI Matchmaking',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchmakingScreen())),
                  icon: Icons.auto_awesome,
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(BuildContext context, String emoji, String label, bool isDark, {required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2746) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
