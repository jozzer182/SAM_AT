import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_model.dart';
import 'package:samat2co/registros/registros_page.dart';
import 'package:samat2co/resources/descarga_hojas.dart';

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

class DeudaOperativaPage extends StatefulWidget {
  const DeudaOperativaPage({Key? key}) : super(key: key);

  @override
  State<DeudaOperativaPage> createState() => _DeudaOperativaPageState();
}

class _DeudaOperativaPageState extends State<DeudaOperativaPage> {
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  String filter = '';
  int endList = 70;
  bool firstTimeLoading = true;
  final ScrollController _controller = ScrollController();
  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        firstTimeLoading = false;
      });
    });
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstTimeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('DEUDA OPERATIVA')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.deudaOperativa?.deudaOperativa;
          if (data == null) return Center(child: CircularProgressIndicator());
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: data, nombre: 'DeudaOperativa'),
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
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
          onChanged: (value) => setState(() {
            filter = value;
          }),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.deudaOperativa?.listaTitulo ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString().toUpperCase(),
                  style: TextStyle()
                      .copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget futureMng() {
    return
        // FutureBuilder(
        //     future: Future.delayed(Duration(milliseconds: 600)),
        //     builder: (context, s) {
        //       if (s.connectionState != ConnectionState.done)
        //         return Center(child: CircularProgressIndicator());
        //       return
        BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        List<DeudaOperativaSingle>? data =
            state.deudaOperativa?.deudaOperativaListSearch;
        if (data == null) return Center(child: CircularProgressIndicator());
        return tableData(
          datos: data,
          itemsAndFlex: state.deudaOperativa?.itemsAndFlex ?? {},
          keys: state.deudaOperativa?.keys ?? [],
        );
      },
    );
    // });
  }

  Widget tableData({
    required List<DeudaOperativaSingle> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    datos = datos
        .where(
          (e) => e.toList().any(
                (el) => el.toLowerCase().contains(
                      filter.toLowerCase(),
                    ),
              ),
        )
        .toList();

    if (datos.length > endList) {
      datos = datos.sublist(0, endList);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        Map datoSing = datos[index].toMap();
        List listaDato = [
          for (var key in keys)
            {'texto': datoSing[key], 'flex': itemsAndFlex[key], 'index': key},
        ];
        Color? fondo;
        if (int.parse(datos[index].faltanteUnidades) > 0)
          fondo = Theme.of(context).colorScheme.errorContainer;
        if (int.parse(datos[index].faltanteUnidades) > 0 && int.parse(datos[index].faltanteUnidades) > int.parse(datos[index].mb52))
          fondo = Colors.yellow[100];
        if (int.parse(datos[index].faltanteUnidades) < 0)
          fondo = Theme.of(context).colorScheme.surfaceVariant;
        bool esIngreso = int.parse(datos[index].faltanteUnidades) > 0;
        return InkWell(
          onLongPress: () {
            // print('tap');
            context.read<MainBloc>().add(
                  BusquedaEspecifica(
                    tabla: 'registros',
                    e4e: datos[index].e4e,
                    lcl: datos[index].lcl,
                  ),
                );
            goTo(RegistrosPage());
          },
          child: Center(
            child: Container(
              color: fondo,
              child: Row(
                children: [
                  for (var dato in listaDato)
                    Expanded(
                      flex: dato['flex'],
                      child: SelectableText(
                        dato['index'] != 'faltanteValor'
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
          ),
        );
      },
    );
  }
}
