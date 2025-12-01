// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/inventario/inventario_model.dart';
import 'package:samat2co/planilla/model/cabecera_model.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';
import 'package:samat2co/planilla/view/planilla_page_estados.dart';
import 'package:samat2co/registros/registro_fila_model.dart';
import 'package:samat2co/planilla/model/registro_model.dart';
import 'package:samat2co/planilla/view/planilla_buttons.dart';
import 'package:samat2co/planilla/view/planilla_fields_v1.dart';

import 'package:samat2co/planilla/view/planilla_edit_pdf.dart';

import 'package:samat2co/user/user_model.dart';

import '../../lcl/model/lcl_model.dart';
import '../../resources/animacion_pagina.dart';
import '../../videos/videos_page.dart';

class PlanillaPage extends StatefulWidget {
  final bool esNuevo;
  const PlanillaPage({
    required this.esNuevo,
    Key? key,
  }) : super(key: key);

  @override
  State<PlanillaPage> createState() => _PlanillaPageState();
}

class _PlanillaPageState extends State<PlanillaPage> {
  TextEditingController rowsController = TextEditingController();
  TextEditingController fileUploadController = TextEditingController();
  bool loadingFile = false;
  late Future<String> planillaNumber;
  bool editAllFields = false;

  loading(bool estado) {
    setState(() {
      loadingFile = estado;
    });
  }

  edit() {
    setState(() => editAllFields = !editAllFields);
  }

