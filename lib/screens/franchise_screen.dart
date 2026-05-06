import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/franchise_model.dart';
import '../widgets/gradient_button.dart';

class FranchiseScreen extends StatelessWidget {
  const FranchiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final franchises = provider.franchises;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Franchise Opportunities', style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF5C6BC0)),
            onPressed: () => _showAddFranchise(context, provider, isDark)),
        ],
      ),
      body: franchises.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🏪', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('No Franchises Yet', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              Text('Add franchise opportunities for investors.', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: franchises.length,
              itemBuilder: (_, i) => _FranchiseCard(franchise: franchises[i], isDark: isDark,
                onDelete: () => provider.deleteFranchise(franchises[i].id)),
            ),
    );
  }

  void _showAddFranchise(BuildContext context, AppProvider provider, bool isDark) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final investCtrl = TextEditingController();
    final profitCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2746) : Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Add Franchise', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            const SizedBox(height: 16),
            for (final item in [
              [nameCtrl, 'Brand Name', Icons.business],
              [descCtrl, 'Description', Icons.description],
              [investCtrl, 'Investment Required (₹)', Icons.account_balance_wallet],
              [profitCtrl, 'Expected Monthly Profit (₹)', Icons.trending_up],
              [locationCtrl, 'Location Availability', Icons.location_on],
              [emailCtrl, 'Contact Email', Icons.email],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: item[0] as TextEditingController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: item[1] as String,
                    labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                    prefixIcon: Icon(item[2] as IconData, color: const Color(0xFF5C6BC0), size: 20),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                ),
              ),
            GradientButton(
              label: 'Add Franchise',
              icon: Icons.store,
              onPressed: () {
                if (nameCtrl.text.isEmpty) return;
                provider.addFranchise(Franchise(
                  id: provider.generateId(),
                  brandName: nameCtrl.text.trim(),
                  imageUrl: 'https://picsum.photos/seed/${nameCtrl.text.trim().hashCode}/400/250',
                  investmentRequired: double.tryParse(investCtrl.text.trim()) ?? 0,
                  expectedProfit: double.tryParse(profitCtrl.text.trim()) ?? 0,
                  locationAvailability: locationCtrl.text.trim(),
                  category: 'Business',
                  supportProvided: ['Training', 'Marketing', 'Operations'],
                  contactEmail: emailCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  established: DateTime.now().year,
                  totalOutlets: 1,
                  createdAt: DateTime.now(),
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Franchise added! 🏪'), backgroundColor: Color(0xFF5C6BC0)));
              }),
          ])),
        ),
      ),
    );
  }
}

class _FranchiseCard extends StatelessWidget {
  final Franchise franchise;
  final bool isDark;
  final VoidCallback onDelete;

  const _FranchiseCard({required this.franchise, required this.isDark, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Image.network(franchise.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: 160, color: const Color(0xFF5C6BC0).withOpacity(0.2),
              child: const Center(child: Icon(Icons.store, size: 48, color: Color(0xFF5C6BC0))))),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(franchise.brandName, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E)))),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: onDelete),
            ]),
            Text(franchise.category, style: const TextStyle(color: Color(0xFF5C6BC0), fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(children: [
              _stat('Investment', franchise.investmentFormatted, const Color(0xFF5C6BC0), isDark),
              const SizedBox(width: 10),
              _stat('Profit/mo', franchise.profitFormatted, const Color(0xFF4CAF50), isDark),
              const SizedBox(width: 10),
              _stat('Outlets', '${franchise.totalOutlets}+', const Color(0xFFFFB347), isDark),
            ]),
            const SizedBox(height: 10),
            Text(franchise.description, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45, height: 1.5)),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: franchise.supportProvided.map((s) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF5C6BC0).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(s, style: const TextStyle(fontSize: 11, color: Color(0xFF5C6BC0), fontWeight: FontWeight.w600)),
              )).toList()),
            const SizedBox(height: 12),
            GradientButton(label: 'Enquire Now', icon: Icons.send, onPressed: () =>
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Enquiry sent to ${franchise.brandName}! 📩'),
                backgroundColor: const Color(0xFF5C6BC0)))),
          ]),
        ),
      ]),
    );
  }

  Widget _stat(String label, String value, Color color, bool isDark) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ]),
    ));
  }
}
