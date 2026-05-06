import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/campaign_model.dart';
import '../widgets/gradient_button.dart';
import 'campaign_form_screen.dart';

class CampaignDetailScreen extends StatelessWidget {
  final Campaign campaign;
  const CampaignDetailScreen({super.key, required this.campaign});

  Color get _statusColor {
    switch (campaign.status) {
      case CampaignStatus.open: return const Color(0xFF4CAF50);
      case CampaignStatus.inProgress: return const Color(0xFFFFB347);
      case CampaignStatus.completed: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF3949AB),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CampaignFormScreen(campaign: campaign)))),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(
                  colors: [Color(0xFF3949AB), Color(0xFFFF6B6B)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(campaign.logoUrl, width: 80, height: 80, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 80, height: 80,
                        color: Colors.white24, child: const Icon(Icons.business, color: Colors.white, size: 36))),
                  ),
                  const SizedBox(height: 10),
                  Text(campaign.businessName, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                  Text(campaign.category, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ])),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(campaign.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 22,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 12),
                Row(children: [
                  _stat('Budget', campaign.budgetFormatted, Icons.account_balance_wallet, const Color(0xFF5C6BC0), isDark),
                  const SizedBox(width: 10),
                  _stat('Applicants', '${campaign.applicants}', Icons.people, const Color(0xFFFF6B6B), isDark),
                  const SizedBox(width: 10),
                  _stat('Status', campaign.status.displayName, Icons.info_outline, _statusColor, isDark),
                ]),
                const SizedBox(height: 16),
                _infoTile('Campaign Type', campaign.campaignType.displayName, isDark),
                _infoTile('Target Audience', campaign.targetAudience, isDark),
                _infoTile('Required Niche', campaign.requiredNiche, isDark),
                _infoTile('Location', campaign.location, isDark),
                const SizedBox(height: 16),
                Text('About This Campaign', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2746) : Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                  child: Text(campaign.description, style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54, height: 1.6)),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: campaign.status == CampaignStatus.open ? '🚀 Apply Now' : 'Campaign ${campaign.status.displayName}',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Application submitted! ✅'), backgroundColor: Color(0xFF5C6BC0))),
                  gradient: campaign.status == CampaignStatus.open ? AppColors.gradientAccent : const LinearGradient(colors: [Colors.grey, Colors.grey]),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF1A1A2E), fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ]),
    ));
  }

  Widget _infoTile(String label, String value, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white70 : Colors.black54)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
      ]),
    );
  }
}
