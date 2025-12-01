// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:samat2co/deuda_almacen/deudaalmacen_page.dart';
import 'package:samat2co/deuda_almacen/sobrantealmacen_page.dart';
import 'package:samat2co/deuda_bruta/deudabruta_page.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_page.dart';
import 'package:samat2co/inventario/inventario_page.dart';
import 'package:samat2co/mb51/mb51_page.dart';
import 'package:samat2co/mb52/mb52_model.dart';
import 'package:samat2co/mb52/mb52_page.dart';
import 'package:samat2co/planilla/view/planilla_page.dart';
import 'package:samat2co/planillas/planillas_page.dart';
import 'package:samat2co/registros/registros_page.dart';
import 'package:samat2co/pdi/pdi_model.dart';

import 'package:samat2co/plataforma/plataforma_page.dart';
import 'package:samat2co/remisiones/remision/view/remision_page.dart';
import 'package:samat2co/remisiones/remisiones/view/remisiones_page.dart';
import 'package:samat2co/token/token_page.dart';
import 'package:samat2co/user/user_model.dart';
import 'package:samat2co/usuarios/usuarios_model.dart';
import 'package:http/http.dart' as http;
import 'package:samat2co/zan_por_codigo/por_codigo_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/main_bloc.dart';
import '../lcl/view/lcl_page_new.dart';
import '../resources/animacion_pagina.dart';
import '../resources/constants/apis.dart';
import '../version.dart';
import '../videos/videos_page.dart';

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return CupertinoPageTransition(
        primaryRouteAnimation: CurveTween(
          curve: Curves.easeInOutCirc,
        ).animate(animation),
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    },
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double elevationCard1 = 1.0;
  double elevationCard2 = 1.0;
  double elevationCard3 = 1.0;
  double elevationCard4 = 1.0;
  double elevationCard5 = 1.0;
  String? pdiText;
  final ScrollController _controller = ScrollController();

  void cambiarPdi(value, List<PdiSingle> pdis, User user) async {
    context.read<MainBloc>().add(Loading(isLoading: true));
    PdiSingle pdi = pdis.firstWhere((e) => e.pdi == value);
    var dataSend = {
      'info': {
        "libro": "USUARIOS",
        "hoja": "hoja",
        'map': {
          'id': user.id,
          'correo': user.correo,
          'perfil': user.perfil,
          'pdi': value,
          'telefono': user.telefono,
          'empresa': pdi.empresa,
          'nombrecorto': pdi.nombrecorto,
        },
      },
      'fname': 'updateMap',
    };
    // print(jsonEncode(dataSend));
    try {
      final response = await http.post(
        Uri.parse(Api.samat),
        body: jsonEncode(dataSend),
      );
      // print('response ${response.body}');
      // ignore: prefer_typing_uninitialized_variables
      var dataAsListMap;
      if (response.statusCode == 302) {
        var response2 = await http.get(
          Uri.parse(response.headers["location"] ?? ''),
        );
        dataAsListMap = jsonDecode(response2.body);
      } else {
        dataAsListMap = jsonDecode(response.body);
      }
      // print(dataAsListMap);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dataAsListMap), backgroundColor: Colors.green),
      );
      context.read<MainBloc>().add(LoadUserAndData());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
    setState(() {
      pdiText = value.toString();
    });
  }

  void cambiarColor() {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text('Escoge un color'),
          content: SingleChildScrollView(
            child: MaterialColorPicker(
              allowShades: false,
              onMainColorChange: (value) {
                if (value != null) {
                  BlocProvider.of<MainBloc>(
                    context,
                  ).add(ThemeColorChange(color: Color(value.value)));
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        );
      },
      context: context,
    );
  }

  @override
  void initState() {
    pdiText = Version.pdi();
    // print(pdiText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    // Color onPrimaryContainer = Theme.of(context).colorScheme.onPrimaryContainer;
    // Color tertiaryContainer = Theme.of(context).colorScheme.tertiaryContainer;
    // Color onTertiaryContainer =
    //     Theme.of(context).colorScheme.onTertiaryContainer;
    // Color secondaryContainer = Theme.of(context).colorScheme.secondaryContainer;
    // Color onSecondaryContainer =
    //     Theme.of(context).colorScheme.onSecondaryContainer;
    // Color background = Theme.of(context).colorScheme.background;
    // Color onBackground = Theme.of(context).colorScheme.onBackground;
    Color primary = Theme.of(context).colorScheme.primary;
    // void goTo(Widget page) {
    //   Navigator.push(context, _createRoute(page));
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SAM AT',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              // print('called');
              return state ? const LinearProgressIndicator() : const SizedBox();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, createRoute(const VideosPage()));
            },
            child: const Text("Videos\nSAP", textAlign: TextAlign.center),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              launchUrl(
                Uri.parse('https://www.youtube.com/watch?v=JDGowawECJc'),
              );
            },
            child: const Text(
              'Video tutorial\nSalidas',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  List<PdiSingle> pdis = state.pdi?.pdiList ?? [];
                  List<UsuariosSingle> usuarios =
                      state.usuarios?.usuariosList ?? [];
                  User? user = state.user;
                  if (state.user == null || pdis.isEmpty) {
                    return const CircularProgressIndicator();
                  }
                  if (user!.permisos.contains("cambioPdi")) {
                    return SizedBox(
                      width: 150,
                      height: 40,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(),
                          labelText: 'PDI',
                        ),
                        autofocus: true,
                        isExpanded: true,
                        value:
                            usuarios
                                .firstWhere(
                                  (e) => e.correo == Version.user,
                                  orElse: () => UsuariosSingle.fromZero(),
                                )
                                .pdi,
                        items:
                            pdis.map((pdi) {
                              return DropdownMenuItem(
                                value: pdi.pdi,
                                child: Text(
                                  pdi.nombrecorto,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                        onChanged:
                            (value) async => cambiarPdi(value, pdis, user),
                      ),
                    );
                  }
                  return SizedBox(
                    width: 150,
                    height: 40,
                    child: TextFormField(
                      readOnly: true,
                      initialValue: user.nombrecorto,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(),
                        labelText: 'PDI',
                      ),
                    ),
                  );
                },
              ),
              context.select((MainBloc bloc) => bloc.state.user) == null
                  ? const SizedBox()
                  : SelectableText(
                    context.select((MainBloc bloc) => bloc.state.user)!.pdi,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
            ],
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Recargar datos',
            child: IconButton(
              onPressed: () {
                BlocProvider.of<MainBloc>(context).add(Load());
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Cambiar color',
            child: IconButton(
              onPressed: () => cambiarColor(),
              icon: const Icon(Icons.color_lens),
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: 'Cambiar tema',
            child: IconButton(
              onPressed: () {
                BlocProvider.of<MainBloc>(context).add(ThemeChange());
              },
              icon: const Icon(Icons.brightness_4_outlined),
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: 'Cerrar sesión',
            child: IconButton(
              icon: Icon(Icons.logout, color: primary, size: 16),
              onPressed: () async => await FirebaseAuth.instance.signOut(),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Version.data, style: Theme.of(context).textTheme.labelSmall),
            Text(
              Version.status('Home', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),
      body: BlocListener<MainBloc, MainState>(
        listenWhen:
            (previous, current) =>
                previous.errorCounter != current.errorCounter,
        listener: (context, state) {
          // ignore: avoid_print
          print(state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 8),
              backgroundColor: state.messageColor,
              content: Text(state.message),
            ),
          );
        },
        child: BlocListener<MainBloc, MainState>(
          listenWhen:
              (previous, current) =>
                  previous.dialogCounter != current.dialogCounter,
          listener: (context, state) {
            // ignore: avoid_print
            print(state.dialogMessage);
            if (state.dialogMessage.isNotEmpty) {
              showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: const Text('Atención'),
                    content: Text(state.dialogMessage),
                    actions: [
                      ElevatedButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                if (state.user == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    SizedBox(
                      height: 56.0,
                      // margin: EdgeInsets.all(10.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        children: [
                          BlocSelector<MainBloc, MainState, Mb52?>(
                            selector: (state) => state.mb52,
                            builder: (context, state) {
                              if (state != null) {
                                return cardSAP(
                                  snapshot: state.totalValor,
                                  context: context,
                                );
                              }

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          BlocBuilder<MainBloc, MainState>(
                            builder: (context, state) {
                              if (state.mb52 != null &&
                                  state.deudaBruta != null) {
                                return chartDeuda(
                                  snapshot: [
                                    state.deudaBruta!.totalValor,
                                    state.mb52!.totalValor,
                                    state.deudaBruta!.totalValor,
                                  ],
                                  title: 'Deuda Bruta',
                                  page: const DeudaBrutaPage(),
                                  context: context,
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          BlocBuilder<MainBloc, MainState>(
                            builder: (context, state) {
                              if (state.mb52 != null &&
                                  state.deudaAlmacen != null &&
                                  state.deudaBruta != null) {
                                return chartDeuda(
                                  snapshot: [
                                    state.deudaAlmacen!.totalSobrantes,
                                    state.mb52!.totalValor,
                                    state.deudaBruta!.totalValor,
                                  ],
                                  title: 'Sobrantes Almacén',
                                  page: const SobranteAlmacenPage(),
                                  context: context,
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          BlocBuilder<MainBloc, MainState>(
                            builder: (context, state) {
                              if (state.mb52 != null &&
                                  state.deudaAlmacen != null &&
                                  state.deudaBruta != null) {
                                return chartDeuda(
                                  snapshot: [
                                    state.deudaAlmacen!.totalFaltantes,
                                    state.mb52!.totalValor,
                                    state.deudaBruta!.totalValor,
                                  ],
                                  title: 'Deuda Almacén',
                                  page: const DeudaAlmacenPage(),
                                  context: context,
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          // BlocBuilder<MainBloc, MainState>(
                          //   builder: (context, state) {
                          //     if (state.mb52 != null &&
                          //         state.deudaOperativa != null &&
                          //         state.deudaBruta != null) {
                          //       return chartDeuda(
                          //         snapshot: [
                          //           state.deudaOperativa!.totalSobrantes,
                          //           state.mb52!.totalValor,
                          //           state.deudaBruta!.totalValor
                          //         ],
                          //         title: 'Sobrantes Operativos',
                          //         page: DeudaOperativaScreenOrder(),
                          //       );
                          //     }
                          //     return CircularProgressIndicator();
                          //   },
                          // ),
                          BlocBuilder<MainBloc, MainState>(
                            builder: (context, state) {
                              if (state.mb52 != null &&
                                  state.deudaOperativa != null &&
                                  state.deudaBruta != null) {
                                return chartDeuda(
                                  snapshot: [
                                    state.deudaOperativa!.totalFaltantes,
                                    state.mb52!.totalValor,
                                    state.deudaBruta!.totalValor,
                                  ],
                                  title: 'Deuda Operativa',
                                  page: const DeudaOperativaPage(),
                                  context: context,
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          // BlocBuilder<MainBloc, MainState>(
                          //   builder: (context, state) {
                          //     if (state.mb52 != null &&
                          //         state.deudaEnel != null &&
                          //         state.deudaBruta != null) {
                          //       return chartDeuda(
                          //         snapshot: [
                          //           state.deudaEnel!.totalValor,
                          //           state.mb52!.totalValor,
                          //           state.deudaBruta!.totalValor
                          //         ],
                          //         title: 'Deuda Enel',
                          //         page: DeudaOperativaPersonPage(),
                          //       );
                          //     }
                          //     return CircularProgressIndicator();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    Text(
                      'INVENTARIO',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                      children: [
                        Opacity(
                          opacity:
                              state.user == null ||
                                      !state.user!.permisos.contains(
                                        'nueva_remision',
                                      )
                                  ? 0.1
                                  : 1.0,
                          child: SimpleCard(
                            page:
                                state.user == null ||
                                        !state.user!.permisos.contains(
                                          'nueva_remision',
                                        )
                                    ? () {}
                                    : const RemisionPage(esNuevo: true),
                            title: "Nueva Remisión",
                            image: 'images/enter.png',
                          ),
                        ),
                        Opacity(
                          opacity:
                              state.remisiones == null
                                  // ||
                                  //         !state.user!.permisos
                                  //             .contains('Remisiones')
                                  ? 0.1
                                  : 1.0,
                          child: SimpleCard(
                            page:
                                state.remisiones == null
                                    // ||
                                    //         !state.user!.permisos
                                    //             .contains('nuevo_ingreso')
                                    ? () {}
                                    : const RemisionesPage(),
                            title: "Remisiones",
                            image: 'images/receiver.png',
                          ),
                        ),

                        // Opacity(
                        //   opacity: state.nuevoTraslado == null ||
                        //             !state.user!.permisos
                        //                 .contains('nuevo_traslado')? 0.1 : 1.0,
                        //   child: SimpleCard(
                        //     page: state.nuevoTraslado == null ||
                        //             !state.user!.permisos
                        //                 .contains('nuevo_traslado')
                        //         ? () {}
                        //         : NuevoTrasladoPage(),
                        //     title: "Nuevo Traslado",
                        //     image: 'images/moving.png',
                        //   ),
                        // ),
                        Opacity(
                          opacity: state.inventario == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page:
                                state.inventario == null
                                    ? () {}
                                    : const InventarioPage(),
                            title: "Inventario",
                            image: 'images/inventory.png',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'MOVIMIENTOS',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                      children: [
                        Opacity(
                          opacity:
                              state.planilla == null ||
                                      state.planillas == null ||
                                      !state.user!.permisos.contains(
                                        'nuevo_planilla',
                                      )
                                  ? 0.1
                                  : 1.0,
                          child: SimpleCard(
                            page:
                                state.planilla == null ||
                                        state.planillas == null ||
                                        !state.user!.permisos.contains(
                                          'nuevo_planilla',
                                        )
                                    ? () {}
                                    : const PlanillaPage(esNuevo: true),
                            title: "Nueva Planilla",
                            image: 'images/exit.png',
                          ),
                        ),
                        Opacity(
                          opacity: state.planillas == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page:
                                state.planillas == null
                                    ? () {}
                                    : const PlanillasPage(),
                            title: "Planillas",
                            image: 'images/planilla.png',
                          ),
                        ),
                        Opacity(
                          opacity: state.planillas == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page:
                                state.planillas == null
                                    ? () {}
                                    : RegistrosPage(),
                            title: "Registros",
                            image: 'images/document.png',
                          ),
                        ),
                        Opacity(
                          opacity:
                              state.planillas == null ||
                                      !state.user!.permisos.contains(
                                        'generar_token',
                                      )
                                  ? 0.1
                                  : 1.0,
                          child: SimpleCard(
                            page:
                                state.planillas == null ||
                                        !state.user!.permisos.contains(
                                          'generar_token',
                                        )
                                    ? () {}
                                    : const TokenPage(),
                            title: "Generar Token",
                            image: 'images/padlock.png',
                          ),
                        ),
                      ],
                    ),
                    Text('SAP', style: Theme.of(context).textTheme.titleMedium),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                      children: [
                        Opacity(
                          opacity: state.mb51 == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page: state.mb51 == null ? () {} : Mb51Page(),
                            title: "MB51",
                            image: 'images/exchange.png',
                          ),
                        ),
                        Opacity(
                          opacity: state.mb52 == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page: state.mb52 == null ? () {} : Mb52Page(),
                            title: "MB52",
                            image: 'images/warehouse.png',
                          ),
                        ),
                        Opacity(
                          opacity: state.plataforma == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page:
                                state.plataforma == null
                                    ? () {}
                                    : PlataformaPage(),
                            title: "Plataforma",
                            image: 'images/ware.png',
                          ),
                        ),
                        Opacity(
                          opacity: state.lcl == null ? 0.1 : 1.0,
                          child: SimpleCard(
                            page: state.lcl == null ? () {} : LCLPageN(),
                            title: "Lcl",
                            image: 'images/checklist.png',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'ANÁLISIS',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                      children: [
                        Opacity(
                          opacity:
                              (state.mb51 == null ||
                                      state.planillas == null ||
                                      state.remisiones == null)
                                  ? 0.1
                                  : 1.0,
                          child: SimpleCard(
                            page:
                                (state.mb51 == null ||
                                        state.planillas == null ||
                                        state.remisiones == null)
                                    ? () {}
                                    : PorCodigoPage(),
                            title: "POR CÓDIGO",
                            image: 'images/comparison.png',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleCard extends StatelessWidget {
  final dynamic page;
  final String title;
  final String image;
  final Function? fun;
  final Color? color;

  const SimpleCard({
    required this.page,
    required this.title,
    required this.image,
    this.color,
    this.fun,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    return SizedBox(
      width: 148.0,
      child: Card(
        color: color,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            try {
              goTo(page);
            } finally {
              if (fun != null) fun!();
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, width: 50, height: 50),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget cardSAP({required int snapshot, required BuildContext context}) {
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  void goTo(Widget page) {
    Navigator.push(context, _createRoute(page));
  }

  return SizedBox(
    width: 250,
    height: 56,
    child: InkWell(
      onTap: () {
        goTo(Mb52Page());
      },
      child: Card(
        color: Theme.of(context).colorScheme.onPrimary,
        elevation: 4.0,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Text(
              'SAP: ${uSFormat.format(snapshot)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget chartDeuda({
  required List<int> snapshot,
  required String title,
  required page,
  required BuildContext context,
}) {
  double rate = (snapshot[0] / snapshot[1]);
  double rate2 = (snapshot[0] / snapshot[2]);
  String percent = '${(rate * 100).toStringAsFixed(0)}%';
  String percent2 = '${(rate2 * 100).toStringAsFixed(0)}%';
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  void goTo(Widget page) {
    Navigator.push(context, _createRoute(page));
  }

  return InkWell(
    onTap: () {
      goTo(page);
    },
    child: Ink(
      child: SizedBox(
        width: 250,
        child: Card(
          color: Theme.of(context).colorScheme.onPrimary,
          elevation: 4.0,
          child: chartLine(
            title: title,
            rate: rate,
            rate2: rate2,
            number: '${uSFormat.format(snapshot[0])} ($percent)',
            number2: '$percent2',
          ),
        ),
      ),
    ),
  );
}

Widget chartLine({
  required String title,
  required double rate,
  required double rate2,
  String? number,
  String? number2,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final lineWidget = (constraints.maxWidth * rate).abs();
      final lineWidget2 = (constraints.maxWidth * rate2).abs();
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle().copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 12,
                      ),
                    ),
                    if (number != null)
                      Text(
                        number,
                        style: TextStyle().copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 10,
              width: lineWidget,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              height: 10,
              width: lineWidget2,
              child: Center(
                child: Text(
                  number2 ?? '',
                  style: TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
