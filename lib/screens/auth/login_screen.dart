import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _messageText;
  bool _messageIsError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Radial gold glow — top right
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Radial gold glow — bottom left
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ───────────────────────────────────────────
                  Column(
                    children: [
                      Text(
                        'KALI FASHION',
                        style: GoogleFonts.raleway(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 28 * 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 1,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF5F5F0),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to continue',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // ── Email ─────────────────────────────────────────────
                  _FieldLabel('Email Address'),
                  const SizedBox(height: 8),
                  _DarkInputField(
                    controller: _emailController,
                    hint: 'name@example.com',
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icon(
                      Icons.mail_outline,
                      size: 18,
                      color: AppColors.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Password ──────────────────────────────────────────
                  _FieldLabel('Password'),
                  const SizedBox(height: 8),
                  _DarkInputField(
                    controller: _passwordController,
                    hint: '********',
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined,
                        size: 18,
                        color: AppColors.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Forgot password ───────────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _isLoading ? () {} : () => _resetPassword(context),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Login button ──────────────────────────────────────
                  if (_messageText != null) ...[
                    _AuthMessage(text: _messageText!, isError: _messageIsError),
                    const SizedBox(height: 18),
                  ],
                  _GradientButton(
                    label: _isLoading ? 'SIGNING IN...' : 'LOGIN',
                    onTap: _isLoading ? () {} : () => _login(context),
                  ),
                  const SizedBox(height: 28),

                  // ── Divider ───────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: GoogleFonts.raleway(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.4,
                            ),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Social buttons ────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Google',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // ── Register link ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text(
                          'Register',
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _messageText = null;
      _messageIsError = false;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _messageText = 'Please enter email and password.';
        _messageIsError = true;
      });
      return;
    }

    final userProvider = context.read<UserProvider>();
    final router = GoRouter.of(context);

    setState(() => _isLoading = true);
    try {
      await userProvider.loginWithEmail(
        email: email,
        password: password,
      );
      if (!mounted) return;
      router.go('/main');
    } on firebase_auth.FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _messageText = _authErrorMessage(error);
        _messageIsError = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messageText = 'Login failed. Please try again.';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _messageText = 'Enter your email first.';
        _messageIsError = true;
      });
      return;
    }

    final userProvider = context.read<UserProvider>();

    setState(() => _isLoading = true);
    try {
      await userProvider.sendPasswordReset(email);
      if (!mounted) return;
      setState(() {
        _messageText = 'Password reset link sent to your email.';
        _messageIsError = false;
      });
    } on firebase_auth.FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _messageText = _authErrorMessage(error);
        _messageIsError = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messageText = 'Could not send reset link. Please try again.';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _authErrorMessage(firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This user account is disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'operation-not-allowed':
        return 'Enable Email/Password sign-in in Firebase Authentication.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'firebase-not-initialized':
        return 'Firebase is not initialized for this platform.';
      default:
        return error.message ?? 'Login failed. Please try again.';
    }
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.raleway(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 10 * 0.15,
      ),
    );
  }
}

// ─── Dark Input Field ─────────────────────────────────────────────────────────

class _DarkInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const _DarkInputField({
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
          color: AppColors.onSurface.withValues(alpha: 0.2),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
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
              letterSpacing: 13 * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Social Button ────────────────────────────────────────────────────────────

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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: AppColors.onSurface),
            const SizedBox(width: 10),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.raleway(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
