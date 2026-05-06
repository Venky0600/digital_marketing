import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/influencer_model.dart';
import '../widgets/gradient_button.dart';

class InfluencerFormScreen extends StatefulWidget {
  final Influencer? influencer;
  const InfluencerFormScreen({super.key, this.influencer});

  @override
  State<InfluencerFormScreen> createState() => _InfluencerFormScreenState();
}

class _InfluencerFormScreenState extends State<InfluencerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _bio, _niche, _location, _followers, _engagement, _price;
  InfluencerPlatform _platform = InfluencerPlatform.instagram;
  bool _verified = false;

  bool get isEditing => widget.influencer != null;

  @override
  void initState() {
    super.initState();
    final inf = widget.influencer;
    _name = TextEditingController(text: inf?.name ?? '');
    _bio = TextEditingController(text: inf?.bio ?? '');
    _niche = TextEditingController(text: inf?.niche ?? '');
    _location = TextEditingController(text: inf?.location ?? '');
    _followers = TextEditingController(text: inf?.followers.toString() ?? '');
    _engagement = TextEditingController(text: inf?.engagementRate.toString() ?? '');
    _price = TextEditingController(text: inf?.pricePerPromotion.toString() ?? '');
    if (inf != null) { _platform = inf.platform; _verified = inf.isVerified; }
  }

  @override
  void dispose() {
    for (final c in [_name, _bio, _niche, _location, _followers, _engagement, _price]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AppProvider>();
    final influencer = Influencer(
      id: isEditing ? widget.influencer!.id : provider.generateId(),
      name: _name.text.trim(),
      profileImageUrl: 'https://i.pravatar.cc/300?u=${_name.text.trim().hashCode}',
      bio: _bio.text.trim(),
      niche: _niche.text.trim(),
      location: _location.text.trim(),
      platform: _platform,
      followers: int.tryParse(_followers.text.trim()) ?? 0,
      engagementRate: double.tryParse(_engagement.text.trim()) ?? 0.0,
      pricePerPromotion: double.tryParse(_price.text.trim()) ?? 0.0,
      rating: isEditing ? widget.influencer!.rating : 4.5,
      previousWorks: isEditing ? widget.influencer!.previousWorks : [],
      isVerified: _verified,
      createdAt: isEditing ? widget.influencer!.createdAt : DateTime.now(),
    );
    isEditing ? provider.updateInfluencer(influencer) : provider.addInfluencer(influencer);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isEditing ? 'Influencer updated!' : 'Influencer added! 🎉'),
      backgroundColor: const Color(0xFF5C6BC0)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        title: Text(isEditing ? 'Edit Influencer' : 'Add Influencer',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black87), onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_name, 'Full Name', Icons.person, isDark, required: true),
            _field(_bio, 'Bio', Icons.info_outline, isDark, maxLines: 3, required: true),
            _field(_niche, 'Niche', Icons.category, isDark, required: true),
            _field(_location, 'Location', Icons.location_on, isDark),
            _field(_followers, 'Followers', Icons.people, isDark, keyboardType: TextInputType.number),
            _field(_engagement, 'Engagement Rate (%)', Icons.trending_up, isDark, keyboardType: TextInputType.number),
            _field(_price, 'Price Per Post (₹)', Icons.account_balance_wallet, isDark, keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            Text('Platform', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: InfluencerPlatform.values.map((p) {
              final sel = _platform == p;
              return GestureDetector(
                onTap: () => setState(() => _platform = p),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? AppColors.gradientPrimary : null,
                    color: sel ? null : (isDark ? const Color(0xFF1E2746) : Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    border: sel ? null : Border.all(color: isDark ? Colors.white12 : Colors.black12)),
                  child: Text('${p.icon} ${p.displayName}', style: TextStyle(color: sel ? Colors.white : (isDark ? Colors.white60 : Colors.black54), fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.normal)),
                ),
              );
            }).toList()),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: isDark ? const Color(0xFF1E2746) : Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.verified, color: Color(0xFF5C6BC0), size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text('Verified Influencer', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A1A2E)))),
                Switch(value: _verified, onChanged: (v) => setState(() => _verified = v), activeColor: const Color(0xFF5C6BC0)),
              ]),
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: isEditing ? 'Update Influencer' : 'Add Influencer',
              onPressed: _save,
              icon: isEditing ? Icons.save_rounded : Icons.person_add_rounded),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, bool isDark,
      {int maxLines = 1, TextInputType? keyboardType, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        validator: required ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
          prefixIcon: Icon(icon, color: const Color(0xFF5C6BC0), size: 20),
          filled: true,
          fillColor: isDark ? const Color(0xFF1E2746) : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      ),
    );
  }
}
