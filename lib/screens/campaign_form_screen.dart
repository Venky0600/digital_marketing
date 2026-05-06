import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/campaign_model.dart';
import '../widgets/gradient_button.dart';

class CampaignFormScreen extends StatefulWidget {
  final Campaign? campaign;
  const CampaignFormScreen({super.key, this.campaign});

  @override
  State<CampaignFormScreen> createState() => _CampaignFormScreenState();
}

class _CampaignFormScreenState extends State<CampaignFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _business;
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late final TextEditingController _location;
  late final TextEditingController _budget;
  late final TextEditingController _audience;
  late final TextEditingController _niche;
  CampaignType _type = CampaignType.brandAwareness;
  CampaignStatus _status = CampaignStatus.open;

  bool get isEditing => widget.campaign != null;

  @override
  void initState() {
    super.initState();
    final c = widget.campaign;
    _business = TextEditingController(text: c?.businessName ?? '');
    _title = TextEditingController(text: c?.title ?? '');
    _desc = TextEditingController(text: c?.description ?? '');
    _location = TextEditingController(text: c?.location ?? '');
    _budget = TextEditingController(text: c?.budget.toStringAsFixed(0) ?? '');
    _audience = TextEditingController(text: c?.targetAudience ?? '');
    _niche = TextEditingController(text: c?.requiredNiche ?? '');
    if (c != null) { _type = c.campaignType; _status = c.status; }
  }

  @override
  void dispose() {
    for (final c in [_business, _title, _desc, _location, _budget, _audience, _niche]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AppProvider>();
    final campaign = Campaign(
      id: isEditing ? widget.campaign!.id : provider.generateId(),
      businessName: _business.text.trim(),
      logoUrl: 'https://picsum.photos/seed/${_business.text.trim().replaceAll(' ', '')}/200',
      category: _niche.text.trim(),
      title: _title.text.trim(),
      description: _desc.text.trim(),
      location: _location.text.trim(),
      budget: double.tryParse(_budget.text.trim()) ?? 0,
      targetAudience: _audience.text.trim(),
      campaignType: _type,
      requiredNiche: _niche.text.trim(),
      status: _status,
      createdAt: isEditing ? widget.campaign!.createdAt : DateTime.now(),
      applicants: isEditing ? widget.campaign!.applicants : 0,
    );
    isEditing ? provider.updateCampaign(campaign) : provider.addCampaign(campaign);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isEditing ? 'Campaign updated!' : 'Campaign posted! 🎉'),
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
        title: Text(isEditing ? 'Edit Campaign' : 'Post Campaign',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_business, 'Business Name', Icons.business, isDark, required: true),
            _field(_title, 'Campaign Title', Icons.campaign, isDark, required: true),
            _field(_desc, 'Description', Icons.description, isDark, maxLines: 4, required: true),
            _field(_location, 'Location', Icons.location_on, isDark),
            _field(_budget, 'Budget (₹)', Icons.account_balance_wallet, isDark, keyboardType: TextInputType.number),
            _field(_audience, 'Target Audience', Icons.people, isDark),
            _field(_niche, 'Required Niche', Icons.category, isDark),
            const SizedBox(height: 8),
            Text('Campaign Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: CampaignType.values.map((t) {
              final sel = _type == t;
              return GestureDetector(
                onTap: () => setState(() => _type = t),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? AppColors.gradientAccent : null,
                    color: sel ? null : (isDark ? const Color(0xFF1E2746) : Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    border: sel ? null : Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Text(t.displayName, style: TextStyle(color: sel ? Colors.white : (isDark ? Colors.white60 : Colors.black54), fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.normal)),
                ),
              );
            }).toList()),
            const SizedBox(height: 16),
            Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: CampaignStatus.values.map((s) {
              final sel = _status == s;
              return GestureDetector(
                onTap: () => setState(() => _status = s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFF5C6BC0) : (isDark ? const Color(0xFF1E2746) : Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    border: sel ? null : Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Text(s.displayName, style: TextStyle(color: sel ? Colors.white : (isDark ? Colors.white60 : Colors.black54), fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.normal)),
                ),
              );
            }).toList()),
            const SizedBox(height: 24),
            GradientButton(
              label: isEditing ? 'Update Campaign' : 'Post Campaign',
              onPressed: _save,
              gradient: AppColors.gradientAccent,
              icon: isEditing ? Icons.save_rounded : Icons.campaign_rounded,
            ),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
