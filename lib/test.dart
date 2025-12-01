// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:samat2co/planilla/view/planilla_page.dart';

// import 'bloc/main_bloc.dart';

// void main() async {
//   runApp(const TestModule());
// }

// class TestModule extends StatelessWidget {
//   const TestModule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Test',
//       theme: ThemeData(
//         colorSchemeSeed: const Color.fromARGB(255, 140, 38, 187),
//         useMaterial3: true,
//       ),
//       localizationsDelegates: GlobalMaterialLocalizations.delegates,
//       supportedLocales: const [Locale('en'), Locale('es')],
//       home:  BlocProvider(
//         create: (context) => MainBloc(),
//         child: PlanillaPage( esNuevo: false,),
//       ),
//     );
//   }
// }

// class Page extends StatelessWidget {
//   const Page({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Page'),
//       ),
//     );
//   }
// }
