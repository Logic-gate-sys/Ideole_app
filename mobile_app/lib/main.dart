import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/token_storage.dart';
import 'core/theme/theme_controller.dart';
import 'core/widgets/index.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/ideas/controllers/idea_controller.dart';
import 'features/comments/controllers/comment_controller.dart';
import 'features/ratings/controllers/rating_controller.dart';
import 'features/invites/controllers/invite_controller.dart';
import 'features/notifications/services/notification_push_service.dart';
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

  final themeController = ThemeController();
  await themeController.loadPreference();

  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatefulWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NotificationPushService _notificationPushService;

  String? _boundNotificationUserId;
  bool _isSyncingNotificationState = false;

  @override
  void initState() {
    super.initState();
    _notificationPushService = NotificationPushService();
    unawaited(_notificationPushService.init());
  }

  @override
  void dispose() {
    unawaited(_notificationPushService.dispose());
    super.dispose();
  }

  void _syncNotificationPush(AuthController authController) {
    final nextUserId = authController.isAuthenticated
        ? authController.currentUser?.id
        : null;

    if (_isSyncingNotificationState || nextUserId == _boundNotificationUserId) {
      return;
    }

    _isSyncingNotificationState = true;

    unawaited(
      Future<void>(() async {
        try {
          if (nextUserId == null || nextUserId.isEmpty) {
            await _notificationPushService.stop();
          } else {
            await _notificationPushService.startForUser(nextUserId);
          }

          _boundNotificationUserId = nextUserId;
        } finally {
          _isSyncingNotificationState = false;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Controllers
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<IdeaController>(create: (_) => IdeaController()),
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
        ChangeNotifierProvider<ThemeController>.value(
          value: widget.themeController,
        ),
      ],
      child: Consumer2<AuthController, ThemeController>(
        builder: (context, authController, appThemeController, _) {
          _syncNotificationPush(authController);

          return MaterialApp(
            key: ValueKey('ideole-app-${appThemeController.themeMode.name}'),
            title: 'Ideole',
            debugShowCheckedModeBanner: false,
            scrollBehavior: const AppScrollBehavior(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appThemeController.themeMode,
            themeAnimationDuration: Duration.zero,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
