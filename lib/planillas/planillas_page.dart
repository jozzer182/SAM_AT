import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/planilla/model/cabecera_model.dart';
import 'package:samat2co/planilla/model/planilla_model.dart';
import 'package:samat2co/planilla/view/planilla_page.dart';
import 'package:samat2co/resources/animacion_pagina.dart';
import 'package:intl/intl.dart';
import '../resources/descarga_hojas.dart';
import '../version.dart';

class PlanillasPage extends StatefulWidget {
  const PlanillasPage({super.key});

  @override
  State<PlanillasPage> createState() => _PlanillasPageState();
}

class _PlanillasPageState extends State<PlanillasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planillas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? const LinearProgressIndicator() : const SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          var snap = state.planillas?.registrosList;
          if (snap == null) {
            return const CircularProgressIndicator();
          }
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: snap, nombre: 'registros'),
            child: const Icon(Icons.download),
          );
        },
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
            ),
          ],
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<Planilla>? planillasList =
                  state.planillas?.planillasListSearch;
              if (planillasList == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  // Text(
                  //   'Planillas ${planillasList.length} ---> ${state.planillas?.planillasListSearch.length}',
                  //   style: Theme.of(context).textTheme.bodyMedium,
                  // ),
                  SearchField(),
                  const SizedBox(height: 4),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 360,
                      childAspectRatio: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 115,
                    ),
                    itemCount: planillasList.length,
                    itemBuilder: (context, index) {
                      return CardPlanilla(
                        planilla: planillasList[index],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CardPlanilla extends StatelessWidget {
  final Planilla planilla;
  final NumberFormat uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
    customPattern: "\$#,##0 M",
  );
  CardPlanilla({
    required this.planilla,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) => Navigator.push(context, createRoute(page));
    Cabecera cabecera = planilla.cabecera;
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        String numeroPlanilla = cabecera.pedido;
        bool hayRegistrosConciliacion = state.conciliacionesList!.list
            .map((e) => e.planilla)
            .contains(numeroPlanilla);
        Color colorConciliacion = Colors.yellow;
        if (planilla.estados.estado_enel.toUpperCase() != 'NONE' ||
            planilla.estados.estado_contrato.toUpperCase() == 'ANULADO') {
          colorConciliacion = Colors.green;
        }

        return InkWell(
          onTap: () {
            BlocProvider.of<MainBloc>(context)
                .add(SeleccionarPlanilla(planilla: planilla));
            goTo(
              const PlanillaPage(
                esNuevo: false,
              ),
            );
          },
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Texto de tamano 11
                    Text(
                      cabecera.pedido,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    if (cabecera.unidad == 'PM&C')
                      const Icon(
                        Icons.architecture,
                        size: 10,
                        color: Colors.grey,
                      )
                    else
                      const Icon(
                        Icons.handyman,
                        size: 10,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cabecera.destino),
                    Text(cabecera.lcl),
                    Text(cabecera.planilla),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //texto en cursiva o italica
                    Text(
                      cabecera.ingeniero_enel,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //texto en cursiva o italica
                    Text(
                      uSFormat.format(planilla.precio / 1000000),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Tooltip(
                    message: planilla.estados.estado,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: planilla.estados.estado_contratoColor,
                          ),
                        ),
                        const Gap(10),
                        if (hayRegistrosConciliacion)
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: colorConciliacion,
                            ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: planilla.estados.estado_enelColor,
                          ),
                        ),

                        // const SizedBox(width: 10),
                        // Expanded(
                        //   flex: 1,
                        //   child: Container(
                        //     color: planilla.estados.estado_sapColor,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}

class SearchField extends StatefulWidget {
  SearchField({
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController busqueda = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 161,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            controller: busqueda,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              labelText: 'Búsqueda',
            ),
            onChanged: (String value) {
              context.read<MainBloc>().planillasController.buscar(value);
              // context.read<MainBloc>().add(
              //       Busqueda(
              //         value: value,
              //         table: "registros",
              //       ),
              //     );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context
                .read<MainBloc>()
                .planillasController
                .planillasConConciliacion;
          },
          child: const Text('CONCILIACIONES'),
        ),
      ],
    );
  }
}
