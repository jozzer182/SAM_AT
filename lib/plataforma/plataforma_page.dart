// import 'dart:ffi';

// ignore_for_file: dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/plataforma/plataforma_model.dart';

import '../resources/descarga_hojas.dart';

class PlataformaPage extends StatefulWidget {
  PlataformaPage({Key? key}) : super(key: key);

  @override
  State<PlataformaPage> createState() => _PlataformaPageState();
}

class _PlataformaPageState extends State<PlataformaPage> {
  bool isLoading = true;
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
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
      BlocProvider.of<MainBloc>(context).add(ListLoadMore(table: 'plataforma'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLATAFORMA'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            BlocProvider.of<MainBloc>(context)
                .add(Busqueda(value: '', table: 'plataforma'));
          },
        ),
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, Plataforma?>(
        selector: (state) => state.plataforma,
        builder: (context, state) {
          return state == null
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: () => DescargaHojas()
                      .ahora(datos: state.plataformaList, nombre: 'PLATAFORMA'),
                  child: Icon(Icons.download),
                );
        },
      ),
      body:
          isLoading ? const Center(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            searchField(),
            const SizedBox(height: 8),
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
              .add(Busqueda(value: value, table: "plataforma")),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.plataforma?.listaTitulo2 ?? [];
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
      List<PlataformaSingle> lista =
          state.plataforma?.plataformaListSearch ?? [];
      int endList = (state.plataforma?.view ?? 0) > lista.length
          ? lista.length
          : state.plataforma?.view ?? 0;
      return Column(
        children: [
          tableData(
            datos: lista.sublist(0, endList),
            itemsAndFlex: state.plataforma?.itemsAndFlex2 ?? {},
            keys: state.plataforma?.keys2 ?? [],
          ),
          (endList > 99 || endList == 0)
              ? CircularProgressIndicator()
              : SizedBox(),
        ],
      );
    });
  }

  Widget tableData(
      {required List<PlataformaSingle> datos,
      required Map itemsAndFlex,
      required List keys}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        Map datoSing = datos[index].toMap();
        List listaDato = [
          for (var key in keys)
            {'texto': datoSing[key], 'flex': itemsAndFlex[key][0], 'index': key},
        ];
        bool esIngreso = false;
        // print('listBuilderCalled index $index datos.length ${datos.length}');
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
