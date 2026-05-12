import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user_model.dart';
import '../widgets/gradient_button.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _extraCtrl = TextEditingController(); // Company or Niche

  UserRole _selectedRole = UserRole.businessOwner;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _extraCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill all required fields');
      return;
    }

    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await ApiService.signup(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        role: _selectedRole == UserRole.businessOwner ? 'businessOwner' : 'influencer',
        company: _selectedRole == UserRole.businessOwner ? _extraCtrl.text.trim() : null,
        niche: _selectedRole == UserRole.influencer ? _extraCtrl.text.trim() : null,
      );

      if (mounted) {
        setState(() {
          _successMessage = 'Account created successfully! You can now log in.';
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    final isBO = _selectedRole == UserRole.businessOwner;
    final gradient = isBO
        ? const LinearGradient(colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)])
        : const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)]);
    final accent = isBO ? const Color(0xFF5C6BC0) : const Color(0xFFAB47BC);

    return Scaffold(
      body: Container(
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(children: [
                    Icon(Icons.arrow_back_ios_new, size: 16, color: isDark ? Colors.white70 : Colors.black54),
                    const SizedBox(width: 4),
                    Text('Back to Login', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13)),
                  ]),
                ),
                const SizedBox(height: 24),

                Text('Create an Account', style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800, fontSize: 26,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 6),
                Text('Join BrandBridge today.', style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.black45)),
                const SizedBox(height: 32),

                // Role Toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A223A) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildRoleTab('Business', UserRole.businessOwner, isDark)),
                      Expanded(child: _buildRoleTab('Influencer', UserRole.influencer, isDark)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _buildTextField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  icon: Icons.person_rounded,
                  accent: accent,
                  isDark: isDark,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _emailCtrl,
                  label: 'Email Address',
                  icon: Icons.email_rounded,
                  accent: accent,
                  isDark: isDark,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _extraCtrl,
                  label: isBO ? 'Company / Brand Name (Optional)' : 'Your Content Niche (Optional)',
                  icon: isBO ? Icons.business_rounded : Icons.category_rounded,
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
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _confirmCtrl,
                  label: 'Confirm Password',
                  icon: Icons.lock_outline_rounded,
                  accent: accent,
                  isDark: isDark,
                  isPassword: true,
                ),
                const SizedBox(height: 32),

                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                    ]),
                  ),
                  const SizedBox(height: 24),
                ],
                
                if (_successMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_successMessage!, style: const TextStyle(color: Colors.green, fontSize: 13))),
                    ]),
                  ),
                  const SizedBox(height: 24),
                ],

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GradientButton(
                        label: 'Sign Up',
                        onPressed: _signup,
                        gradient: gradient,
                        icon: Icons.app_registration_rounded,
                      ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String text, UserRole role, bool isDark) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? (role == UserRole.businessOwner ? const Color(0xFF5C6BC0) : const Color(0xFFAB47BC))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text, style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white54 : Colors.black54),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          )),
        ),
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
