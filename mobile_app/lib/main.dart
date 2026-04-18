import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/token_storage.dart';
import 'core/widgets/index.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/ideas/controllers/idea_controller.dart';
import 'features/comments/controllers/comment_controller.dart';
import 'features/ratings/controllers/rating_controller.dart';
import 'features/invites/controllers/invite_controller.dart';
import 'features/organisations/controllers/organisation_controller.dart';
import 'features/communities/controllers/community_controller.dart';
import 'features/communities/controllers/membership_controller.dart';
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
        // Controllers
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<IdeaController>(
          create: (_) => IdeaController(),
        ),
        ChangeNotifierProvider<CommentController>(
          create: (_) => CommentController(),
        ),
        ChangeNotifierProvider<RatingController>(
          create: (_) => RatingController(),
        ),
        ChangeNotifierProvider<InviteController>(
          create: (_) => InviteController(),
        ),
        ChangeNotifierProvider<OrganisationController>(
          create: (_) => OrganisationController(),
        ),
        ChangeNotifierProvider<CommunityController>(
          create: (_) => CommunityController(),
        ),
        ChangeNotifierProvider<MembershipController>(
          create: (_) => MembershipController(),
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
