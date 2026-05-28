import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _menuItems = [
    (icon: Icons.person_outline, label: 'Edit Profile'),
    (icon: Icons.history, label: 'Order History'),
    (icon: Icons.location_on_outlined, label: 'Shipping Addresses'),
    (icon: Icons.payment_outlined, label: 'Payment Methods'),
    (icon: Icons.security_outlined, label: 'Account Security'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final fullName = user?.fullName ?? 'Kali Fashion User';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            toolbarHeight: 56,
            backgroundColor: AppColors.surfaceContainerLowest.withValues(
              alpha: 0.85,
            ),
            automaticallyImplyLeading: false,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.menu, color: AppColors.primary, size: 24),
                          const SizedBox(width: 16),
                          Text(
                            'KALI FASHION',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 16 * 0.18,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page title
                  Text(
                    'My Profile',
                    style: GoogleFonts.raleway(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Avatar section ──────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Avatar circle with gold border
                            Container(
                              width: 96,
                              height: 96,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                color: AppColors.surfaceContainerLow,
                              ),
                              child: ClipOval(
                                child: Container(
                                  color: AppColors.primaryContainer.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Center(
                                    child: Text(
                                      user?.initials ?? 'KF',
                                      style: GoogleFonts.raleway(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Edit badge
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.surfaceContainerLowest,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Name
                        Text(
                          fullName,
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Email
                        Text(
                          email.isEmpty ? 'No email connected' : email,
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            color: AppColors.outline,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── Menu items ──────────────────────────────────────
                  ...List.generate(_menuItems.length, (i) {
                    final item = _menuItems[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _MenuItem(
                        icon: item.icon,
                        label: item.label,
                        onTap: item.label == 'Order History'
                            ? () => context.go('/main?tab=3')
                            : () {},
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── Logout button ───────────────────────────────────
                  GestureDetector(
                    onTap: () async {
                      await context.read<UserProvider>().logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'LOGOUT',
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 12 * 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Menu Item ────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  letterSpacing: 12 * 0.1,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
