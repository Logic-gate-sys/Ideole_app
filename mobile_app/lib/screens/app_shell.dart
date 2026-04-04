import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/index.dart';
import '../features/auth/services/auth_service.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/ideas/screens/my_ideas_screen.dart';
import '../features/invites/screens/invites_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final authService = context.read<AuthService>();
    final isLoggedIn = await authService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isCheckingAuth = false;
    });
  }

  void _handleLogout() {
    showAppAlertDialog(
      context,
      title: 'Logout?',
      message: 'Are you sure you want to logout from your account?',
      positiveLabel: 'Logout',
      negativeLabel: 'Cancel',
      type: AlertType.warning,
      onPositive: () async {
        await context.read<AuthService>().logout();
        if (mounted) {
          setState(() => _isLoggedIn = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (_isCheckingAuth) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading Ideole',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show login screen if not authenticated
    if (!_isLoggedIn) {
      return const SignInScreen();
    }

    // Show main app if authenticated
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const FeedScreen();
      case 1:
        return const MyIdeasScreen();
      case 2:
        return const InvitesScreen();
      case 3:
        return const _ProfileScreen();
      default:
        return const Center(child: Text('Unknown page'));
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            activeIcon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            activeIcon: Icon(Icons.lightbulb),
            label: 'My Ideas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Invites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Simple profile screen placeholder
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTextStyles.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AppAvatar(
                    initials: 'JD',
                    size: 56,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john@example.com',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Text(
              'Statistics',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.primaryContainer
                        .withOpacity(0.5),
                    child: Column(
                      children: [
                        Text(
                          '12',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ideas',
                          style: AppTextStyles.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.secondaryContainer
                        .withOpacity(0.5),
                    child: Column(
                      children: [
                        Text(
                          '28',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ratings',
                          style: AppTextStyles.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor:
                        AppColors.tertiaryContainer.withOpacity(0.5),
                    child: Column(
                      children: [
                        Text(
                          '45',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.tertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Comments',
                          style: AppTextStyles.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text(
              'Settings',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            AppCard(
              onTap: () {},
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () {},
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Privacy & Security',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () {},
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Help & Support',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout button
            AppButton(
              label: 'Logout',
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.large,
              isFullWidth: true,
              onPressed: () {
                showAppAlertDialog(
                  context,
                  title: 'Logout?',
                  message: 'Are you sure you want to logout?',
                  positiveLabel: 'Logout',
                  negativeLabel: 'Cancel',
                  type: AlertType.warning,
                ).then((result) {
                  if (result == true) {
                    context.read<AuthService>().logout();
                    // The parent AppShell will rebuild and show login
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
