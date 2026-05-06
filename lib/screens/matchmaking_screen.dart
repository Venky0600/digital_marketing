import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/app_widgets.dart';
import '../widgets/gradient_button.dart';

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final influencers = provider.influencers;
    final campaigns = provider.campaigns;

    // Generate mock match scores
    final influencerMatches = influencers.take(4).toList().asMap().entries.map((e) {
      final matchScores = [92, 87, 79, 74];
      final reasons = [
        'High engagement rate + niche aligns with top campaigns',
        'Large follower base + proven brand collaborations',
        'Perfect niche match for 3 active campaigns',
        'Competitive pricing + strong audience demographics',
      ];
      return _MatchData(
        name: e.value.name,
        imageUrl: e.value.profileImageUrl,
        matchPercent: matchScores[e.key],
        reason: reasons[e.key],
        type: MatchType.influencerToCampaign,
      );
    }).toList();

    final campaignMatches = campaigns.take(3).toList().asMap().entries.map((e) {
      final matchScores = [94, 85, 77];
      final reasons = [
        'Budget aligns with top micro-influencers in niche',
        'Target audience overlaps with 5 verified influencers',
        'Campaign type is trending — high response rate expected',
      ];
      return _MatchData(
        name: e.value.title,
        imageUrl: e.value.logoUrl,
        matchPercent: matchScores[e.key],
        reason: reasons[e.key],
        type: MatchType.campaignToInfluencer,
      );
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        title: Text('AI Matchmaking', style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.gradientHero, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const Text('🤖', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('AI Match Engine', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                Text('Analyzes 12+ data points to find your perfect matches', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 24),

          Text('🌟 Best Influencers for Campaigns', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          ...influencerMatches.map((m) => MatchCard(
            name: m.name,
            imageUrl: m.imageUrl,
            matchPercent: m.matchPercent,
            reason: m.reason,
            actionLabel: 'View Profile',
            onAction: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${m.name}\'s profile...'), backgroundColor: const Color(0xFF5C6BC0))),
            accentColor: const Color(0xFF5C6BC0),
          )),

          const SizedBox(height: 24),

          Text('📣 Best Campaigns for Influencers', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          ...campaignMatches.map((m) => MatchCard(
            name: m.name,
            imageUrl: m.imageUrl,
            matchPercent: m.matchPercent,
            reason: m.reason,
            actionLabel: 'Apply Now',
            onAction: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Applied to ${m.name}!'), backgroundColor: const Color(0xFFFF6B6B))),
            accentColor: const Color(0xFFFF6B6B),
          )),

          const SizedBox(height: 24),
          GradientButton(
            label: 'Run New AI Analysis',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Analysis complete! ✅ Matches updated.'), backgroundColor: Color(0xFF4CAF50))),
            icon: Icons.auto_awesome,
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }
}

enum MatchType { influencerToCampaign, campaignToInfluencer }

class _MatchData {
  final String name;
  final String imageUrl;
  final int matchPercent;
  final String reason;
  final MatchType type;
  const _MatchData({required this.name, required this.imageUrl, required this.matchPercent, required this.reason, required this.type});
}
