import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mad_project/dashboard.dart';
import 'package:mad_project/firebase_options.dart';
import 'package:mad_project/home.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'login.dart';
import 'new_homework.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) {  },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: 'dashboard',
              builder: (context, state) => DashboardPage(),
            ),
            GoRoute(
              path: 'new_homework',
              builder: (context, state) => NewHomeworkPage(),
            ),
            GoRoute(
              path: 'profile',
              builder: (context, state) => ProfilePage(),
            ),
          ]
        )
      ],
    );

    return MaterialApp.router(
      title: 'Final',
      routerConfig: _router,
    );
  }
}