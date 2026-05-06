import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        title: Text('Settings', style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.gradientHero,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                backgroundImage: NetworkImage(provider.personalBrand.avatarUrl),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(provider.personalBrand.displayName,
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                Text(provider.personalBrand.contactEmail,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Pro Member', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ])),
            ]),
          ),
          const SizedBox(height: 20),

          _sectionLabel('Appearance', isDark),
          _settingsTile(
            isDark: isDark,
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            iconColor: const Color(0xFF5C6BC0),
            title: 'Dark Mode',
            trailing: Switch(
              value: isDark,
              activeColor: const Color(0xFF5C6BC0),
              onChanged: (_) => provider.toggleTheme(),
            ),
          ),

          const SizedBox(height: 16),
          _sectionLabel('Data & Privacy', isDark),
          _settingsTile(
            isDark: isDark,
            icon: Icons.storage_outlined,
            iconColor: const Color(0xFF26C6DA),
            title: 'Mock Data',
            subtitle: '${provider.influencers.length} influencers · ${provider.campaigns.length} campaigns',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          _settingsTile(
            isDark: isDark,
            icon: Icons.refresh_rounded,
            iconColor: const Color(0xFF4CAF50),
            title: 'Reset to Default Data',
            subtitle: 'Restore all original mock data',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _confirmReset(context, provider),
          ),
          _settingsTile(
            isDark: isDark,
            icon: Icons.delete_outline,
            iconColor: Colors.redAccent,
            title: 'Clear All Data',
            subtitle: 'Remove all influencers, campaigns, products',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _confirmClearAll(context, provider),
          ),

          const SizedBox(height: 16),
          _sectionLabel('About', isDark),
          _settingsTile(
            isDark: isDark,
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFFFFB347),
            title: 'App Version',
            subtitle: 'BrandBridge v1.0.0',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Latest', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
          _settingsTile(
            isDark: isDark,
            icon: Icons.code_rounded,
            iconColor: const Color(0xFFAB47BC),
            title: 'Tech Stack',
            subtitle: 'Flutter · Dart · Material 3 · Provider',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          _settingsTile(
            isDark: isDark,
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF5C6BC0),
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening Privacy Policy...'))),
          ),
          _settingsTile(
            isDark: isDark,
            icon: Icons.star_outline_rounded,
            iconColor: const Color(0xFFFFB347),
            title: 'Rate This App',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thank you for rating! ⭐'))),
          ),

          const SizedBox(height: 24),

          // Stats summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2746) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Text('Your BrandBridge Stats', style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _miniStat('${provider.influencers.length}', 'Influencers', isDark),
                _miniStat('${provider.campaigns.length}', 'Campaigns', isDark),
                _miniStat('${provider.franchises.length}', 'Franchises', isDark),
                _miniStat('${provider.products.length}', 'Products', isDark),
              ]),
            ]),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label.toUpperCase(), style: TextStyle(
      fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2,
      color: isDark ? Colors.white38 : Colors.black38)),
  );

  Widget _settingsTile({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2746) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            if (subtitle != null) Text(subtitle, style: TextStyle(
              fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
          ])),
          if (trailing != null) trailing,
        ]),
      ),
    );
  }

  Widget _miniStat(String value, String label, bool isDark) => Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
      color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
    Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
  ]);

  void _confirmReset(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Mock Data'),
        content: const Text('This will restore all original demo data. Your edits will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.resetToMockData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data reset to defaults ✅'),
                  backgroundColor: Color(0xFF4CAF50)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5C6BC0)),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Data'),
        content: const Text('This will remove ALL data including influencers, campaigns, and products. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.clearNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared'), backgroundColor: Colors.redAccent));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
