import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/token_storage.dart';
import 'core/widgets/index.dart';
import 'features/auth/services/auth_service.dart';
import 'features/ideas/controllers/idea_controller.dart';
import 'features/ratings/controllers/rating_controller.dart';
import 'features/invites/controllers/invite_controller.dart';
import 'features/comments/controllers/comment_controller.dart';
import 'screens/app_shell.dart';

void main() async {
  // Initialize app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize token storage
  final tokenStorage = TokenStorage();
  await tokenStorage.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => AuthService()),

        // Controllers
        ChangeNotifierProvider<IdeaController>(
          create: (_) => IdeaController(),
        ),
        ChangeNotifierProvider<RatingController>(
          create: (_) => RatingController(),
        ),
        ChangeNotifierProvider<InviteController>(
          create: (_) => InviteController(),
        ),
        ChangeNotifierProvider<CommentController>(
          create: (_) => CommentController(),
        ),
      ],
      child: MaterialApp(
        title: 'Ideole',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const AppShell(),
      ),
    );
  }
}
