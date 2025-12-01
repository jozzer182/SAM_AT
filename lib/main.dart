import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:samat2co/Log/login_page.dart';
import 'package:samat2co/listener_messages_errors.dart';
import 'package:samat2co/resources/env_config.dart';
import 'bloc/main_bloc.dart';
import '../firebase_options.dart';

import 'Home/home_page.dart';
import 'version.dart';

void main() async {
  print(Version.data);
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables FIRST
    await dotenv.load(fileName: ".env");
    
    // Validate environment variables
    if (!EnvConfig.validate()) {
      final missing = EnvConfig.getMissingVariables();
      print('⚠️ Missing environment variables: ${missing.join(", ")}');
      print('Please check your .env file configuration.');
    }
    
    await initLocalStorage();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    // ignore: avoid_print
    print(e);
    // ignore: avoid_print
    print('Error al inicializar la aplicación');
    // ignore: avoid_print
    print(e.runtimeType);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc()..add(Load()),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            title: 'SAM AT+',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: state.themeColor ?? Colors.deepPurple,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: state.themeColor ?? Colors.deepPurple,
              useMaterial3: true,
              brightness: state.isDark ? Brightness.dark : Brightness.light,
            ),
            themeMode: ThemeMode.dark,
            home: ListenerCustom(
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data?.emailVerified ?? false)) {
                    return const HomePage();
                  }
                  return const LoginPage();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
