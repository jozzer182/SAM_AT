// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/registros/registro_fila_model.dart';
import 'package:samat2co/resources/descarga_hojas.dart';
import 'package:url_launcher/url_launcher.dart';

import '../planilla/model/planilla_model.dart';
import '../planilla/view/planilla_page.dart';

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

class RegistrosPage extends StatefulWidget {
  @override
  State<RegistrosPage> createState() => _RegistrosPageState();
  // late bool isLoadingFuture;
}

class _RegistrosPageState extends State<RegistrosPage> {
  // late Future<List<IngresosModel>> future;
  // late Future<List<ResgistroSingle>> registrosFuture;
  bool isSearching = false;
  int view = 70;

  // widget.isLoadingFuture = false;
  TextEditingController busqueda = TextEditingController();
  List<Map<String, Object>> rows = [];
  DateTime dateReport = DateTime.now();

  final ScrollController _controller = ScrollController();

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      // print('Cargando más');
      BlocProvider.of<MainBloc>(context).add(ListLoadMore(table: 'resgistros'));
    }
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTROS'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? LinearProgressIndicator() : SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          var snap = state.planillas?.registrosList;
          if (snap == null) {
            return CircularProgressIndicator();
          }
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: snap, nombre: 'registros'),
            child: Icon(Icons.download),
          );
        },
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            searchField(),
            titleRow(),
            futureMng(),
          ],
        ),
      ),
    );
  }

  Widget searchField() {
    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: busqueda,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
          onChanged: (String value) {
            context.read<MainBloc>().add(
                  Busqueda(
                    value: value,
                    table: "registrosimple",
                  ),
                );
          },
        ),
      ),
    );
  }

  Widget titleRow() {
    List listaTitulo = [
      {'texto': 'Pedido', 'flex': 2},
      {'texto': 'Lcl', 'flex': 2},
      {'texto': 'Destino', 'flex': 2},
      // {'texto': 'Con', 'flex': 1},
      // {'texto': 'Adj', 'flex': 1},
      {'texto': 'Item', 'flex': 1},
      {'texto': 'E4e', 'flex': 2},
      {'texto': 'Descripción', 'flex': 6},
      {'texto': 'Um', 'flex': 1},
      {'texto': 'Ctd total', 'flex': 1},
      {'texto': 'Fecha', 'flex': 2},
      {'texto': 'Estado', 'flex': 2},
      {'texto': 'x', 'flex': 1},
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

  Widget futureMng() {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 600)),
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());
          return BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<ResgistroFila> data =
                  state.planillas?.registrosListSearch ?? [];
              int endList = (view) > data.length ? data.length : view;
              return tableData(
                datos: data.sublist(0, endList),
              );
            },
          );
        });
  }

  Widget tableData({
    required List<ResgistroFila> datos,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        ResgistroFila datoSing = datos[index];
        List listaDato = [
          {'texto': datoSing.pedido, 'flex': 2, 'index': 'pedido'},
          {'texto': datoSing.lcl, 'flex': 2, 'index': 'lcl'},
          {'texto': datoSing.destino, 'flex': 2, 'index': 'destino'},
          // {'texto': datoSing.odm, 'flex': 1, 'index': 'proyecto'},
          // {'texto': datoSing.soporte_d_r, 'flex': 1, 'index': 'soporte_i'},
          {'texto': datoSing.item, 'flex': 1, 'index': 'item'},
          {'texto': datoSing.e4e, 'flex': 2, 'index': 'e4e'},
          {'texto': datoSing.descripcion, 'flex': 6, 'index': 'descripcion'},
          {'texto': datoSing.um, 'flex': 1, 'index': 'um'},
          {'texto': datoSing.ctd_total, 'flex': 1, 'index': 'ctd'},
          {
            'texto': datoSing.est_oficial_fecha.isNotEmpty
                ? datoSing.est_oficial_fecha.substring(0, 10)
                : datoSing.est_oficial_fecha,
            'flex': 2,
            'index': 'fecha_i'
          },
          {'texto': datoSing.est_oficial, 'flex': 2, 'index': 'est_oficial'},
          {'texto': null, 'flex': 1, 'index': 'estado'},
        ];
        // print(datos[index].toMap());
        TextEditingController _controller =
            TextEditingController(text: datos[index].lcl);
        bool editLCL = false;
        void goTo(Widget page) {
          Navigator.push(context, _createRoute(page));
        }

        return Center(
          child: Container(
            color: datoSing.est_oficial == 'anulado' ? Colors.grey : null,
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
                          : dato['index'] == 'estado'
                              ? !context
                                      .read<MainBloc>()
                                      .state
                                      .user!
                                      .permisos
                                      .contains('anularRegistros')
                                  ? Container()
                                  : Container()
                              : dato['index'] == 'lcl'
                                  ? LclField(
                                      dato: datos[index],
                                      lcl: datos[index].lcl,
                                    )
                                  : InkWell(
                                      onLongPress: () {
                                        // print('long press');
                                        context.read<MainBloc>().add(
                                              SeleccionarPedido(
                                                  pedido: datoSing.pedido),
                                            );
                                        // goTo(PlanillaPageEdit());
                                      },
                                      child: SelectableText(
                                        dato['texto'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                    ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconButton downloadButton(dato) {
    return IconButton(
      iconSize: 12,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      onPressed: () {
        launchUrl(Uri.parse(dato['texto']));
      },
      icon: Icon(Icons.download),
    );
  }

  // Widget anularRegistro(ResgistroSingle datoSing) {
  //   return datoSing.est_oficial == 'anulado'
  //       ? Container()
  //       : IconButton(
  //           iconSize: 12,
  //           visualDensity: VisualDensity(horizontal: -4, vertical: -4),
  //           icon: Icon(Icons.delete),
  //           onPressed: () {
  //             showDialog(
  //               context: context,
  //               builder: (context) {
  //                 return AlertDialog(
  //                   title: Text('Atención'),
  //                   content: Text(
  //                       'Se anulará el registro seleccionado, esta acción no de podrá deshacer, ¿Desea contitnuar?'),
  //                   actions: [
  //                     TextButton(
  //                       child: Text('CANCELAR'),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                     TextButton(
  //                       child: Text('SI'),
  //                       onPressed: () {
  //                         context.read<MainBloc>().add(
  //                               AnularDato(
  //                                 id: datoSing.id,
  //                                 pedido: datoSing.pedido,
  //                                 item: datoSing.item,
  //                                 hoja: 'registros',
  //                                 tabla: 'registros',
  //                                 context: context,
  //                               ),
  //                             );
  //                       },
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         );
  // }
}

class LclField extends StatefulWidget {
  final String lcl;
  final ResgistroFila dato;
  LclField({
    Key? key,
    required this.lcl,
    required this.dato,
  }) : super(key: key);

  @override
  State<LclField> createState() => _LclFieldState();
}

class _LclFieldState extends State<LclField> {
  bool _editLCL = false;
  TextEditingController _controller = TextEditingController(text: "");

  @override
  void initState() {
    _controller.text = widget.lcl;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        print('long');
        // setState(() {
        //   _editLCL = !_editLCL;
        // });
      },
      child: SizedBox(
        height: 30,
        child: !_editLCL
            ? Center(child: Text(widget.lcl))
            : TextField(
                controller: TextEditingController(text: widget.lcl),
                enabled: _editLCL,
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  suffixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  suffixIcon: _editLCL
                      ? IconButton(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          padding: EdgeInsets.zero,
                          splashRadius: 14,
                          constraints:
                              BoxConstraints(minWidth: 2, minHeight: 0),
                          iconSize: 16,
                          tooltip: 'Guardar',
                          // hoverColor: Theme.of(context).colorScheme.primary,
                          icon: Icon(Icons.save),
                          onPressed: () {
                            // print('save');
                            // setState(() {
                            //   _editLCL = false;
                            // });
                            // context.read<MainBloc>().add(
                            //       CambioLCL(
                            //         map: widget.dato.toMap(),
                            //         lcl: _controller.text,
                            //         tabla: "registros",
                            //       ),
                            //     );
                          },
                        )
                      : null,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 1,
                  ),
                ),
              ),
      ),
    );
  }
}
