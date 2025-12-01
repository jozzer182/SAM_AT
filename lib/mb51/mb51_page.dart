import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/mb51/mb51_model.dart';

import '../resources/descarga_hojas.dart';

class Mb51Page extends StatefulWidget {
  Mb51Page({Key? key}) : super(key: key);

  @override
  State<Mb51Page> createState() => _Mb51PageState();
}

class _Mb51PageState extends State<Mb51Page> {
  bool isLoading = true;
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  String busqueda = '';
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    Timer(const Duration(milliseconds: 800), () {
      setState(() => isLoading = false);
    });
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      BlocProvider.of<MainBloc>(context).add(ListLoadMore(table: 'mb51'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MB51'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            // BlocProvider.of<MainBloc>(context)
            //     .add(Busqueda(value: '', table: 'Mb51B'));
          },
        ),
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, Mb51?>(
        selector: (state) => state.mb51,
        builder: (context, state) {
          return state == null
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: () => DescargaHojas()
                      .ahora(datos: state.mb51List, nombre: 'MB51'),
                  child: const Icon(Icons.download),
                );
        },
      ),
      body: body(),
    );
  }

  Widget body() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                    'Para buscar, escriba algo y de clic en el icono de búsqueda'),
                searchField(),
                const SizedBox(height: 8),
                titleRow(),
                futureMng(),
              ],
            ),
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
              icon: const Icon(Icons.search),
              onPressed: () {
                context.read<MainBloc>().add(
                      Busqueda(value: busqueda, table: 'mb51'),
                    );
              },
            ),
            border: const OutlineInputBorder(),
            labelText: 'Búsqueda',
            // errorText: 'Para buscar de click en el icono de busqueda',
          ),
          onChanged: (value) => busqueda = value,
          // context
          //     .read<MainBloc>()
          //     .add(Busqueda(value: value, table: "Mb51B")),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.mb51?.listaTitulo2 ?? [];
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
      List<Mb51Single> lista = state.mb51?.mb51ListSearch ?? [];
      int endList = (state.mb51?.view ?? 0) > lista.length
          ? lista.length
          : state.mb51?.view ?? 0;
      return Expanded(
        child: SingleChildScrollView(
          controller: _controller,
          child: tableData(
            datos: lista.sublist(0, endList),
            itemsAndFlex: state.mb51?.itemsAndFlex2 ?? {},
            keys: state.mb51?.keys2 ?? [],
          ),
        ),
      );
    });
  }

  Widget tableData(
      {required List<Mb51Single> datos,
      required Map itemsAndFlex,
      required List keys}) {
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
              'index': key
            },
        ];
        bool esIngreso = int.parse(datos[index].ctd) > 0;
        return Container(
          width: double.infinity,
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
        );
      },
    );
  }
}
