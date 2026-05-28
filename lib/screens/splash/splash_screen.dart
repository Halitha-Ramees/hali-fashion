import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // Navigate to login after 2.5 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background silk image — grayscale, 20% opacity
          Opacity(
            opacity: 0.20,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuB7949iwBXMyGTlT4WRht1t4PLfdfn3wIrYNa_gfPX98KJW-JCkQip3N0GrUWAxXjygJ7wUe4Cq4XSCe7iWlmYqcjP6T8S9dPrR5IQCqdfq9-SPtXy9pknSsxnVAa34LMfunrxLLynQ7r0rSuWo7B3PQyHJc-GfKhsoA5TEXDTAqjm81GuTixm-NQ4BaSvKkeoyMZI6ah6Ik9Q9LHDYW57fK-qoi7DkPWg2hZX8Cr0KwIdNtWFNEjhxYNxCN3wJHw0eQOvjzFHtflw',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: AppColors.surfaceContainerLowest),
              ),
            ),
          ),

          // Top-to-bottom gradient vignette
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surfaceContainerLowest,
                  Colors.transparent,
                  AppColors.surfaceContainerLowest,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Center branding
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand name
                  Text(
                    'KALI FASHION',
                    style: GoogleFonts.raleway(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 36 * 0.1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Decorative gold line
                  Container(
                    width: 64,
                    height: 1,
                    color: AppColors.primaryContainer.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 16),

                  // Tagline
                  Text(
                    'LUXURY  ·  STYLE  ·  ELEGANCE',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      letterSpacing: 13 * 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer — "Est. 2024" with dots
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Opacity(
                opacity: 0.30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'EST. 2024',
                      style: GoogleFonts.raleway(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                        letterSpacing: 10 * 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
