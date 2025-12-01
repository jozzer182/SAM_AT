import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher.dart';

import '../bloc/main_bloc.dart';
import '../version.dart';

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

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  State<VideosPage> createState() => _VideosPageState();
}


class _VideosPageState extends State<VideosPage> {
  Uri conciliacion = Uri.parse('https://enelcom.sharepoint.com/:v:/s/ProjectManagementConstructionColombia/pp&c/EQDRMbn4m19FsD3PFqtHcVMB2AKVTT_ZLTUpV0Wbta1gQQ?e=g3OzSa');
  Uri salidaNormal = Uri.parse('https://enelcom-my.sharepoint.com/:v:/g/personal/jose_zarabandad_enel_com/EYykACBYiSFYoqxgROG7WtQBV80llle83xsrAYMyI2LsNw?e=DBz4j3&isSPOFile=1');
  Uri salidaWbe = Uri.parse('https://enelcom-my.sharepoint.com/:v:/g/personal/jose_zarabandad_enel_com/EZr1XTPfAhtPpGGwC4XxBIoBMsPseLgABZq5kHDPQjHyCQ?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=sJUks8&isSPOFile=1');
  Uri obtenerPDF = Uri.parse('https://enelcom-my.sharepoint.com/:v:/g/personal/jose_zarabandad_enel_com/EbqjZSNxAwFBhi2AySkB0coBwjWz_m1Du5QYPtKGka4JBg?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=wbXJ3b');
  Uri reintegro = Uri.parse('https://enelcom-my.sharepoint.com/:v:/g/personal/jose_zarabandad_enel_com/ESehY72gtORDoLlkNfm4omgB5NUiPA8xrITe8gwesuq8mA?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=htRy0H');
  Uri consultaSAP = Uri.parse('https://enelcom-my.sharepoint.com/:v:/g/personal/jose_zarabandad_enel_com/ESNfFPGUZNFDtFygFpnVH0EBVxGT2gVg6r_l113g3KJEtg?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=VDjVfq');

  double? elevationCard1 = 1.0;
  double elevationCard2 = 1.0;
  double elevationCard3 = 1.0;
  double elevationCard4 = 1.0;
  double elevationCard5 = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    // Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "VIDEOS",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: primary, fontWeight: FontWeight.w900),
            ),
            // const SizedBox(width: 100),
            // ElevatedButton(
            //   onPressed: () {
            //     //pop context
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Datos'),
            // ),
            // const SizedBox(width: 10),
            // ElevatedButton(
            //   onPressed: () {},
            //   style:
            //       ElevatedButton.styleFrom(backgroundColor: primaryContainer),
            //   child: const Text('Videos'),
            // ),
            // const SizedBox(width: 10),
            // BlocSelector<MainBloc, MainState, Registros?>(
            //   selector: (state) => state.registros,
            //   builder: (context, state) {
            //     bool isDataOk = (state?.registrosList.length ?? 0) > 0;
            //     return ElevatedButton(
            //       onPressed: isDataOk
            //           ? () {
            //               descarga.ahora(
            //                   datos: state!.registrosList, nombre: 'SAMAT2');
            //             }
            //           : null,
            //       child: const Text('Descarga'),
            //     );
            //   },
            // ),
          ],
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: () {
        //       context.read<MainBloc>().add(LoadData());
        //     },
        //   ),
        //   const SizedBox(width: 10),
        //   IconButton(
        //     onPressed: () {
        //       showDialog(
        //         builder: (context) {
        //           return AlertDialog(
        //             title: const Text('Escoge un color'),
        //             content: SingleChildScrollView(
        //               child: MaterialColorPicker(
        //                 allowShades: false,
        //                 onMainColorChange: (value) {
        //                   BlocProvider.of<MainBloc>(context).add(
        //                       ThemeColorChange(
        //                           color: Color(int.parse(value
        //                               .toString()
        //                               .substring(
        //                                   value.toString().indexOf('Color(0') +
        //                                       6,
        //                                   value.toString().indexOf(')'))))));
        //                   Navigator.of(context).pop();
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //         context: context,
        //       );
        //     },
        //     icon: const Icon(Icons.color_lens),
        //   ),
        //   const SizedBox(width: 10),
        //   IconButton(
        //     onPressed: () {
        //       BlocProvider.of<MainBloc>(context).add(ThemeChange());
        //     },
        //     icon: const Icon(Icons.brightness_4_outlined),
        //   ),
        //   const SizedBox(width: 10),
        //   IconButton(
        //     icon: Icon(
        //       Icons.logout,
        //       color: primary,
        //       size: 16,
        //     ),
        //     onPressed: () async => await FirebaseAuth.instance.signOut(),
        //   )
        // ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Version.data,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              Version.status('Home', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
      ],
      body: Center(
        child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()async{ await launchUrl(conciliacion);}, child: const Text('Como realizar una Conciliacion')),
            ElevatedButton(onPressed: ()async{ await launchUrl(salidaNormal);}, child: const Text('Como realizar una salida normal')),
            ElevatedButton(onPressed: ()async{ await launchUrl(salidaWbe);}, child: const Text('Como realizar una salida WBE')),
            ElevatedButton(onPressed: ()async{ await launchUrl(obtenerPDF);}, child: const Text('Como Obtener PDF')),
            ElevatedButton(onPressed: ()async{ await launchUrl(reintegro);}, child: const Text('Como realizar un reintegro')),
            ElevatedButton(onPressed: ()async{ await launchUrl(consultaSAP);}, child: const Text('Como consultar saldos en SAP')),
          ],
        ),
      ),
    );
  }
}
