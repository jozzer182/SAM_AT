import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/mb51/mb51_model.dart';
import 'package:samat2co/registros/registro_fila_model.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_registros_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../planilla/model/planilla_model.dart';
import '../planilla/view/planilla_page.dart';
import '../resources/animacion_pagina.dart';

class PorCodigoPage extends StatefulWidget {
  PorCodigoPage({Key? key}) : super(key: key);

  @override
  State<PorCodigoPage> createState() => _PorCodigoPageState();
}

class _PorCodigoPageState extends State<PorCodigoPage> {
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Análisis por código'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        searchField(),
        Divider(),
        Text(
          'MB51',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleMB51(),
        tableMB51(),
        Divider(),
        Text(
          'INGRESOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleIngresos(),
        tableIngresos(),
        Divider(),
        Text(
          'SALIDAS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSalidas(),
        tableSalidas(),
        // Expanded(child: Text('some text')),
      ],
    );
  }

  Widget searchField() {
    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          // controller: busqueda,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // context.read<MainBloc>().add(Busqueda(busqueda.text));
              },
            ),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
          onChanged: (value) {
            if (value.length == 6) {
              context
                  .read<MainBloc>()
                  .add(Busqueda(value: value, table: 'mb51'));
              context.read<MainBloc>().add(
                    Busqueda(
                      value: value,
                      table: "registrosimple",
                    ),
                  );
              context.read<MainBloc>().add(
                    BuscarRemisiones(value),
                  );
            }
          },
        ),
      ),
    );
  }

  // MB51 table --------------------------------------------------
  Widget tableMB51() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // titleMB51(),
            futureMgtMB51(),
          ],
        ),
      ),
    );
  }

  Widget titleMB51() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.mb51?.listaTitulo2 ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget futureMgtMB51() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 800)),
      builder: (context, s) {
        if (s.connectionState == ConnectionState.done) {
          return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
            List<Mb51Single> lista = state.mb51?.mb51ListSearch ?? [];
            int endList = (state.mb51?.view ?? 0) > lista.length
                ? lista.length
                : state.mb51?.view2 ?? 0;

            return tableDataMb51(
              datos: lista.sublist(0, endList),
              itemsAndFlex: state.mb51?.itemsAndFlex2 ?? {},
              keys: state.mb51?.keys2 ?? [],
            );
          });
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget tableDataMb51({
    required List<Mb51Single> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        Map datoSing = datos[index].toMap();
        List listaDato = [
          for (var key in keys)
            {
              'texto': datoSing[key],
              'flex': itemsAndFlex[key][0],
              'index': key,
            },
        ];
        bool esIngreso = datos[index].cmv == "221" ||
            datos[index].cmv == "261" ||
            datos[index].cmv == "281";
        return Center(
          child: Container(
            color: esIngreso ? Colors.green[100] : null,
            child: Row(
              children: [
                for (var dato in listaDato)
                  Expanded(
                    flex: dato['flex'],
                    child: SelectableText(
                      dato['index'] != 'valor'
                          ? dato['texto']
                          : uSFormat.format(int.parse(dato['texto'])),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: esIngreso
                              ? Theme.of(context).colorScheme.onErrorContainer
                              : Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // INGRESOS table --------------------------------------------------
  Widget tableIngresos() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // titleMB51(),
            futureMgtIngresos(),
          ],
        ),
      ),
    );
  }

  Widget titleIngresos() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.remisiones?.listaTitulo ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget futureMgtIngresos() {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300)),
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return Center(child: const CircularProgressIndicator());
          }
          return BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<RemisionesRegistros>? data =
                  state.remisiones?.registrosListSearch;
              if (data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              int endList = (state.remisiones?.view ?? 0) > data.length
                  ? data.length
                  : state.remisiones?.view ?? 0;
              return tableDataIngresos(
                datos: data.sublist(0, endList),
                itemsAndFlex: state.remisiones?.itemsAndFlex ?? {},
                keys: state.remisiones?.keys ?? [],
              );
            },
          );
        });
  }

  Widget tableDataIngresos({
    required List<RemisionesRegistros> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        // print('remisionesSingle: ${datos[index]}');
        var datoSing = datos[index].toMap();
        // print('datoSing: $datoSing');
        List listaDato = [
          for (var key in keys)
            {
              'texto': key == 'X' ? 'X' : datoSing[key],
              'flex': itemsAndFlex[key],
              'index': key
            },
        ];
        return Center(
          child: Container(
            color: datos[index].estado == 'anulado' ? Colors.grey : null,
            child: Row(
              children: [
                for (var dato in listaDato)
                  Expanded(
                    flex: dato['flex'],
                    child: dato['index'] == 'soporte_r'
                        ? SizedBox(
                            height: 16,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 16,
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onPressed: () {
                                String url = datos[index].soporte_r.isEmpty
                                    ? datos[index].soporte_i
                                    : datos[index].soporte_r;
                                launchUrl(Uri.parse(url));
                              },
                              icon: Icon(Icons.download),
                            ),
                          )
                        : dato['index'] == 'X'
                            ? Container()
                            : SelectableText(
                                dato['texto'],
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // SALIDAS -----------------------------------------------------
  Widget tableSalidas() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // titleMB51(),
            futureMgtSalidas(),
          ],
        ),
      ),
    );
  }

  Widget titleSalidas() {
    List listaTitulo = [
      {'texto': 'Pedido', 'flex': 2},
      {'texto': 'Lcl', 'flex': 2},
      {'texto': 'Destino', 'flex': 2},
      {'texto': 'Con', 'flex': 1},
      {'texto': 'Adj', 'flex': 1},
      {'texto': 'Item', 'flex': 1},
      {'texto': 'E4e', 'flex': 2},
      {'texto': 'Descripción', 'flex': 6},
      {'texto': 'Um', 'flex': 1},
      {'texto': 'Ctd total', 'flex': 1},
      {'texto': 'Fecha', 'flex': 2},
      {'texto': 'Usuario', 'flex': 4},
      // {'texto': 'x', 'flex': 1},
    ];
    return Row(
      children: [
        for (var titulo in listaTitulo)
          Expanded(
            flex: titulo['flex'],
            child: Text(
              titulo['texto'],
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget futureMgtSalidas() {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 400)),
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<ResgistroFila>? data = state.planillas?.registrosListSearch;
              if (data == null) {
                return Center(child: const CircularProgressIndicator());
              }
              int endList = (state.planillas?.view ?? 0) > data.length
                  ? data.length
                  : state.planillas?.view ?? 0;
              return tableDataSalidas(
                datos: data.sublist(0, endList),
              );
            },
          );
        });
  }

  Widget tableDataSalidas({required List<ResgistroFila> datos}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        ResgistroFila datoSing = datos[index];
        List listaDato = [
          {'texto': datoSing.pedido, 'flex': 2, 'index': 'pedido'},
          {'texto': datoSing.lcl, 'flex': 2, 'index': 'lcl'},
          {'texto': datoSing.destino, 'flex': 2, 'index': 'proyecto'},
          {'texto': datoSing.planilla, 'flex': 1, 'index': 'proyecto'},
          {'texto': datoSing.soporte_e, 'flex': 1, 'index': 'soporte_i'},
          {'texto': datoSing.item, 'flex': 1, 'index': 'item'},
          {'texto': datoSing.e4e, 'flex': 2, 'index': 'e4e'},
          {'texto': datoSing.descripcion, 'flex': 6, 'index': 'descripcion'},
          {'texto': datoSing.um, 'flex': 1, 'index': 'um'},
          {'texto': datoSing.ctd_total, 'flex': 1, 'index': 'ctd'},
          {'texto': datoSing.fecha_e, 'flex': 2, 'index': 'fecha_i'},
          {'texto': datoSing.ingeniero_enel, 'flex': 4, 'index': 'fecha_i'},
          // {'texto': datoSing.est_oficial, 'flex': 2, 'index': 'est_oficial'},
          // {'texto': null, 'flex': 1, 'index': 'estado'},
        ];
        Color color = Colors.transparent;
        if (datoSing.est_oficial == 'sapenconfirmacion' ||
            datoSing.est_oficial == 'confirmado' ||
            datoSing.est_oficial == 'Aprobado') {
          color = Colors.green[100]!;
        }
        if (datoSing.est_oficial == 'anulado') {
          color = Colors.red[100]!;
        }
        void goTo(Widget page) => Navigator.push(context, createRoute(page));
        // print(datos[index].toMap());
        return Center(
          child: Container(
            color: datoSing.est_oficial == 'anulado' ? Colors.grey : color,
            child: InkWell(
              onDoubleTap: () {
                Planilla planilla = context
                    .read<MainBloc>()
                    .state
                    .planillas!
                    .planillasList
                    .firstWhere((element) =>
                        element.cabecera.pedido == datoSing.pedido);
                BlocProvider.of<MainBloc>(context)
                    .add(SeleccionarPlanilla(planilla: planilla));
                goTo(
                  const PlanillaPage(
                    esNuevo: false,
                  ),
                );
              },
              child: Row(
                children: [
                  for (var dato in listaDato)
                    Expanded(
                      flex: dato['flex'],
                      child: dato['index'] == 'soporte_i'
                          ? downloadButton(dato)
                          : SelectableText(
                              dato['texto'],
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                      // ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget downloadButton(dato) {
    return SizedBox(
      height: 16,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        iconSize: 12,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        onPressed: () {
          launchUrl(Uri.parse(dato['texto']));
        },
        icon: const Icon(Icons.download),
      ),
    );
  }
}
