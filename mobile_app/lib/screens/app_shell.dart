import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/services/auth_service.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/ideas/screens/ideas_list_screen.dart';
import '../features/ideas/screens/my_ideas_screen.dart';
import '../features/ideas/screens/create_idea_screen.dart';
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
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthService>().logout();
                if (mounted) {
                  Navigator.pop(dialogContext);
                  setState(() => _isLoggedIn = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (_isCheckingAuth) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    // Show login screen if not authenticated
    if (!_isLoggedIn) {
      return const LoginScreen();
    }

    // Show main app if authenticated
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateIdeaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Idea'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'My Ideas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Invites',
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return const Text('Explore Ideas');
      case 1:
        return const Text('My Ideas');
      case 2:
        return const Text('Collaborations');
      default:
        return const Text('Ideole');
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const IdeasListScreen();
      case 1:
        return const MyIdeasScreen();
      case 2:
        return const InvitesScreen();
      default:
        return const Center(child: Text('Unknown page'));
    }
  }
}
