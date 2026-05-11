import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  Map<String, dynamic>? _overview;
  List<dynamic> _topInfluencers = [];
  List<dynamic> _campaignStatus = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _fetchData();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> _fetchData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final headers = await _headers();
      final base = ApiService.baseUrl;

      final responses = await Future.wait([
        http.get(Uri.parse('$base/analytics/overview'),       headers: headers),
        http.get(Uri.parse('$base/analytics/top-influencers'),headers: headers),
        http.get(Uri.parse('$base/analytics/campaign-status'),headers: headers),
      ]);

      if (!mounted) return;
      setState(() {
        if (responses[0].statusCode == 200)
          _overview = json.decode(responses[0].body);
        if (responses[1].statusCode == 200)
          _topInfluencers = json.decode(responses[1].body);
        if (responses[2].statusCode == 200)
          _campaignStatus = json.decode(responses[2].body);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    final bg     = isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Analytics Dashboard',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchData,
            tooltip: 'Refresh',
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError(isDark)
              : RefreshIndicator(
                  onRefresh: _fetchData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Overview', isDark),
                        const SizedBox(height: 12),
                        _buildStatsGrid(isDark),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Campaign Status', isDark),
                        const SizedBox(height: 12),
                        _buildCampaignStatus(isDark),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Top Influencers', isDark),
                        const SizedBox(height: 12),
                        _buildTopInfluencers(isDark),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildError(bool isDark) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.red),
        const SizedBox(height: 12),
        Text('Failed to load analytics', style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 16,
            color: isDark ? Colors.white70 : Colors.black54)),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _fetchData,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ]),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(title, style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700, fontSize: 18,
        color: isDark ? Colors.white : const Color(0xFF1A1A2E)));
  }

  Widget _buildStatsGrid(bool isDark) {
    final stats = [
      _StatCard(label: 'Total Users',      value: '${_overview?['totalUsers'] ?? 0}',      icon: Icons.people_rounded,           gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)])),
      _StatCard(label: 'Campaigns',        value: '${_overview?['totalCampaigns'] ?? 0}',   icon: Icons.campaign_rounded,          gradient: const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)])),
      _StatCard(label: 'Influencers',      value: '${_overview?['totalInfluencers'] ?? 0}', icon: Icons.star_rounded,              gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFEE4444)])),
      _StatCard(label: 'Franchises',       value: '${_overview?['totalFranchises'] ?? 0}',  icon: Icons.store_rounded,             gradient: const LinearGradient(colors: [Color(0xFF26C6DA), Color(0xFF00838F)])),
      _StatCard(label: 'Chat Messages',    value: '${_overview?['totalMessages'] ?? 0}',    icon: Icons.chat_bubble_rounded,       gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF388E3C)])),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12,
        mainAxisSpacing: 12, childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) {
        final delay = i * 0.1;
        return AnimatedBuilder(
          animation: _animCtrl,
          builder: (_, child) {
            final t = ((_animCtrl.value - delay).clamp(0.0, 1.0));
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - t)), child: child),
            );
          },
          child: _buildStatCard(stats[i], isDark),
        );
      },
    );
  }

  Widget _buildStatCard(_StatCard s, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: s.gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(
            color: s.gradient.colors.first.withOpacity(0.3),
            blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(s.icon, color: Colors.white70, size: 22),
          const SizedBox(height: 8),
          Text(s.value, style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 26)),
          Text(s.label, style: const TextStyle(
              color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCampaignStatus(bool isDark) {
    if (_campaignStatus.isEmpty) {
      return _emptyState('No campaign data', isDark);
    }

    final colors = [
      const Color(0xFF66BB6A), const Color(0xFF5C6BC0), const Color(0xFFFF6B6B)
    ];
    final total  = _campaignStatus.fold<int>(0, (s, e) => s + (e['count'] as int));

    return Column(
      children: _campaignStatus.asMap().entries.map((entry) {
        final i    = entry.key;
        final item = entry.value;
        final pct  = total > 0 ? (item['count'] as int) / total : 0.0;
        final color = colors[i % colors.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${item['_id'] ?? 'Unknown'}',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                Text('${item['count']}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                        color: color)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? const Color(0xFF1E2746) : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopInfluencers(bool isDark) {
    if (_topInfluencers.isEmpty) {
      return _emptyState('No influencer data yet', isDark);
    }

    return Column(
      children: _topInfluencers.map((inf) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2746) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: inf['profileImageUrl'] != null
                  ? NetworkImage(inf['profileImageUrl'])
                  : null,
              backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.2),
              child: inf['profileImageUrl'] == null
                  ? Text(inf['name']?[0] ?? '?',
                      style: const TextStyle(
                          color: Color(0xFF5C6BC0), fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${inf['name']}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              Text('${inf['niche'] ?? ''} • ${inf['platform'] ?? ''}',
                  style: TextStyle(fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.black45)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${_formatNum(inf['followers'] ?? 0)}',
                  style: const TextStyle(fontWeight: FontWeight.w700,
                      color: Color(0xFF5C6BC0), fontSize: 14)),
              const Text('followers',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ]),
          ]),
        );
      }).toList(),
    );
  }

  Widget _emptyState(String msg, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(msg, style: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38, fontSize: 13)),
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000)    return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _StatCard {
  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  const _StatCard({required this.label, required this.value,
      required this.icon, required this.gradient});
}
