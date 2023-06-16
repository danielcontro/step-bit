import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/screens/homepage.dart';
import 'package:stepbit/screens/login.dart';
import 'package:stepbit/utils/app_colors.dart';
import 'package:stepbit/utils/app_interceptor.dart';
import 'package:stepbit/utils/token_manager.dart';

import 'database/database.dart';
import 'repositories/database_repository.dart';
import 'widgets/loading.dart';

Future<void> main() async {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(ChangeNotifierProvider<DatabaseRepository>(
            create: (context) => databaseRepository,
            child: const MyApp(),
          )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const forceLoginForm = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.lime,
          brightness: AppColors.theme,
          primaryColor: AppColors.primaryColor,
          appBarTheme: AppBarTheme(color: AppColors.primaryColor)),
      home: FutureBuilder(
          future: showLoginPage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final showLogin = snapshot.data as bool;
              return showLogin || forceLoginForm
                  ? const Login()
                  : const HomePage();
            } else {
              return Scaffold(
                  appBar: AppBar(title: const Text("StepBit")),
                  body: const Loading());
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> showLoginPage() async {
    final isTokenExpired = await TokenManager.isAccessTokenExpired();
    if (!isTokenExpired) {
      return false;
    }
    final credentialStillValid = await AppInterceptor().refreshToken();
    return !credentialStillValid;
  }
}
