import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user_model.dart';
import '../widgets/gradient_button.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  UserRole? _selectedRole;
  int _step = 0; // 0 = role pick, 1 = profile setup

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController(); 
  
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _cardAnimCtrl;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _cardAnimCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _cardFade = CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut));
    _cardAnimCtrl.forward();
  }

  @override
  void dispose() {
    _cardAnimCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    setState(() => _selectedRole = role);
    _cardAnimCtrl.reset();
    _cardAnimCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _step = 1);
    });
  }

  Future<void> _login() async {
    if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter email and password');
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final roleString = _selectedRole == UserRole.businessOwner ? 'businessOwner' : 'influencer';
      final res = await ApiService.login(_emailCtrl.text.trim(), _passwordCtrl.text, roleString);
      
      if (!mounted) return;
      
      final String token = res['token'];
      final userData = res['user'];
      
      // Save token for persistent session
      await AuthService.saveToken(token, userData['id'], roleString);
      
      final provider = context.read<AppProvider>();
      
      provider.login(AppUser(
        name: userData['fullName'] ?? 'User',
        email: userData['email'] ?? _emailCtrl.text.trim(),
        avatarUrl: userData['avatarUrl'] ?? 'https://i.pravatar.cc/300',
        role: _selectedRole!,
        company: userData['company'],
        niche: userData['niche'],
      ));
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F1426), const Color(0xFF1E2746), const Color(0xFF0F1426)]
                : [const Color(0xFFF0F4FF), const Color(0xFFE8EEFF), const Color(0xFFF8F0FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _step == 0 ? _buildRolePicker(isDark) : _buildProfileSetup(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildRolePicker(bool isDark) {
    return FadeTransition(
      opacity: _cardFade,
      child: SlideTransition(
        position: _cardSlide,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientHero,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: const Color(0xFF5C6BC0).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Center(child: Text('BB', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1))),
              ),
              const SizedBox(height: 20),
              Text('Welcome to Digital_Marketing', style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 6),
              Text('Who are you?', style: TextStyle(fontSize: 15, color: isDark ? Colors.white54 : Colors.black45)),
              const SizedBox(height: 40),

              // Business Owner Card
              _RoleCard(
                role: UserRole.businessOwner,
                isSelected: _selectedRole == UserRole.businessOwner,
                isDark: isDark,
                onTap: () => _selectRole(UserRole.businessOwner),
                gradient: const LinearGradient(colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)]),
                features: const ['Post campaigns', 'Browse influencers', 'Franchise listings', 'AI matching'],
              ),
              const SizedBox(height: 16),

              // Influencer Card
              _RoleCard(
                role: UserRole.influencer,
                isSelected: _selectedRole == UserRole.influencer,
                isDark: isDark,
                onTap: () => _selectRole(UserRole.influencer),
                gradient: const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)]),
                features: const ['Discover campaigns', 'Showcase profile', 'Earn from brands', 'AI marketing help'],
              ),
              const SizedBox(height: 32),

              Text('Tap a card to continue', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
              const SizedBox(height: 32),
              
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text('Don\'t have an account? Sign Up', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A2E), fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSetup(bool isDark) {
    final isBO = _selectedRole == UserRole.businessOwner;
    final gradient = isBO
        ? const LinearGradient(colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)])
        : const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)]);
    final accent = isBO ? const Color(0xFF5C6BC0) : const Color(0xFFAB47BC);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => setState(() { _step = 0; _cardAnimCtrl.forward(from: 0); }),
            child: Row(children: [
              Icon(Icons.arrow_back_ios_new, size: 16, color: isDark ? Colors.white70 : Colors.black54),
              const SizedBox(width: 4),
              Text('Change role', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 24),

          // Header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: accent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]),
            child: Row(children: [
              Text(isBO ? '🏢' : '📸', style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(isBO ? 'Business Owner' : 'Influencer', style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                Text(isBO ? 'Find & hire top influencers' : 'Discover & apply to campaigns',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 32),

          Text('Login to your account', style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700, fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
          const SizedBox(height: 6),
          Text('Enter your credentials below', style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.black45)),
          const SizedBox(height: 24),

          _buildTextField(
            controller: _emailCtrl,
            label: 'Email Address',
            icon: Icons.email_rounded,
            accent: accent,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _passwordCtrl,
            label: 'Password',
            icon: Icons.lock_rounded,
            accent: accent,
            isDark: isDark,
            isPassword: true,
          ),
          const SizedBox(height: 32),

          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13))),
              ]),
            ),
          ],
          const SizedBox(height: 32),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GradientButton(
                  label: 'Login as ${isBO ? "Business" : "Influencer"}',
                  onPressed: _login,
                  gradient: gradient,
                  icon: Icons.arrow_forward_rounded,
                ),
          const SizedBox(height: 16),

          // What you'll see section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.15)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("What you'll have access to", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: accent)),
              const SizedBox(height: 10),
              ...(isBO
                ? ['📋 Post & manage campaigns', '👥 Browse influencer marketplace', '🤝 AI-powered influencer matching', '🏪 Franchise opportunities', '🤖 AI marketing assistant']
                : ['📣 Browse & apply to campaigns', '✨ Showcase your personal brand', '💬 Message business owners', '🛍️ Market your products', '🤖 AI content & caption ideas']
              ).map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Text(f.substring(0, 2), style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(f.substring(2), style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54)),
                ]),
              )),
            ]),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accent,
    required bool isDark,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 14),
          prefixIcon: Icon(icon, color: accent, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Role Card
// ─────────────────────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final UserRole role;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final LinearGradient gradient;
  final List<String> features;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    required this.gradient,
    required this.features,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: widget.isSelected ? widget.gradient : null,
            color: widget.isSelected ? null : (widget.isDark ? const Color(0xFF1E2746) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : (widget.isDark ? Colors.white12 : Colors.black12),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? widget.gradient.colors.first.withOpacity(0.35)
                    : Colors.black.withOpacity(0.06),
                blurRadius: widget.isSelected ? 20 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Emoji circle
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: widget.isSelected ? Colors.white.withOpacity(0.2) : widget.gradient.colors.first.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(widget.role.emoji, style: const TextStyle(fontSize: 30))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.role.displayName, style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800, fontSize: 18,
                  color: widget.isSelected ? Colors.white : (widget.isDark ? Colors.white : const Color(0xFF1A1A2E)))),
                const SizedBox(height: 4),
                Text(widget.role.tagline, style: TextStyle(
                  fontSize: 12,
                  color: widget.isSelected ? Colors.white70 : (widget.isDark ? Colors.white54 : Colors.black45),
                  height: 1.4)),
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 6, children: widget.features.map((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.isSelected ? Colors.white.withOpacity(0.2) : widget.gradient.colors.first.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(f, style: TextStyle(
                    fontSize: 10,
                    color: widget.isSelected ? Colors.white : widget.gradient.colors.first,
                    fontWeight: FontWeight.w600)),
                )).toList()),
              ])),
              // Arrow
              Icon(Icons.arrow_forward_ios_rounded,
                color: widget.isSelected ? Colors.white70 : (widget.isDark ? Colors.white38 : Colors.black38),
                size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
