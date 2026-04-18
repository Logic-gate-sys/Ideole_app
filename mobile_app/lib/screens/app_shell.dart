import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/index.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/auth/utils/validators.dart';
import '../features/ideas/screens/ideas_list_screen.dart';
import '../features/ideas/screens/my_ideas_screen.dart';
import '../features/invites/screens/invites_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/organisations/screens/organisations_list_screen.dart';
import '../shared/models/user_model.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        if (authController.isLoading && !authController.isAuthenticated) {
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

        if (!authController.isAuthenticated) {
          return const SignInScreen();
        }

        return Scaffold(
          backgroundColor: AppColors.surfaceContainerLowest,
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const IdeasListScreen();
      case 1:
        return const MyIdeasScreen();
      case 2:
        return const OrganisationsListScreen();
      case 3:
        return const InvitesScreen();
      case 4:
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
            label: 'Orgs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            activeIcon: Icon(Icons.mail),
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
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh profile',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AuthController>().refreshCurrentUser();
            },
          ),
        ],
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
                    initials: user.displayName.isNotEmpty
                        ? user.displayName.substring(0, 1).toUpperCase()
                        : user.username.substring(0, 1).toUpperCase(),
                    size: 56,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${user.username}',
                          style: AppTextStyles.labelSmall.copyWith(
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

            AppButton(
              label: 'Edit Profile',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
              isFullWidth: true,
              icon: Icons.edit_outlined,
              onPressed: () => _showEditProfileSheet(
                context,
                authController,
                user,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Account',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            AppCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Role: ${user.role ?? 'USER'}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (user.profileUrl?.trim().isNotEmpty ?? false)
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link_outlined,
                      color: AppColors.onSurface,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Profile URL: ${user.profileUrl}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            if (user.profileUrl?.trim().isNotEmpty ?? false)
              const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Status: ${user.status ?? 'ACTIVE'}',
                      style: AppTextStyles.bodyMedium,
                    ),
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
              onPressed: () async {
                showAppAlertDialog(
                  context,
                  title: 'Logout?',
                  message: 'Are you sure you want to logout?',
                  positiveLabel: 'Logout',
                  negativeLabel: 'Cancel',
                  type: AlertType.warning,
                ).then((result) {
                  if (result == true && context.mounted) {
                    context.read<AuthController>().logout();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditProfileSheet(
    BuildContext context,
    AuthController authController,
    User user,
  ) async {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final profileUrlController = TextEditingController(
      text: user.profileUrl ?? '',
    );

    final shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 18,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  AppInput(
                    label: 'Username',
                    hint: 'Enter username',
                    controller: usernameController,
                    validator: AuthValidators.validateUsername,
                  ),
                  const SizedBox(height: 12),
                  AppInput(
                    label: 'Email',
                    hint: 'you@example.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidators.validateEmail,
                  ),
                  const SizedBox(height: 12),
                  AppInput(
                    label: 'Profile URL (optional)',
                    hint: 'https://example.com/profile',
                    controller: profileUrlController,
                    keyboardType: TextInputType.url,
                    validator: AuthValidators.validateOptionalUrl,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          variant: AppButtonVariant.outlined,
                          onPressed: () => Navigator.of(sheetContext).pop(false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'Save',
                          variant: AppButtonVariant.filled,
                          onPressed: () {
                            if (formKey.currentState?.validate() != true) {
                              return;
                            }
                            Navigator.of(sheetContext).pop(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    final updatedUsername = usernameController.text.trim();
    final updatedEmail = emailController.text.trim();
    final rawProfileUrl = profileUrlController.text.trim();
    final updatedProfileUrl = rawProfileUrl.isEmpty ? null : rawProfileUrl;

    usernameController.dispose();
    emailController.dispose();
    profileUrlController.dispose();

    if (shouldSave != true) {
      return;
    }

    final success = await authController.updateProfile(
      username: updatedUsername,
      email: updatedEmail,
      profileUrl: updatedProfileUrl,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Profile updated successfully.'
              : authController.error ?? 'Unable to update profile.',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }
}
