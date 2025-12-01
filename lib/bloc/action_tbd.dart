import 'package:samat2co/bloc/main_bloc.dart';



// onValidarPlanilla(
//   ValidarPlanilla event,
//   emit,
//   MainState Function() state,
//   add,
// ) async {
//   emit(state().copyWith(isLoading: true));
//   if (event.tabla == "planilla") {
//     if (state().planilla?.validar != null) {
//       emit(state().copyWith(
//         dialogCounter: state().dialogCounter + 1,
//         dialogMessage: state().planilla?.validar?.join('\n'),
//       ));
//     } else {
//       String? respuesta;
//       try {
//         respuesta = await state().planilla?.enviar(state().user!);
//         add(Load());
//         Navigator.pop(event.context);
//         // Get.back();
//       } catch (e) {
//         emit(state().copyWith(
//           errorCounter: state().errorCounter + 1,
//           message:
//               '🤕Error enviando los datos de la planilla: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
//         ));
//       }
//       emit(state().copyWith(
//         dialogCounter: state().dialogCounter + 1,
//         dialogMessage: respuesta ?? 'Error en el envío',
//       ));
//       // Get.back();
//     }
//   }
//   // if (event.tabla == "planillaedit") {
//   //   if (state().planillaEdit?.validar != null) {
//   //     emit(state().copyWith(
//   //       dialogCounter: state().dialogCounter + 1,
//   //       dialogMessage: state().planillaEdit?.validar?.join('\n'),
//   //     ));
//   //   } else {
//   //     String? respuesta;
//   //     try {
//   //       respuesta = await state().planillaEdit?.enviar(state().user!);
//   //       add(Load());
//   //       Navigator.pop(event.context);
//   //       // Get.back();
//   //     } catch (e) {
//   //       emit(state().copyWith(
//   //         errorCounter: state().errorCounter + 1,
//   //         message:
//   //             '🤕Error enviando los datos de la planilla Editada: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
//   //       ));
//   //     }
//   //     emit(state().copyWith(
//   //       dialogCounter: state().dialogCounter + 1,
//   //       dialogMessage: respuesta ?? 'Error en el envío',
//   //     ));
//   //   }
//   // }
//   // if (event.tabla == "planillaeditmateriales") {
//   //   if (state().planillaEdit?.validar != null) {
//   //     emit(state().copyWith(
//   //       dialogCounter: state().dialogCounter + 1,
//   //       dialogMessage: state().planillaEdit?.validar?.join('\n'),
//   //     ));
//   //   } else {
//   //     String? respuesta;
//   //     try {
//   //       respuesta = await state().planillaEdit?.enviarNuevo(state().user!);
//   //       add(Load());
//   //       Navigator.pop(event.context);
//   //       // Get.back();
//   //     } on Exception catch (e) {
//   //       emit(state().copyWith(
//   //         errorCounter: state().errorCounter + 1,
//   //         message:
//   //             '🤕Error enviando los datos de la planilla materiales: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
//   //       ));
//   //     }
//   //     emit(state().copyWith(
//   //       dialogCounter: state().dialogCounter + 1,
//   //       dialogMessage: respuesta ?? 'Error en el envío',
//   //     ));
//   //   }
//   // }
//   if (event.tabla == "nuevoIngreso") {
//     var ref1 = state().nuevoIngreso?.validar;
//     if (ref1 != null) {
//       emit(state().copyWith(
//         dialogCounter: state().dialogCounter + 1,
//         dialogMessage: ref1.join('\n'),
//       ));
//     } else {
//       String? respuesta;
//       try {
//         respuesta = await state().nuevoIngreso?.enviar(state().user!);
//         add(Load());
//       } catch (e) {
//         emit(state().copyWith(
//           errorCounter: state().errorCounter + 1,
//           message:
//               '🤕Error enviando los datos del nuevo ingreso: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
//         ));
//       }
//       emit(state().copyWith(
//         dialogCounter: state().dialogCounter + 1,
//         dialogMessage: respuesta ?? 'Error en el envío',
//       ));
//       // Get.back();
//     }
//   }
//   if (event.tabla == "nuevoTraslado") {
//     var ref1 = state().nuevoTraslado?.validar;
//     if (ref1 != null) {
//       emit(state().copyWith(
//         dialogCounter: state().dialogCounter + 1,
//         dialogMessage: ref1.join('\n'),
//       ));
//     } else {
//       String? respuesta;
//       try {
//         respuesta = await state().nuevoTraslado?.enviar(state().user!);
//         add(Load());
//       } catch (e) {
//         emit(state().copyWith(
//           errorCounter: state().errorCounter + 1,
//           message:
//               '🤕Error enviando los datos del nuevo traslado: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
//         ));
//       }
//       emit(state().copyWith(
//         dialogCounter: state().dialogCounter + 1,
//         dialogMessage: respuesta ?? 'Error en el envío',
//       ));
//       // Get.back();
//     }
//   }
//   emit(state().copyWith(isLoading: false));
// }

