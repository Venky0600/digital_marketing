import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/influencer_model.dart';
import '../widgets/gradient_button.dart';
import 'influencer_form_screen.dart';
import 'mock_chat_screen.dart';

class InfluencerDetailScreen extends StatelessWidget {
  final Influencer influencer;
  const InfluencerDetailScreen({super.key, required this.influencer});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF3949AB),
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InfluencerFormScreen(influencer: influencer)))),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.gradientHero),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 40),
                  Stack(children: [
                    CircleAvatar(radius: 52, backgroundImage: NetworkImage(influencer.profileImageUrl), onBackgroundImageError: (_, __) {}, backgroundColor: Colors.white24),
                    if (influencer.isVerified)
                      Positioned(bottom: 4, right: 4, child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.verified, color: Color(0xFF5C6BC0), size: 18))),
                  ]),
                  const SizedBox(height: 12),
                  Text(influencer.name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
                  Text('${influencer.niche} • ${influencer.location}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(influencer.platform.icon, style: const TextStyle(fontSize: 20)),
                ]),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Row(children: [
                _stat('Followers', influencer.followersFormatted, const Color(0xFF5C6BC0), isDark),
                const SizedBox(width: 8),
                _stat('Engagement', '${influencer.engagementRate}%', const Color(0xFF26C6DA), isDark),
                const SizedBox(width: 8),
                _stat('Rating', '⭐ ${influencer.rating}', const Color(0xFFFFB347), isDark),
                const SizedBox(width: 8),
                _stat('Per Post', '₹${(influencer.pricePerPromotion / 1000).toStringAsFixed(0)}K', const Color(0xFFFF6B6B), isDark),
              ]),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF1E2746) : Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('About', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                  const SizedBox(height: 8),
                  Text(influencer.bio, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, height: 1.6)),
                ]),
              ),
              const SizedBox(height: 12),
              if (influencer.previousWorks.isNotEmpty) ...[
                Text('Previous Collaborations', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: influencer.previousWorks.map((w) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF5C6BC0).withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF5C6BC0).withOpacity(0.3))),
                    child: Text(w, style: const TextStyle(color: Color(0xFF5C6BC0), fontWeight: FontWeight.w600, fontSize: 12)),
                  )).toList()),
                const SizedBox(height: 16),
              ],
              Row(children: [
                Expanded(child: GradientButton(label: 'Message', icon: Icons.message_rounded,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockChatScreen())))),
                const SizedBox(width: 10),
                Expanded(child: GradientButton(label: 'Collaborate', icon: Icons.handshake_rounded, gradient: AppColors.gradientAccent,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request sent! ✅'), backgroundColor: Color(0xFF4CAF50))))),
              ]),
              const SizedBox(height: 40),
            ])),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color, bool isDark) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E2746) : Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ]),
    ));
  }
}