  @override
  void initState() {
    planillaNumber = context.read<MainBloc>().state.planilla!.lastNumberReg;
    //limpiar la planilla para enviar una nueva en caso de que sea nuevo
    if (widget.esNuevo) {
      context.read<MainBloc>().add(PlanillaNuevo());
      editAllFields = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    rowsController.dispose();
    fileUploadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
            future: planillaNumber,
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (!widget.esNuevo) {
                return Text(
                    'Planilla No. ${context.read<MainBloc>().state.planilla?.cabecera.pedido} estado: ${context.read<MainBloc>().state.planilla?.estados.estado}');
              }
              if (snapshot.data == null) {
                return Row(
                  children: const [
                    Text('Planilla No.'),
                    SizedBox(width: 10),
                    CircularProgressIndicator(),
                  ],
                );
              }
              return Text(
                  'Planilla No. ${snapshot.data} estado: ${context.read<MainBloc>().state.planilla?.estados.estado}');
            }),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state || loadingFile
                  ? const LinearProgressIndicator()
                  : const SizedBox();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, createRoute(const VideosPage()));
            },
            child: const Text("Videos"),
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              // print('state.planilla!.estados.mensajes_r ${state.planilla?.estados.mensajes_r}');
              if (state.planilla?.estados != null &&
                  state.planilla!.estados.mensajes_r.isNotEmpty) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Mensajes"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var mensaje in jsonDecode(
                                  state.planilla!.estados.mensajes_r))
                                SelectableText.rich(
                                  TextSpan(
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${mensaje['mensaje'] ?? 'sin mensaje'} - ",
                                      ),
                                      TextSpan(
                                        text:
                                            "${mensaje['persona'] ?? 'sin autor'} - ",
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${mensaje['fecha'].substring(0, 10) ?? 'sin fecha'}",
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Ver Mensajes'),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.planilla == null || editAllFields) {
                return const SizedBox();
              }
              return ElevatedButton(
                onPressed: () => generatePdf(planilla: state.planilla!),
                child: const Text('PDF'),
              );
            },
          ),
          const SizedBox(width: 10),
          Builder(
            builder: (context) {
              if (!editAllFields) {
                return const SizedBox();
              }
              return ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  BlocProvider.of<MainBloc>(context).add(
                    ValidarPlanilla(
                      esNuevo: widget.esNuevo,
                      context: context,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 10),
          ButtonEditar(
            edit: edit,
            esNuevo: widget.esNuevo,
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.planilla == null || state.planillas == null) {
            return const Center(child: CircularProgressIndicator());
          }
          User user = state.user!;
          Cabecera data = state.planilla!.cabecera;
          List<Registro> registros = state.planilla?.registros ?? [];
          List<ResgistroFila> registrosList = state.planillas!.registrosList;
          List<LclSingle> lcl = state.lcl?.lclList ?? [];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Builder(builder: (context) {
                    if (widget.esNuevo) {
                      return const SizedBox();
                    }
                    return EstadosPage(
                      editandoPlanilla: editAllFields,
                    );
                  }),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          flex: 3,
                          initialValue: data.lcl,
                          campo: CampoPlanilla.lcl,
                          label: 'LCL/TICKET',
                          color: data.lclColor,
                          edit: editAllFields,
                          isNumber: true,
                          opciones: lcl.map((e) => e.lcl.trim().toLowerCase()),
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.desplegable,
                          flex: 1,
                          color: data.unidadColor,
                          campo: CampoPlanilla.unidad,
                          label: 'UNIDAD',
                          initialValue: data.unidad,
                          edit: editAllFields,
                          opciones: const ['PM&C', 'ORA'],
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.desplegable,
                          flex: 2,
                          edit: editAllFields,
                          color: data.tipo_movimientoColor,
                          campo: CampoPlanilla.tipo_movimiento,
                          label: 'TIPO MOVIMIENTO',
                          initialValue: data.tipo_movimiento,
                          opciones: const ['Salida', 'Entrada'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList
                              .map((e) => e.planilla.trim().toLowerCase()),
                          campo: CampoPlanilla.planilla,
                          label: 'CONSECUTIVO',
                          color: data.planillaColor(
                            planillas: registrosList
                                .map((e) => e.planilla.trim().toLowerCase()),
                            esNuevo: widget.esNuevo,
                          ),
                          initialValue: data.planilla,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList
                              .map((e) => e.destino.trim().toLowerCase()),
                          campo: CampoPlanilla.destino,
                          label: 'SUBESTACIÓN - LINEA',
                          color: data.destinoColor,
                          initialValue: data.destino,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList
                              .map((e) => e.solicitante.trim().toLowerCase()),
                          campo: CampoPlanilla.solicitante,
                          label: 'INGENIERO A CARGO',
                          color: data.solicitanteColor,
                          initialValue: data.solicitante,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          initialValue: data.contrato,
                          flex: 1,
                          campo: CampoPlanilla.contrato,
                          label: 'CONTRATO',
                          color: data.contratoColor,
                          edit: editAllFields,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          initialValue: data.pdi,
                          flex: 1,
                          campo: CampoPlanilla.pdi,
                          label: 'PDI',
                          color: data.pdiColor,
                          edit: editAllFields,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          initialValue: data.nombre_pdi,
                          flex: 1,
                          campo: CampoPlanilla.nombre_pdi,
                          label: 'NOMBRE PDI',
                          color: data.nombre_pdiColor,
                          edit: editAllFields,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 3,
                          opciones: registrosList
                              .map((e) => e.proyecto.trim().toLowerCase()),
                          campo: CampoPlanilla.proyecto,
                          label: 'PROYECTO',
                          color: data.proyectoColor,
                          initialValue: data.proyecto,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 2,
                          opciones:
                              registrosList.map((e) => e.proceso.toLowerCase()),
                          campo: CampoPlanilla.proceso,
                          label: 'PROCESO',
                          color: data.procesoColor,
                          initialValue: data.proceso,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList.map(
                              (e) => e.lider_contrato_e.trim().toLowerCase()),
                          campo: CampoPlanilla.lider_contrato_e,
                          label: 'FUNCIONAL CONTRATO',
                          color: data.lider_contrato_eColor,
                          initialValue: data.lider_contrato_e,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList.map(
                              (e) => e.placa_cuadrilla_e.trim().toLowerCase()),
                          campo: CampoPlanilla.placa_cuadrilla_e,
                          label: 'PLACA MOVIL',
                          color: data.placa_cuadrilla_eColor,
                          initialValue: data.placa_cuadrilla_e,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.desplegable,
                          edit: editAllFields,
                          flex: 2,
                          opciones: (state.people?.people ?? [])
                              .map((e) => e.name.toLowerCase())
                              .toSet(),
                          color: data.ingeniero_enelColor,
                          campo: CampoPlanilla.ingeniero_enel,
                          label: 'RESPONSABLE ENEL',
                          initialValue: data.ingeniero_enel,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList
                              .map((e) => e.pdl.trim().toLowerCase()),
                          campo: CampoPlanilla.pdl,
                          label: 'PDL o ID',
                          color: data.pdlColor,
                          initialValue: data.pdl,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          edit: editAllFields,
                          flex: 1,
                          opciones: registrosList
                              .map((e) => e.tel_lider_e.trim().toLowerCase()),
                          campo: CampoPlanilla.tel_lider_e,
                          label: 'TEL CUADRILLERO',
                          color: data.tel_lider_eColor,
                          initialValue: data.tel_lider_e,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.fecha,
                          edit: editAllFields,
                          opciones: const [],
                          flex: 1,
                          initialValue: data.fecha_e,
                          campo: CampoPlanilla.fecha_e,
                          label: 'FECHA ENTREGA',
                          color: data.fecha_eColor,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.fecha,
                          edit: editAllFields,
                          opciones: const [],
                          flex: 1,
                          initialValue: data.fecha_r,
                          campo: CampoPlanilla.fecha_r,
                          label: 'FECHA REINTEGRO',
                          color: data.fecha_rColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          edit: editAllFields,
                          tipoCampo: TipoCampo.file,
                          flex: 1,
                          initialValue: data.soporte_e,
                          carpeta: 'entregado',
                          pdi: state.user!.pdi,
                          campo: CampoPlanilla.soporte_e,
                          label: 'SOPORTE ADJUNTO',
                          color: data.soporte_eColor,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          edit: editAllFields,
                          tipoCampo: TipoCampo.texto,
                          color: Colors.grey,
                          flex: 3,
                          campo: CampoPlanilla.comentario,
                          label: 'OBSERVACIONES',
                          initialValue: data.comentario,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          flex: 1,
                          initialValue:
                              widget.esNuevo ? user.correo : data.almacenista_e,
                          campo: CampoPlanilla.almacenista_e,
                          label: 'ALMACENISTA QUE ENTREGA',
                          color: data.almacenista_eColor,
                          edit: editAllFields,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          tipoCampo: TipoCampo.texto,
                          flex: 1,
                          initialValue:
                              widget.esNuevo ? user.telefono : data.tel_alm_e,
                          campo: CampoPlanilla.tel_alm_e,
                          label: 'TEL ALMACENISTA QUE ENTREGA',
                          color: data.tel_alm_eColor,
                          edit: editAllFields,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ButtonControlRows(
                    // controller: controller,
                    rowsController: rowsController,
                    edit: true,
                    esNuevo: widget.esNuevo,
                  ),
                  const SizedBox(height: 10),
                  const Title(),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      return RowPlanilla(
                        data: registros[index],
                        index: index,
                        edit: editAllFields,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          flex: 1,
          child: Text('Item'),
        ),
        Expanded(
          flex: 1,
          child: Text('e4e'),
        ),
        Expanded(
          flex: 3,
          child: Text('Descripción'),
        ),
        Expanded(
          flex: 1,
          child: Text('Um'),
        ),
        Expanded(
          flex: 1,
          child: Text('Entregado'),
        ),
        Expanded(
          flex: 1,
          child: Text('Reintegrado'),
        ),
        Expanded(
          flex: 1,
          child: Text('Instalado'),
        ),
      ],
    );
  }
}

