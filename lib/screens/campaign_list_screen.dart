import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/campaign_model.dart';
import '../widgets/custom_card.dart';
import '../widgets/app_widgets.dart';
import '../widgets/gradient_button.dart';
import 'campaign_form_screen.dart';
import 'campaign_detail_screen.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final _search = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final _filters = ['All', 'Open', 'In Progress', 'Completed', 'Product Promotion', 'Brand Awareness'];

  List<Campaign> _filtered(List<Campaign> all) {
    return all.where((c) {
      final matchSearch = _searchQuery.isEmpty ||
          c.businessName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter = _selectedFilter == 'All' ||
          c.status.displayName == _selectedFilter ||
          c.campaignType.displayName == _selectedFilter;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final filtered = _filtered(provider.campaigns);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Campaigns', style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CampaignFormScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(gradient: AppColors.gradientAccent, borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          SearchFilterBar(
            controller: _search,
            hintText: 'Search campaigns...',
            filterOptions: _filters,
            selectedFilter: _selectedFilter,
            onFilterChanged: (f) => setState(() => _selectedFilter = f),
            onSearchChanged: (q) => setState(() => _searchQuery = q),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Text('${filtered.length} campaigns',
                style: TextStyle(color: isDark ? Colors.white60 : Colors.black45, fontSize: 13)),
            ]),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(icon: Icons.campaign_outlined, title: 'No Campaigns Found',
                    message: 'Post your first campaign to connect with influencers.')
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => CampaignCard(
                      campaign: filtered[i],
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CampaignDetailScreen(campaign: filtered[i]))),
                      onDelete: () => _confirmDelete(context, provider, filtered[i].id, filtered[i].title),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, AppProvider provider, String id, String title) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete Campaign'),
        content: Text('Remove "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () { provider.deleteCampaign(id); Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Campaign removed'), backgroundColor: Colors.redAccent));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}
