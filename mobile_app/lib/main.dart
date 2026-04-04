import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/design/colors.dart';
import 'services/storage_service.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/feed/controllers/idea_controller.dart';
import 'features/feed/screens/idea_feed_screen.dart';
import 'features/communities/controllers/community_controller.dart';
import 'features/communities/screens/communities_screen.dart';

void main() async {
  // Initialize app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service (SharedPreferences)
  await StorageService().init();
  
  runApp(const MyApp());
}


// Stateful widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.init(); // Check if already logged in
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>.value(
      value: _authController,
      child: MaterialApp(
        title: 'Ideole',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: SaharaColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: SaharaColors.surface,
        ),
        home: Consumer<AuthController>(
          builder: (context, authController, _) {
            // Show Auth screens if not authenticated
            if (!authController.isAuthenticated) {
              return AuthScreen(
                onAuthSuccess: () {
                  // Auth controller state updates automatically,
                  // Consumer rebuilds and shows MainApp
                },
              );
            }
            
            // Show MainApp (bottom tab navigation) when authenticated
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<IdeaController>(
                  create: (_) => IdeaController(),
                ),
                ChangeNotifierProvider<CommunityController>(
                  create: (_) => CommunityController(),
                ),
              ],
              child: const MainApp(),
            );
          },
        ),
      ),
    );
  }
}

/// Main app with bottom tab navigation
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideole'),
        centerTitle: true,
      ),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  /// Build the appropriate screen based on selected tab
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const IdeaFeedScreen();
      case 1:
        return const CommunitiesScreen();
      case 2:
        return _buildPlaceholder('Profile');
      case 3:
        return _buildPlaceholder('Settings');
      default:
        return _buildPlaceholder('Unknown');
    }
  }

  /// Build placeholder for tabs not yet implemented
  Widget _buildPlaceholder(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: SaharaColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '$tabName',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