class RowPlanilla extends StatelessWidget {
  TextEditingController ctdeController = TextEditingController();
  TextEditingController ctdrController = TextEditingController();
  bool edit;

  Registro data;
  int index;

  RowPlanilla({
    required this.data,
    required this.index,
    required this.edit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ctdeController.value = ctdeController.value.copyWith(
      text: '${data.ctd_e}',
      selection: TextSelection.collapsed(offset: '${data.ctd_e}'.length),
    );
    ctdrController.value = ctdrController.value.copyWith(
      text: '${data.ctd_r}',
      selection: TextSelection.collapsed(offset: '${data.ctd_r}'.length),
    );

    if (!edit) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('${data.item}'),
          ),
          Expanded(
            flex: 1,
            child: Text('${data.e4e}'),
          ),
          Expanded(
            flex: 3,
            child: Text('${data.descripcion}'),
          ),
          Expanded(
            flex: 1,
            child: Text('${data.um}'),
          ),
          Expanded(
            flex: 1,
            child: Text('${data.ctd_e}'),
          ),
          Expanded(
            flex: 1,
            child: Text('${data.ctd_r}'),
          ),
          Expanded(
            flex: 1,
            child: Text('${data.ctd_total}'),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text('${data.item}'),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: Autocomplete<InventarioSingle>(
              // initialValue: TextEditingValue(text: data.e4e),
              displayStringForOption: (option) {
                return option.e4e;
              },
              optionsBuilder: (textEditingValue) {
                return context
                    .read<MainBloc>()
                    .state
                    .inventario!
                    .inventarioList
                    .where((e) => e.e4e
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Material(
                  child: SizedBox(
                    width: 300,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, i) {
                        InventarioSingle option = options.toList()[i];
                        String textOption =
                            '${option.e4e} - ${option.descripcion} - ctd: ${option.ctd} ${option.um}';
                        return ListTile(
                          title: Text(textOption,
                              style: const TextStyle(fontSize: 14)),
                          onTap: () {
                            onSelected(options.toList()[i]);
                            context.read<MainBloc>().add(
                                  ChangePlanillaList(
                                    index: index,
                                    tabla: 'planilla',
                                    e4e: options.toList()[i].e4e,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                textEditingController.value =
                    textEditingController.value.copyWith(
                  text: data.e4e,
                  selection: TextSelection.collapsed(offset: data.e4e.length),
                );

                return TextField(
                  controller: textEditingController, // Required by autocomplete
                  focusNode: focusNode, // Required by autocomplete
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) {
                    context.read<MainBloc>().add(
                          ChangePlanillaList(
                            index: index,
                            tabla: 'planilla',
                            e4e: value,
                          ),
                        );
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.e4eColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.e4eColor, width: 2),
                    ),
                    labelText: 'E4e',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(data.descripcion),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  data.esMb52
                      ? const SizedBox()
                      : const Text(
                          'No está en MB52',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  data.esInv
                      ? const SizedBox()
                      : const Text(
                          'No está en Inventario',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${data.um} (${data.ctdMb52}) {${data.ctdInv}}',
            style: TextStyle(color: data.ctdEColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: ctdeController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                context.read<MainBloc>().add(
                      ChangePlanillaList(
                        index: index,
                        tabla: 'planilla',
                        ctd_e: value,
                      ),
                    );
              },
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ctd',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: ctdrController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                context.read<MainBloc>().add(
                      ChangePlanillaList(
                        index: index,
                        tabla: 'planilla',
                        ctd_r: value,
                      ),
                    );
              },
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ctd',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${data.ctd_total}',
            textAlign: TextAlign.center,
            style: TextStyle(color: data.ctdEColor),
          ),
        ),
      ],
    );
  }
}
