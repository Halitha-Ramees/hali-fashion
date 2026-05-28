import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        children: [
          // Background radial gold glows
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.25,
            right: -MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,
            left: -MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.03),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _AppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Heading
                        Text(
                          'Create Account',
                          style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF5F5F0),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join the Kali experience',
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Full Name
                        _FieldLabel(label: 'Full Name'),
                        const SizedBox(height: 8),
                        _BottomBorderField(
                          controller: _nameController,
                          hint: 'Enter your full name',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 24),

                        // Email
                        _FieldLabel(label: 'Email'),
                        const SizedBox(height: 8),
                        _BottomBorderField(
                          controller: _emailController,
                          hint: 'email@address.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),

                        // Password
                        _FieldLabel(label: 'Password'),
                        const SizedBox(height: 8),
                        _BottomBorderField(
                          controller: _passwordController,
                          hint: '********',
                          obscureText: _obscurePassword,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Confirm Password
                        _FieldLabel(label: 'Confirm Password'),
                        const SizedBox(height: 8),
                        _BottomBorderField(
                          controller: _confirmController,
                          hint: '********',
                          obscureText: _obscureConfirm,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                            child: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        if (_errorText != null) ...[
                          _AuthMessage(text: _errorText!, isError: true),
                          const SizedBox(height: 18),
                        ],

                        // REGISTER button — gold gradient
                        _GradientButton(
                          label: _isLoading
                              ? 'CREATING ACCOUNT...'
                              : 'REGISTER',
                          onTap: _isLoading ? () {} : () => _register(context),
                        ),
                        const SizedBox(height: 24),

                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text(
                                'Login',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Branding element
                        const SizedBox(height: 64),
                        const _KLogo(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() => _errorText = null);

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _errorText = 'Please fill all fields.');
      return;
    }

    if (password != confirm) {
      setState(() => _errorText = 'Passwords do not match.');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorText = 'Password must be at least 6 characters.');
      return;
    }

    final userProvider = context.read<UserProvider>();
    final router = GoRouter.of(context);

    setState(() => _isLoading = true);
    try {
      await userProvider.registerWithEmail(
        fullName: name,
        email: email,
        password: password,
      );
      if (!mounted) return;
      router.go('/main');
    } on firebase_auth.FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() => _errorText = _authErrorMessage(error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorText = 'Registration failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _authErrorMessage(firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Enable Email/Password sign-in in Firebase Authentication.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'firebase-not-initialized':
        return 'Firebase is not initialized for this platform.';
      default:
        return error.message ?? 'Registration failed. Please try again.';
    }
  }
}

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.onSurface,
                  size: 24,
                ),
                onPressed: () => context.go('/login'),
              ),
            ),
            Text(
              'KALI FASHION',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 16 * 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom-border-only field ─────────────────────────────────────────────────

class _BottomBorderField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const _BottomBorderField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.raleway(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
          fontSize: 14,
          color: AppColors.onSurface.withValues(alpha: 0.3),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.raleway(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 10 * 0.1,
        ),
      ),
    );
  }
}

// ─── Gold Gradient Button ─────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onPrimary,
              letterSpacing: 13 * 0.15,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── K Logo Branding ──────────────────────────────────────────────────────────

class _AuthMessage extends StatelessWidget {
  final String text;
  final bool isError;

  const _AuthMessage({required this.text, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isError
            ? const Color(0xFF3A1515)
            : AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? const Color(0xFF8A2C2C)
              : AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isError ? const Color(0xFFFFC7C7) : AppColors.primary,
          height: 1.35,
        ),
      ),
    );
  }
}

class _KLogo extends StatelessWidget {
  const _KLogo();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.20,
      child: Column(
        children: [
          Container(width: 64, height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 24),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                // Inner circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                // K letter
                Text(
                  'K',
                  style: GoogleFonts.raleway(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
