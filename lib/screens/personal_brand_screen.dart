import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/personal_brand_model.dart';
import '../widgets/gradient_button.dart';

class PersonalBrandScreen extends StatelessWidget {
  const PersonalBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final brand = provider.personalBrand;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF3949AB),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => _showEditSheet(context, provider, brand, isDark)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.gradientHero),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 40),
                  CircleAvatar(radius: 44, backgroundImage: NetworkImage(brand.avatarUrl),
                    onBackgroundImageError: (_, __) {}, backgroundColor: Colors.white24),
                  const SizedBox(height: 10),
                  Text(brand.displayName, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                  Text(brand.tagline, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.email_outlined, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(brand.contactEmail, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ]),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF1E2746) : Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('About Me', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                  const SizedBox(height: 8),
                  Text(brand.bio, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, height: 1.6)),
                  const SizedBox(height: 12),
                  Row(children: brand.socialLinks.map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF5C6BC0).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text(s.platform, style: const TextStyle(color: Color(0xFF5C6BC0), fontWeight: FontWeight.w600, fontSize: 11)),
                    ),
                  )).toList()),
                ]),
              ),
              const SizedBox(height: 16),
              Text('Services', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              ...brand.services.map((s) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF1E2746) : Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(gradient: AppColors.gradientPrimary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.star, color: Colors.white, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                    Text(s.description, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                  ])),
                  Text('₹${(s.price / 1000).toStringAsFixed(0)}K', style: const TextStyle(color: Color(0xFF5C6BC0), fontWeight: FontWeight.w800, fontSize: 14)),
                ]),
              )),
              const SizedBox(height: 16),
              Text('Portfolio', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.2,
                children: brand.portfolioItems.map((p) => ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(fit: StackFit.expand, children: [
                    Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF5C6BC0).withOpacity(0.2), child: const Icon(Icons.image, color: Color(0xFF5C6BC0)))),
                    Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.7)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
                    Positioned(bottom: 10, left: 10, right: 10, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(p.description, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    ])),
                  ]),
                )).toList(),
              ),
              const SizedBox(height: 20),
              GradientButton(label: 'Contact Me', icon: Icons.email_rounded, onPressed: () =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening ${brand.contactEmail}...'), backgroundColor: const Color(0xFF5C6BC0)))),
              const SizedBox(height: 80),
            ])),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, AppProvider provider, PersonalBrand brand, bool isDark) {
    final nameCtrl = TextEditingController(text: brand.displayName);
    final taglineCtrl = TextEditingController(text: brand.tagline);
    final bioCtrl = TextEditingController(text: brand.bio);
    final emailCtrl = TextEditingController(text: brand.contactEmail);

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
            Text('Edit Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            const SizedBox(height: 16),
            for (final item in [
              [nameCtrl, 'Display Name', Icons.person],
              [taglineCtrl, 'Tagline', Icons.format_quote],
              [bioCtrl, 'Bio', Icons.info_outline],
              [emailCtrl, 'Contact Email', Icons.email],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: item[0] as TextEditingController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  maxLines: item[1] == 'Bio' ? 3 : 1,
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
              label: 'Save Profile',
              icon: Icons.save_rounded,
              onPressed: () {
                provider.updatePersonalBrand(brand.copyWith(
                  displayName: nameCtrl.text.trim(),
                  tagline: taglineCtrl.text.trim(),
                  bio: bioCtrl.text.trim(),
                  contactEmail: emailCtrl.text.trim(),
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated! ✅'), backgroundColor: Color(0xFF5C6BC0)));
              }),
          ])),
        ),
      ),
    );
  }
}
