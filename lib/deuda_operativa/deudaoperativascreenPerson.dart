import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_model.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_page.dart';
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

class DeudaOperativaPersonPage extends StatefulWidget {
  const DeudaOperativaPersonPage({Key? key}) : super(key: key);

  @override
  State<DeudaOperativaPersonPage> createState() =>
      _DeudaOperativaPersonPageState();
}

class _DeudaOperativaPersonPageState extends State<DeudaOperativaPersonPage> {
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
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
          onChanged: (value) => context
              .read<MainBloc>()
              .add(Busqueda(value: value, table: "deudaOperativa")),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.deudaOperativa?.listaTitulo2 ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString().toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
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
              List<DeudaOperativaSingle>? data =
                  state.deudaOperativa?.deudaOperativaPersonSearch;
              if (data == null)
                return Center(child: CircularProgressIndicator());
              return tableData(
                datos: data,
                itemsAndFlex: state.deudaOperativa?.itemsAndFlex2 ?? {},
                keys: state.deudaOperativa?.keys2 ?? [],
              );
            },
          );
        });
  }

  Widget tableData({
    required List<DeudaOperativaSingle> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        Map datoSing = datos[index].toMap();
        List listaDato = [
          for (var key in keys)
            {
              'texto': datoSing[key],
              'flex': itemsAndFlex[key],
              'index': key,
            },
        ];
        Color? fondo;
        if (int.parse(datos[index].faltanteUnidades) > 0)
          fondo = Theme.of(context).colorScheme.errorContainer;
        if (int.parse(datos[index].faltanteUnidades) < 0)
          fondo = Theme.of(context).colorScheme.surfaceVariant;
        bool esIngreso = int.parse(datos[index].faltanteUnidades) > 0;
        // print('datoSing: $datoSing');
        // print('keys: $keys');
        return InkWell(
          onLongPress: () {
            // print('tap');
            context.read<MainBloc>().add(
                  BusquedaEspecifica(
                    tabla: 'deudaOperativa',
                    e4e: datos[index].e4e,
                    funcional: datos[index].funcional,
                  ),
                );
            goTo(DeudaOperativaPage());
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
