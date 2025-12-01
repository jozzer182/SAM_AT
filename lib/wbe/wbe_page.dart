// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rtd_test1/Base/main_bloc.dart';
// import 'package:rtd_test1/model/version.dart';
// import 'package:rtd_test1/resources/descarga_hojas.dart';
// import 'package:intl/intl.dart';
// import 'package:rtd_test1/wbe/wbe_model.dart';

// class WbePage extends StatefulWidget {
//   const WbePage({super.key});

//   @override
//   State<WbePage> createState() => _WbePageState();
// }

// class _WbePageState extends State<WbePage> {
//   final uSFormat = NumberFormat.currency(
//     locale: "en_US",
//     symbol: "\$",
//     decimalDigits: 0,
//   );
//   int endList = 70;
//   final ScrollController _controller = ScrollController();

//   _onScroll() {
//     if (_controller.offset >= _controller.position.maxScrollExtent &&
//         !_controller.position.outOfRange) {
//       BlocProvider.of<MainBloc>(context).add(
//         ListLoadMore(table: 'wbe'),
//       );
//     }
//   }

//   @override
//   void initState() {
//     _controller.addListener(_onScroll);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // List<MaestroSingle> data = context.read<MainBloc>().maestro.maestroList;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('WBE'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: BlocSelector<MainBloc, MainState, bool>(
//             selector: (state) => state.isLoading,
//             builder: (context, state) {
//               // print('called');
//               return state ? LinearProgressIndicator() : SizedBox();
//             },
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               context.read<MainBloc>().add(LoadData());
//             },
//           ),

//         ],
//       ),
//       persistentFooterButtons: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               Version().data,
//               style: Theme.of(context).textTheme.labelSmall,
//             ),
//             Text(
//               "Conectado como: ${FirebaseAuth.instance.currentUser!.email}, Fecha y hora: ${DateTime.now().toString()}, Página actual: WbePage",
//               style: Theme.of(context).textTheme.labelSmall,
//             )
//           ],
//         ),
//       ],
//       floatingActionButton: BlocSelector<MainBloc, MainState, Wbe?>(
//         selector: (state) => state.wbe,
//         builder: (context, state) {
//           return state == null
//               ? CircularProgressIndicator()
//               : FloatingActionButton(
//                   onPressed: () => DescargaHojas()
//                       .ahora(datos: state.wbeList, nombre: 'WBE'),
//                   child: Icon(Icons.download),
//                 );
//         },
//       ),
//       body: body(),
//     );
//   }

//   Widget body() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Text(
//             'Estas son las WBE los proyectos y su respectivo estado', 
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           SizedBox(height: 20),
//           searchField(),
//           SizedBox(height: 20),
//           titleRow(),
//           futureMng(),
//         ],
//       ),
//     );
//   }

//   Widget searchField() {
//     return Center(
//       child: SizedBox(
//         width: 300,
//         child: TextField(
//           // controller: busqueda,
//           decoration: InputDecoration(
//             prefixIcon: IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 // context.read<MainBloc>().add(Busqueda(busqueda.text));
//               },
//             ),
//             border: OutlineInputBorder(),
//             labelText: 'Búsqueda',
//           ),
//           onChanged: (value) {
//             context.read<MainBloc>().add(
//                   Busqueda(value: value, table: "wbe"),
//                 );
//           },
//         ),
//       ),
//     );
//   }

//   Widget titleRow() {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         var listaTitulo = state.wbe?.listaTitulo ?? [];
//         return Row(
//           children: [
//             for (var titulo in listaTitulo)
//               Expanded(
//                 flex: titulo['flex'],
//                 child: Text(
//                   titulo['texto'].toString().toUpperCase(),
//                   style: Theme.of(context).textTheme.titleMedium,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget futureMng() {
//     return FutureBuilder(
//       future: Future.delayed(Duration(milliseconds: 200)),
//       builder: (context, s) {
//         if (s.connectionState != ConnectionState.done)
//           return CircularProgressIndicator();
//         return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
//           if (state.wbe == null) return CircularProgressIndicator();
//           List<WbeSingle> lista = state.wbe?.wbeListSearch ?? [];
//           int endList = (state.wbe?.view ?? 0) > lista.length
//               ? lista.length
//               : state.wbe?.view ?? 0;
//           return tableData(
//             datos: lista.sublist(0, endList),
//             itemsAndFlex: state.wbe?.itemsAndFlex ?? {},
//             keys: state.wbe?.keys ?? [],
//           );
//         });
//       },
//     );
//   }

//   Widget tableData(
//       {required List<WbeSingle> datos,
//       required Map itemsAndFlex,
//       required List keys}) {
//     return Expanded(
//       child: SingleChildScrollView(
//         controller: _controller,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: datos.length,
//           itemBuilder: (context, index) {
//             Map datoSing = datos[index].toMap();
//             List listaDato = [
//               for (var key in keys)
//                 {
//                   'texto': datoSing[key],
//                   'flex': itemsAndFlex[key][0],
//                   'index': key
//                 },
//             ];
//             bool esIngreso = false;
//             return Center(
//               child: Container(
//                 color: esIngreso
//                     ? Theme.of(context).colorScheme.errorContainer
//                     : null,
//                 child: Row(
//                   children: [
//                     for (var dato in listaDato)
//                       Expanded(
//                         flex: dato['flex'],
//                         child: SelectableText(
//                           dato['index'] != 'valor'
//                               ? dato['texto']
//                               : uSFormat.format(int.parse(dato['texto'])),
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall!
//                               .copyWith(
//                                   color: esIngreso
//                                       ? Theme.of(context)
//                                           .colorScheme
//                                           .onErrorContainer
//                                       : Theme.of(context)
//                                           .colorScheme
//                                           .onBackground),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
