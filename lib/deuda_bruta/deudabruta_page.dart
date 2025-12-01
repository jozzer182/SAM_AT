import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/deuda_bruta/deudabruta_model.dart';

import '../resources/descarga_hojas.dart';

class DeudaBrutaPage extends StatefulWidget {
  const DeudaBrutaPage({Key? key}) : super(key: key);

  @override
  State<DeudaBrutaPage> createState() => _DeudaBrutaPageState();
}

class _DeudaBrutaPageState extends State<DeudaBrutaPage> {
  bool loading = false;
  bool isSearching = false;

  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DEUDA BRUTA')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.deudaBruta?.deudaBrutaList;
          if (data == null) return Center(child: CircularProgressIndicator());
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: data, nombre: 'DeudaBruta'),
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
              .add(Busqueda(value: value, table: "deudaBruta")),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.deudaBruta?.listaTitulo ?? [];
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
      builder: (context,s) {
        if (s.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            List<DeudaBrutaSingle>? data = state.deudaBruta?.deudaBrutaListSearch;
            if (data == null) return Center(child: CircularProgressIndicator());
            return tableData(
              datos: data,
              itemsAndFlex: state.deudaBruta?.itemsAndFlex ?? {},
              keys: state.deudaBruta?.keys ?? [],
            );
          },
        );
      }
    );
  }

  Widget tableData({
    required List<DeudaBrutaSingle> datos,
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
            {'texto': datoSing[key], 'flex': itemsAndFlex[key], 'index': key},
        ];
        bool esIngreso = int.parse(datos[index].faltanteUnidades) > 0;
        return Center(
          child: Container(
            color:
                esIngreso ? Theme.of(context).colorScheme.errorContainer : null,
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
        );
      },
    );
  }
}
