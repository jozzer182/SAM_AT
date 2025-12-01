import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/inventario/inventario_model.dart';
import 'package:samat2co/mb52/mb52_model.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/planilla/model/planilla_model.dart';
import 'package:samat2co/planilla/model/registro_model.dart';

import '../../bloc/main_bloc.dart';

onLoadPlanilla(event, emit, MainState Function() supraState) async {
  Planilla planilla = Planilla.nuevo();
  try {
    planilla.crear(
      user: supraState().user!,
      pdis: supraState().pdis!,
      mm60: supraState().mm60!,
    );
    emit(supraState().copyWith(planilla: planilla));
    // print('planilla: ${supraState().planilla?.planillaList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de planilla ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

onSeleccionarPlanilla(
  SeleccionarPlanilla ev,
  Emitter em,
  MainState Function() supraState,
) {
  supraState().planilla = ev.planilla;
}

onSeleccionarEstado(
  SeleccionarEstado ev,
  Emitter em,
  MainState Function() supraState,
) {
  supraState().planilla!.estados.estadoVista = ev.estado;
  em(supraState().copyWith(planilla: supraState().planilla!));
}

onValidarPlanilla(
  ValidarPlanilla event,
  Emitter emit,
  MainState Function() state,
  add,
) async {
  emit(state().copyWith(isLoading: true));

  if (state().planilla?.validar != null) {
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: state().planilla?.validar?.join('\n'),
    ));
  } else {
    String? respuesta;
    try {
      respuesta = await state().planilla?.enviar(
            user: state().user!,
            esNuevo: event.esNuevo,
          );
      if (!event.esNuevo && event.sendEmail) {
        String? respuestaEmail = await state().planilla?.enviarEmail(
              user: state().user!,
            );
        respuesta = '$respuesta \n\n ${respuestaEmail ?? ''}';
      }
      add(Load());
      try {
        Navigator.pop(event.context);
      } catch (e) {
        print('error en Navigator.pop(event.context);');
      }
      // Get.back();
    } catch (e) {
      emit(state().copyWith(
        errorCounter: state().errorCounter + 1,
        message:
            '🤕Error enviando los datos de la planilla: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
      ));
    }
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: respuesta ?? 'Error en el envío',
    ));
    // Get.back();
  }

  emit(state().copyWith(isLoading: false));
}

onChangePlanilla(ChangePlanilla e, emit, MainState Function() state) async {
  if (e.tabla == "planilla") {
    state().planilla!.asignar(
          campo: e.campo,
          valor: e.valor,
          index: e.index,
          lcl: state().lcl!,
          people: state().people!,
          user: state().user!,
        );
    //esperar 100 milisegundos
    await Future.delayed(const Duration(milliseconds: 100), () {
      emit(state().copyWith());
    });
  }
  // emit(state().copyWith());
}

onChangePlanillaList(
  ChangePlanillaList e,
  Emitter emit,
  MainState Function() state,
) {
  if (e.tabla == "planilla") {
    Registro ref = state().planilla!.registros[e.index];
    Mm60 mm60r = state().mm60!;
    Mb52 mb52r = state().mb52!;
    Inventario invr = state().inventario!;
    if (e.e4e != null) ref.cambioE4e(e.e4e!, mm60r, mb52r, invr, state().user!);
    if (e.ctd_e != null) ref.cambioCtdE(e.ctd_e!, mb52r, invr);
    if (e.ctd_r != null) ref.cambioCtdR(e.ctd_r!, mb52r, invr);
  }
  emit(state().copyWith());
}

onModifyPlanilla(
  ModifyPlanilla event,
  Emitter emit,
  MainState Function() state,
) {
  if (event.table == "planilla") {
    state().planilla?.modifyList(event.index, event.method);
  }
  emit(state().copyWith());
}
