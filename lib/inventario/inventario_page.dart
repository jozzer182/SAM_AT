import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/inventario/inventario_model.dart';
import 'package:samat2co/resources/descarga_hojas.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({Key? key}) : super(key: key);

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
    final ScrollController _controller = ScrollController();

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      // print('Cargando más');
      BlocProvider.of<MainBloc>(context).add(ListLoadMore(table: 'inventario'));
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
      appBar: AppBar(title: Text('INVENTARIO')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.inventario?.inventarioList;
          if (data == null) return Center(child: CircularProgressIndicator());
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: data, nombre: 'Inventario'),
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
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
          onChanged: (value) {
            context
                .read<MainBloc>()
                .add(Busqueda(value: value, table: "inventario"));
          },
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.inventario?.listaTitulo ?? [];
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
              List<InventarioSingle>? data =
                  state.inventario?.inventarioListSearch;
              if (data == null)
                return Center(child: CircularProgressIndicator());
              return tableData(
                datos: data,
                itemsAndFlex: state.inventario?.itemsAndFlex ?? {},
                keys: state.inventario?.keys ?? [],
              );
            },
          );
        });
  }

  Widget tableData({
    required List<InventarioSingle> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        var datoSing = datos[index].toMap();
        List listaDato = [
          for (var key in keys)
            {'texto': datoSing[key], 'flex': itemsAndFlex[key], 'index': key},
        ];
        return Center(
          child: Row(
            children: [
              for (var dato in listaDato)
                Expanded(
                  flex: dato['flex'],
                  child: SelectableText(
                    dato['texto'],
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
