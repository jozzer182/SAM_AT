import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/deuda_almacen/deudaalmacen_model.dart';
import 'package:samat2co/resources/descarga_hojas.dart';



class SobranteAlmacenPage extends StatefulWidget {
  const SobranteAlmacenPage({Key? key}) : super(key: key);

  @override
  State<SobranteAlmacenPage> createState() => _SobranteAlmacenPageState();
}

class _SobranteAlmacenPageState extends State<SobranteAlmacenPage> {
  bool loading = false;
  bool isSearching = false;
  // TextEditingController busqueda = TextEditingController();
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DEUDA ALMACÉN')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List<DeudaAlmacenSingle>? completo2 =
              state.deudaAlmacen?.deudaAlmacen;
          if (completo2 == null) {
            return Center(child: CircularProgressIndicator());
          }
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: completo2, nombre: 'DeudaAlmacen'),
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
          // controller: busqueda,
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
              .add(Busqueda(value: value, table: "deudaAlmacen")),
        ),
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.deudaAlmacen?.listaTitulo ?? [];
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
            List<DeudaAlmacenSingle>? completo2 =
                state.deudaAlmacen?.deudaAlmacenListSearch2;
            if (completo2 == null) {
              return Center(child: Text('error'));
            }
            return tableData(
              datos: completo2,
              itemsAndFlex: state.deudaAlmacen?.itemsAndFlex ?? {},
              keys: state.deudaAlmacen?.keys ?? [],
            );
          },
        );
      }
    );
  }

  Widget tableData({
    required List<DeudaAlmacenSingle> datos,
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
        Color? fondo ;
        if( int.parse(datos[index].faltanteUnidades) > 0 ) fondo  = Colors.red[100];
        if( int.parse(datos[index].faltanteUnidades) < 0 ) fondo  = Colors.orange[100];        
        return Center(
          child: Container(
            color:fondo,
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
                      style: Theme.of(context).textTheme.bodySmall,
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