// onChangePlanilla(ChangePlanilla e, emit, MainState Function() state) {
//   if (e.tabla == "planilla") {
//     state().planilla!.asignar(
//           campo: e.campo,
//           valor: e.valor,
//           index: e.index,
//           lcl: state().lcl!,
//           people: state().people!,
//         );
//   }
//   // if (e.tabla == "planillaedit") {
//   //   var ref = state().planillaEdit!.encabezadoPlanillaParaEnvio;
//   //   if (e.campo == 'lcl') ref.lcl = e.valor;
//   //   if (e.campo == 'odm') ref.odm = e.valor;
//   //   if (e.campo == 'solicitante') ref.solicitante = e.valor;
//   //   if (e.campo == 'proceso') ref.proceso = e.valor;
//   //   if (e.campo == 'pdi') ref.pdi = e.valor;
//   //   if (e.campo == 'placa_cuadrilla_e') ref.placa_cuadrilla_e = e.valor;
//   //   if (e.campo == 'lider_contrato_e') ref.lider_contrato_e = e.valor;
//   //   if (e.campo == 'cc_lider_contrato_e') ref.cc_lider_contrato_e = e.valor;
//   //   if (e.campo == 'tel_lider_e') ref.tel_lider_e = e.valor;
//   //   if (e.campo == 'circuito') ref.circuito = e.valor;
//   //   if (e.campo == 'localidad_municipio') ref.localidad_municipio = e.valor;
//   //   if (e.campo == 'nodo') ref.nodo = e.valor;
//   //   if (e.campo == 'ingeniero_enel') ref.ingeniero_enel = e.valor;
//   //   if (e.campo == 'pdl') ref.pdl = e.valor;
//   //   if (e.campo == 'fecha_e') ref.fecha_e = e.valor;
//   //   if (e.campo == 'fecha_r') ref.fecha_r = e.valor;
//   //   if (e.campo == 'soporte_d_e') ref.soporte_d_e = e.valor;
//   //   if (e.campo == 'soporte_d_r') ref.soporte_d_r = e.valor;
//   //   if (e.campo == 'comentario_e') ref.comentario_e = e.valor;
//   //   if (e.campo == 'almacenista_e') ref.almacenista_e = e.valor;
//   //   if (e.campo == 'tel_alm_e') ref.tel_alm_e = e.valor;
//   // }
//   if (e.tabla == "nuevoIngreso") {
//     var ref = state().nuevoIngreso!.encabezado;
//     if (e.campo == "codigo_massy") ref.codigo_massy = e.valor;
//     if (e.campo == "soporte_i") ref.soporte_i = e.valor;
//     if (e.campo == "comentario") ref.comentario_i = e.valor;
//     if (e.campo == "fecha_i") ref.fecha_i = e.valor;
//   }
//   if (e.tabla == "nuevoTraslado") {
//     var ref = state().nuevoTraslado!.encabezado;
//     if (e.campo == "codigo_massy") ref.codigo_massy = e.valor;
//     if (e.campo == "soporte_i") ref.soporte_i = e.valor;
//     if (e.campo == "comentario") ref.comentario_i = e.valor;
//     if (e.campo == "fecha_i") ref.fecha_i = e.valor;
//   }

