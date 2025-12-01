import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/remisiones/remision/view/remision_page.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_model.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_registros_model.dart';
import 'package:samat2co/resources/animacion_pagina.dart';
import 'package:samat2co/resources/descarga_hojas.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../version.dart';

class RemisionesPage extends StatefulWidget {
  const RemisionesPage({super.key});

  @override
  State<RemisionesPage> createState() => _RemisionesPageState();
}

class _RemisionesPageState extends State<RemisionesPage> {
  final ScrollController _controller = ScrollController();
  int view = 60;

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

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() => view += 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REMISIONES'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? const LinearProgressIndicator() : const SizedBox();
            },
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Version.data,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              Version.status('Remisiones', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          var snap = state.remisiones?.registrosList;
          if (snap == null) {
            return const CircularProgressIndicator();
          }
          return FloatingActionButton(
            onPressed: () =>
                DescargaHojas().ahora(datos: snap, nombre: 'remisiones'),
            child: const Icon(Icons.download),
          );
        },
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.remisiones == null) {
                return const Center(child: CircularProgressIndicator());
              }
              List<RemisionesRegistros> lista =
                  state.remisiones!.registrosListSearch;
              int endList = view > lista.length ? lista.length : view;
              List<TitleModel> titles = state.remisiones!.titles;
              return Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<MainBloc>().add(
                            BuscarRemisiones(value),
                          );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (TitleModel titulo in titles)
                        Expanded(
                          flex: titulo.flex,
                          child: Text(
                            titulo.title.toString().toUpperCase(),
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: endList,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (state.user!.permisos
                              .contains('editar_remision')) {
                            context.read<MainBloc>().add(
                                  SeleccionarRemision(
                                    lista[index].pedido,
                                  ),
                                );
                            goTo(const RemisionPage(esNuevo: false), context);
                          }
                        },
                        child: Row(
                          children: [
                            for (TitleModel titulo in titles)
                              Expanded(
                                flex: titulo.flex,
                                child: Builder(builder: (context) {
                                  if (titulo.key == 'soporte_i') {
                                    return IconButton(
                                      onPressed: () async {
                                        launchUrl(Uri.parse(
                                            lista[index].toMap()[titulo.key]));
                                      },
                                      icon: const Icon(Icons.picture_as_pdf),
                                    );
                                  }
                                  if (titulo.key == 'fecha_i') {
                                    return Text(
                                      DateTime.parse(
                                              lista[index].toMap()[titulo.key])
                                          .toString()
                                          .substring(0, 10),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                  return Text(
                                    lista[index].toMap()[titulo.key],
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                    textAlign: TextAlign.center,
                                  );
                                }),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
