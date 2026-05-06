import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/influencer_model.dart';
import '../widgets/custom_card.dart';
import '../widgets/app_widgets.dart';
import '../widgets/gradient_button.dart';
import 'influencer_form_screen.dart';
import 'influencer_detail_screen.dart';

class InfluencerListScreen extends StatefulWidget {
  const InfluencerListScreen({super.key});

  @override
  State<InfluencerListScreen> createState() => _InfluencerListScreenState();
}

class _InfluencerListScreenState extends State<InfluencerListScreen> {
  final _search = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final _filters = ['All', 'Instagram', 'YouTube', 'Facebook', 'LinkedIn', 'TikTok', 'Verified'];

  List<Influencer> _filtered(List<Influencer> all) {
    return all.where((inf) {
      final matchSearch = _searchQuery.isEmpty ||
          inf.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inf.niche.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inf.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Verified' && inf.isVerified) ||
          inf.platform.displayName == _selectedFilter;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final filtered = _filtered(provider.influencers);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Influencers', style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const InfluencerFormScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              controller: _search,
              hintText: 'Search influencers...',
              filterOptions: _filters,
              selectedFilter: _selectedFilter,
              onFilterChanged: (f) => setState(() => _selectedFilter = f),
              onSearchChanged: (q) => setState(() => _searchQuery = q),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Text('${filtered.length} influencers', style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black45, fontSize: 13)),
              ]),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const EmptyState(
                      icon: Icons.people_outline,
                      title: 'No Influencers Found',
                      message: 'Add your first influencer to get started.',
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => InfluencerCard(
                        influencer: filtered[i],
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => InfluencerDetailScreen(influencer: filtered[i]))),
                        onDelete: () => _confirmDelete(context, provider, filtered[i].id, filtered[i].name),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, AppProvider provider, String id, String name) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Influencer'),
        content: Text('Remove $name from the marketplace?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.deleteInfluencer(id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Influencer removed'), backgroundColor: Colors.redAccent));
            },
            child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
