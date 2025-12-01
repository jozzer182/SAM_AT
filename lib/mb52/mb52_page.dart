// import 'dart:ffi';

// ignore_for_file: dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/mb52/mb52_model.dart';
import 'package:samat2co/resources/descarga_hojas.dart';

class Mb52Page extends StatefulWidget {
  Mb52Page({Key? key}) : super(key: key);

  @override
  State<Mb52Page> createState() => _Mb52PageState();
}

class _Mb52PageState extends State<Mb52Page> {
  bool isLoading = true;
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  void initState() {
    Timer(const Duration(milliseconds: 800), () {
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MB52'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            BlocProvider.of<MainBloc>(context).add(
              Busqueda(value: '', table: 'mb52'),
            );
          },
        ),
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, Mb52?>(
        selector: (state) => state.mb52,
        builder: (context, state) {
          return state == null
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: () => DescargaHojas()
                      .ahora(datos: state.mb52List, nombre: 'MB52'),
                  child: Icon(Icons.download),
                );
        },
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : body(),
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
          // controller: busqueda,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
          onChanged: (value) => context
              .read<MainBloc>()
              .add(Busqueda(value: value, table: "mb52")),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.mb52?.listaTitulo2 ?? [];
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
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      return tableData(
        datos: state.mb52?.mb52ListSearch ?? [],
        itemsAndFlex: state.mb52?.itemsAndFlex2 ?? {},
        keys: state.mb52?.keys2 ?? [],
      );
    });
  }

  Widget tableData({
    required List<Mb52Single> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        Map datoSing = datos[index].toMap();
        // print('from view MB52: $datoSing');
        List listaDato = [
          for (var key in keys)
            {
              'texto': datoSing[key],
              'flex': itemsAndFlex[key][0],
              'index': key
            },
        ];
        bool esIngreso = false;
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
}
