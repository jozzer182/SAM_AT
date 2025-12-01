// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/Log/register_other_screen.dart';
import 'package:samat2co/Log/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/main_bloc.dart';

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return CupertinoPageTransition(
        primaryRouteAnimation:
            CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    },
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool wasCliked = false;

  void iniciarSesion() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.isEmpty
            ? 'notAPassword'
            : passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          context.read<MainBloc>().add(
                NewMessage(
                  message:
                      'El correo electrónico, tiene un formato incorrecto, le puede faltar el @ o el .com',
                  color: Colors.red,
                  typeMessage: TypeMessage.error,
                ),
              );
          break;
        case 'user-not-found':
          context.read<MainBloc>().add(
                NewMessage(
                  message: 'Correo no registrado, por favor registrese',
                  color: Colors.orange,
                  typeMessage: TypeMessage.error,
                ),
              );
          break;
        case 'wrong-password':
          context.read<MainBloc>().add(
                NewMessage(
                  message:
                      'La contraseña ingresada es incorrecta, por favor intente nuevamente o de clic en olvidé mi contraseña',
                  color: Colors.red,
                  typeMessage: TypeMessage.error,
                ),
              );
          break;
        default:
          print(e);
          context.read<MainBloc>().add(
                NewMessage(
                  message: e.message ?? 'x',
                  color: Colors.red,
                  typeMessage: TypeMessage.error,
                ),
              );
      }
    } catch (e) {
      print(e);
      context.read<MainBloc>().add(
            NewMessage(
              message: e.toString(),
              color: Colors.red,
              typeMessage: TypeMessage.error,
            ),
          );
    }
    if (!(FirebaseAuth.instance.currentUser?.emailVerified ?? false)) {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Correo no verificado, revise su bandeja de entrada y verifique su correo.'),
        backgroundColor: Colors.orange,
      ));
    } else {
      BlocProvider.of<MainBloc>(context).add(Load());
    }
  }

  void olvideContrasena() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      context.read<MainBloc>().add(
            NewMessage(
              message:
                  'Se ha enviado un correo electrónico para reestablecer su contraseña.',
              color: Colors.green,
              typeMessage: TypeMessage.message,
            ),
          );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          context.read<MainBloc>().add(
                NewMessage(
                  message:
                      'El correo electrónico no se encuentra registrado, de clic en iniciar sesión.',
                  color: Colors.orange,
                  typeMessage: TypeMessage.error,
                ),
              );
          break;
        case 'invalid-email':
          context.read<MainBloc>().add(
                NewMessage(
                  message:
                      'El correo electrónico, tiene un formato incorrecto, le puede faltar el @ o el .com',
                  color: Colors.red,
                  typeMessage: TypeMessage.error,
                ),
              );
          break;
        default:
          context.read<MainBloc>().add(
                NewMessage(
                  message: e.toString(),
                  color: Colors.red,
                  typeMessage: TypeMessage.error,
                ),
              );
      }
    }
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      await FirebaseAuth.instance.signOut();
    } catch (es) {
      print(es);
    }
  }

  @override
  void initState() {
    emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocListener<MainBloc, MainState>(
        listenWhen: (previous, current) =>
            previous.errorCounter != current.errorCounter,
        listener: (context, state) {
          print(state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 8),
              backgroundColor: state.messageColor,
              content: Text(state.message),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //IMAGEN PREMI
              Image.asset(
                'images/tower.png',
                width: 150,
              ),
              Text(
                'SAM AT 2',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Por favor, inicia sesión para continuar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Si es la primera vez que ingresa, por favor ingrese su correo electrónico y una contraseña.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              // SizedBox(height: 8),
              Text(
                'Preferiblemente no usar la misma contraseña de red o del correo Enel.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: screenWidth > 400 ? 400 : screenWidth,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: screenWidth > 400 ? 400 : screenWidth,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: screenWidth > 400 ? 400 : screenWidth,
                child: GridView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 5,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  children: [
                    StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.userChanges(),
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            child: const Text('Iniciar sesión'),
                            onPressed: emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty
                                ? () => iniciarSesion()
                                : null,
                          );
                        }),
                    // SizedBox(width: 8),

                    // SizedBox(width: 8),
                    ElevatedButton(
                      child: const Text(
                        'Olvidé mi contraseña',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: emailController.text.isNotEmpty &&
                              emailController.text.contains('@')
                          // &&
                          // emailController.text.contains('@enel.com')
                          ? () => olvideContrasena()
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                width: 200,
                child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.userChanges(),
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Registro'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          _createRoute(RegisterOthers()));
                                    },
                                    child: Text('Empresa Colaboradora'),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          _createRoute(RegisterScreen()));
                                    },
                                    child: Text('Personal ENEL'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text('Registrarse'),
                      );
                    }),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    launchUrl(Uri.parse('https://www.youtube.com/watch?v=JDGowawECJc'));
                  },
                  child: const Text('Video Tutorial'),
                )
              ),
              const SizedBox(height: 8),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