//   emit(state().copyWith());
// }

// onChangePlanillaList(
//   ChangePlanillaList e,
//   emit,
//   MainState Function() state,
// ) {
//   if (e.tabla == "planilla") {
//     Registro ref = state().planilla!.registros[e.index];
//     Mm60 mm60r = state().mm60!;
//     Mb52 mb52r = state().mb52!;
//     Inventario invr = state().inventario!;
//     if (e.e4e != null) ref.cambioE4e(e.e4e!, mm60r, mb52r, invr, state().user!);
//     if (e.ctd_e != null) ref.cambioCtdE(e.ctd_e!, mb52r, invr);
//     if (e.ctd_r != null) ref.cambioCtdR(e.ctd_r!, mb52r, invr);
//   }
//   // if (e.tabla == "planillaedit") {
//   //   var ref = state().planillaEdit!.planillaListParaEnvio[e.index];
//   //   var mm60r = state().mm60!;
//   //   var mb52r = state().mb52!;
//   //   var invr = state().inventario!;
//   //   if (e.e4e != null) ref.cambioE4e(e.e4e!, mm60r, mb52r, invr);
//   //   if (e.ctd_e != null) ref.cambioCtdE(e.ctd_e!, mb52r, invr);
//   //   if (e.ctd_r != null) ref.cambioCtdR(e.ctd_r!, mb52r, invr);
//   // }
//   if (e.tabla == "nuevoIngreso") {
//     var ref = state().nuevoIngreso!.nuevoIngresoList[e.index];
//     if (e.e4e != null) ref.cambioE4e(e.e4e!, state().mm60!);
//     if (e.ctd_e != null) ref.cambioCtd(e.ctd_e!);
//   }
//   if (e.tabla == "nuevoTraslado") {
//     var ref = state().nuevoTraslado!.nuevoTrasladoList[e.index];
//     if (e.e4e != null) ref.cambioE4e(e.e4e!, state().mm60!);
//     if (e.ctd_e != null) ref.cambioCtd(e.ctd_e!);
//   }

//   emit(state().copyWith());
// }

// onModifyPlanilla(ModifyPlanilla event, emit, MainState Function() state) {
//   if (event.table == "planilla")
//     state().planilla?.modifyList(event.index, event.method);
//   // if (event.table == "planillaedit")
//   //   state().planillaEdit?.modifyList(event.index, event.method);
//   if (event.table == "nuevoIngreso")
//     state().nuevoIngreso?.modifyList(event.index, event.method);
//   if (event.table == "nuevoTraslado")
//     state().nuevoTraslado?.modifyList(event.index, event.method);
//   emit(state().copyWith());
// }

// onSeleccionarPedido(SeleccionarPedido event, emit, MainState Function() state) {
//   PlanillaEdit planillaEdit = PlanillaEdit();
//   state().registros?.pedidoSelected = event.pedido;
//   planillaEdit.crear(state().registros!);
//   // print('pedidoSelected ${state().registros?.pedidoSelected}');
//   emit(state().copyWith(
//     planillaEdit: planillaEdit,
//   ));
//   // print('planillaEdit ${state.planillaEdit}');
// }

onBusquedaEspecifica(
  BusquedaEspecifica event,
  emit,
  MainState Function() state,
) async {
  emit(state().copyWith(isLoading: true));
  if (event.tabla == "deudaOperativa") {
    state()
        .deudaOperativa
        ?.busquedaEspecifica(event.e4e, event.funcional ?? '');
    emit(state().copyWith());
  }
  // if (event.tabla == "registros") {
  //   state().registros?.busquedaEspecifica(event.e4e, event.lcl ?? '');
  //   emit(state().copyWith());
  // }
  emit(state().copyWith(isLoading: false));
}
