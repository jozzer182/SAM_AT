import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/planilla/model/cabecera_model.dart';
import 'package:samat2co/planilla/model/estados_model.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';
import 'package:samat2co/planilla/model/planilla_model.dart';
import 'package:samat2co/planilla/view/dialogs/anular_dialog.dart';
import 'package:samat2co/planilla/view/dialogs/guardar_dialog.dart';
import 'package:samat2co/planilla/view/dialogs/rechazar_dialog.dart';
import 'package:samat2co/planilla/view/planilla_fields_v1.dart';
import 'package:samat2co/user/user_model.dart';

import 'dialogs/conversaciones_dialog.dart';
import 'dialogs/mensaje_conciliacion_dialog.dart';

class EstadosPage extends StatefulWidget {
  final bool editandoPlanilla;
  const EstadosPage({
    required this.editandoPlanilla,
    super.key,
  });

  @override
  State<EstadosPage> createState() => _EstadosPageState();
}

class _EstadosPageState extends State<EstadosPage> {
  bool edit = true;
  bool contratoEdit = false;
  bool enelEdit = false;
  bool sapEdit = false;
  late bool hayRegistrosConciliacion;
  bool mostrarConciliacion = false;

  @override
  void initState() {
    String planilla = context.read<MainBloc>().state.planilla!.cabecera.pedido;
    hayRegistrosConciliacion = context
        .read<MainBloc>()
        .state
        .conciliacionesList!
        .list
        .map((e) => e.planilla)
        .contains(planilla);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editandoPlanilla) {
      return const SizedBox();
    }
    Color primary = Theme.of(context).colorScheme.primary;
    TextStyle titleMedium = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: primary,
          fontWeight: FontWeight.w900,
        );
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.planilla == null ||
            state.planillas == null ||
            state.user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        User user = state.user!;
        contratoEdit = user.permisos.contains("estados_contrato");
        enelEdit = user.permisos.contains("estados_enel");
        sapEdit = user.permisos.contains("estados_sap");
        Planilla planilla = state.planilla!;
        Cabecera cabecera = planilla.cabecera;
        Estados estados = planilla.estados;

        mostrarConciliacion = hayRegistrosConciliacion;

        // print('estados.fechareg_pre: ${estados.fechareg_pre}');
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tarjeta(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Text(
                      'Contrato',
                      style: titleMedium,
                    ),
                    Icon(
                      Icons.build,
                      color: primary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Estado: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: estados.estado_contratoColor,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    TextSpan(
                      text: estados.estado_contrato.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: estados.estado_contratoColor,
                          ),
                    ),
                  ]),
                ),
                const Divider(),
                Text(
                  'Borrador',
                  style: TextStyle(
                    color: primary,
                  ),
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: cabecera.comentario,
                  flex: null,
                  campo: CampoPlanilla.comentario,
                  label: 'Comentario Planilla',
                  color: Colors.grey[300]!,
                  edit: contratoEdit,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.fechareg_r.isEmpty
                      ? ''
                      : DateTime.parse(estados.fechareg_r)
                          .toString()
                          .substring(0, 16),
                  flex: null,
                  campo: CampoPlanilla.fechareg_r,
                  label: 'Fecha registro',
                  color: Colors.grey[300]!,
                  edit: false,
                  tipoCampo: TipoCampo.fecha,
                ),
                const SizedBox(height: 10),
                const Divider(),
                Text(
                  'Solicitud',
                  style: TextStyle(
                    color: primary,
                  ),
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.comentario_s,
                  flex: null,
                  campo: CampoPlanilla.comentario_s,
                  label: 'Comentario Solicitud',
                  color: estados.comentario_sColor,
                  edit: contratoEdit,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.soporte_informe,
                  flex: null,
                  campo: CampoPlanilla.soporte_informe,
                  label: 'Informe Trabajos',
                  color: estados.soporte_informeColor,
                  edit: contratoEdit,
                  tipoCampo: TipoCampo.file,
                  carpeta: 'informe',
                  pdi: state.user!.pdi,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: state.planilla!.estados.fechareg_s.isEmpty
                      ? ''
                      : DateTime.parse(state.planilla!.estados.fechareg_s)
                          .toString()
                          .substring(0, 16),
                  flex: null,
                  campo: CampoPlanilla.fechareg_s,
                  label: 'Fecha Solicitud',
                  color: Colors.grey[300]!,
                  edit: false,
                  tipoCampo: TipoCampo.fecha,
                ),
                const SizedBox(height: 10),
                Builder(builder: (context) {
                  bool guardarEnabled = contratoEdit &&
                      estados.comentario_s.isNotEmpty &&
                      estados.estado_enel != 'aprobado' &&
                      estados.estado_enel != 'saperror';
                  bool anularEnabled =
                      contratoEdit && estados.estado_enel != 'aprobado';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: !anularEnabled
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AnularDialog();
                                  },
                                );
                              },
                        child: const Text('ANULAR'),
                      ),
                      TextButton(
                        onPressed: !guardarEnabled
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const GuardarDialog();
                                  },
                                );
                              },
                        child: const Text('GUARDAR'),
                      ),
                    ],
                  );
                }),
              ],
            ),
            Builder(
              builder: (context) {
                if (hayRegistrosConciliacion) {
                  return Tarjeta(
                    flex: 2,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Text(
                            'Conciliación',
                            style: titleMedium,
                          ),
                          Icon(
                            Icons.handshake_outlined,
                            color: primary,
                          ),
                        ],
                      ),
                      const Gap(120),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ConversacionesDialog();
                            },
                          );
                        },
                        child: const Text(
                          "Ver Mensajes",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(10),
                      if (estados.estado_contrato.toUpperCase() ==
                              "SOLICITADO" &&
                          estados.estado_enel.toUpperCase() == "NONE")
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const MensajeConciliacionDialog(
                                  esNuevo: false,
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Agregar\nMensaje",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const Gap(120),
                    ],
                  );
                }
                if (estados.estado_contrato.toUpperCase() == "SOLICITADO" &&
                    estados.estado_enel.toUpperCase() == "NONE" &&
                    enelEdit) {
                  return Tarjeta(
                    flex: 2,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Text(
                            'Conciliación',
                            style: titleMedium,
                          ),
                          Icon(
                            Icons.handshake_outlined,
                            color: primary,
                          ),
                        ],
                      ),
                      const Gap(120),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const MensajeConciliacionDialog(
                                esNuevo: true,
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Iniciar\nConcilicación",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(120),
                    ],
                  );
                }
                return Gap(2);
              },
            ),

            Tarjeta(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text(
                      'Enel',
                      style: titleMedium,
                    ),
                    Icon(
                      Icons.corporate_fare,
                      color: primary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Estado: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: estados.estado_enelColor,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    TextSpan(
                      text: estados.estado_enel.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: estados.estado_enelColor,
                          ),
                    ),
                  ]),
                ),
                const Divider(),
                Text(
                  'Pre - Aprobación',
                  style: TextStyle(
                    color: primary,
                  ),
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.comentario_pre,
                  flex: null,
                  campo: CampoPlanilla.comentario_pre,
                  label: 'Comentario Pre Aprobación',
                  color: estados.comentario_preColor,
                  edit: enelEdit,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.estadoreg_pre,
                  flex: null,
                  campo: CampoPlanilla.estadoreg_pre,
                  label: 'PREAPROBAR',
                  color: Colors.grey[300]!,
                  edit: enelEdit,
                  tipoCampo: TipoCampo.switcher,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.fechareg_pre.isEmpty
                      ? ''
                      : DateTime.parse(estados.fechareg_pre)
                          .toString()
                          .substring(0, 16),
                  flex: null,
                  campo: CampoPlanilla.fechareg_pre,
                  label: 'Fecha Pre Aprobación',
                  color: Colors.grey[300]!,
                  edit: false,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(height: 10),
                const Divider(),
                Text(
                  'Aprobación',
                  style: TextStyle(
                    color: primary,
                  ),
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.comentario_sap,
                  flex: null,
                  campo: CampoPlanilla.comentario_sap,
                  label: 'Comentario SAP',
                  color: estados.comentario_sapColor,
                  edit: enelEdit,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.numero_sap.isEmpty
                      ? estados.numero_sap
                      : jsonDecode(estados.numero_sap)["numero_sap"].join(','),
                  flex: null,
                  campo: CampoPlanilla.numero_sap,
                  label: 'Número SAP',
                  color: estados.numero_sapColor,
                  edit: enelEdit,
                  tipoCampo: TipoCampo.texto,
                  isNumber: true,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.soporte_sap,
                  flex: null,
                  campo: CampoPlanilla.soporte_sap,
                  label: 'PDF SAP',
                  color: estados.soporte_sapColor,
                  edit: enelEdit,
                  tipoCampo: TipoCampo.file,
                  carpeta: 'informe',
                  pdi: state.user!.pdi,
                ),
                const SizedBox(height: 10),
                FieldPre(
                  initialValue: estados.fechareg_sap.isEmpty
                      ? ''
                      : DateTime.parse(estados.fechareg_sap)
                          .toString()
                          .substring(0, 16),
                  flex: null,
                  campo: CampoPlanilla.fechareg_sap,
                  label: 'Fecha Aprobación',
                  color: Colors.grey[300]!,
                  edit: false,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(height: 10),
                Builder(builder: (context) {
                  bool guardarEnabled = enelEdit &&
                      ((estados.comentario_sap.isNotEmpty &&
                              estados.numero_sap.isNotEmpty) ||
                          (estados.comentario_pre.isNotEmpty &&
                              estados.estadoreg_pre == "true")) &&
                      estados.estado_sap != 'confirmado';
                  bool anularEnabled = enelEdit &&
                      estados.estado_enel != 'aprobado' &&
                      estados.estado_enel != 'saperror' &&
                      estados.estado_contrato == 'solicitado';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: !anularEnabled
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const RechazarDialog();
                                  },
                                );
                              },
                        child: const Text('RECHAZAR'),
                      ),
                      TextButton(
                        onPressed: !guardarEnabled
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const GuardarDialog();
                                  },
                                );
                              },
                        child: const Text('GUARDAR'),
                      ),
                    ],
                  );
                }),
              ],
            ),
            // Tarjeta(
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const SizedBox(),
            //         Text(
            //           'SAP',
            //           style: titleMedium,
            //         ),
            //         Icon(
            //           Icons.cloud,
            //           color: primary,
            //         ),
            //       ],
            //     ),
            //     const SizedBox(height: 10),
            //     RichText(
            //       text: TextSpan(children: [
            //         TextSpan(
            //           text: 'Estado: ',
            //           style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //                 color: estados.estado_sapColor,
            //                 fontWeight: FontWeight.w900,
            //               ),
            //         ),
            //         TextSpan(
            //           text: estados.estado_sap.toUpperCase(),
            //           style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //                 color: estados.estado_sapColor,
            //               ),
            //         ),
            //       ]),
            //     ),
            //     const SizedBox(height: 10),
            //     FieldPre(
            //       initialValue: estados.comentario_confirmado,
            //       flex: null,
            //       campo: CampoPlanilla.comentario_confirmado,
            //       label: 'Comentario Confirmación',
            //       color: estados.comentario_confirmadoColor,
            //       edit: sapEdit,
            //       tipoCampo: TipoCampo.texto,
            //     ),
            //     const SizedBox(height: 10),
            //     FieldPre(
            //       initialValue: estados.estado_confirmado,
            //       flex: null,
            //       campo: CampoPlanilla.estado_confirmado,
            //       label: 'CONFIRMADO',
            //       color: estados.estado_confirmadoColor,
            //       edit: sapEdit,
            //       tipoCampo: TipoCampo.switcher,
            //     ),
            //     const SizedBox(height: 10),
            //     FieldPre(
            //       initialValue: estados.fechareg_confirmado.isEmpty
            //           ? ''
            //           : DateTime.parse(estados.fechareg_confirmado)
            //               .toString()
            //               .substring(0, 16),
            //       flex: null,
            //       campo: CampoPlanilla.fechareg_confirmado,
            //       label: 'Fecha Confirmación',
            //       color: estados.fechareg_confirmadoColor,
            //       edit: false,
            //       tipoCampo: TipoCampo.fecha,
            //     ),
            //     const SizedBox(height: 10),
            //     Builder(builder: (context) {
            //       bool guardar = sapEdit &&
            //           estados.comentario_confirmado.isNotEmpty &&
            //           estados.estado_sap == 'sapenconfirmacion';
            //       bool anularEnabled = enelEdit &&
            //           estados.estado_sap != 'confirmado' &&
            //           estados.estado_enel != 'saperror' &&
            //           estados.estado_enel == 'aprobado';
            //       return Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           TextButton(
            //             onPressed: !anularEnabled
            //                 ? null
            //                 : () {
            //                     showDialog(
            //                       context: context,
            //                       builder: (BuildContext context) {
            //                         return const ForzarErrorDialog();
            //                       },
            //                     );
            //                   },
            //             child: const Text('RECHAZAR'),
            //           ),
            //           TextButton(
            //             onPressed: !guardar
            //                 ? null
            //                 : () {
            //                     showDialog(
            //                       context: context,
            //                       builder: (BuildContext context) {
            //                         return const GuardarDialog();
            //                       },
            //                     );
            //                   },
            //             child: const Text('GUARDAR'),
            //           ),
            //         ],
            //       );
            //     }),
            //   ],
            // ),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Tarjeta extends StatelessWidget {
  final List<Widget> children;
  int flex = 3;

  Tarjeta({
    required this.children,
    this.flex = 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
