// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:samat2co/bloc/main_bloc.dart';

import '../model/remision_model.dart';

onChangeRemision(
  ChangeRemision event,
  Emitter<MainState> emit,
  MainState Function() state,
) {
  state().remision!.asignar(
        campo: event.campo,
        valor: event.valor,
        index: event.index,
        mm60: state().mm60!,
      );
  emit(state().copyWith(
    remision: state().remision,
  ));
}

onModifyRemision(
  ModifyRemision event,
  Emitter<MainState> emit,
  MainState Function() state,
) {
  state().remision!.modifyList(
        index: event.index,
        method: event.method,
      );
  emit(state().copyWith(
    remision: state().remision,
  ));
}

onNewRemision(
  NewRemision event,
  Emitter<MainState> emit,
  MainState Function() state,
) {
  emit(state().copyWith(
    remision: Remision.fromInit(state().user!),
  ));
}

onSaveRemision(
  SaveRemision event,
  Emitter<MainState> emit,
  MainState Function() state,
  void Function(MainEvent event) add,
) async {
  emit(state().copyWith(isLoading: true));
  if (state().remision?.validar != null) {
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: state().remision?.validar?.join('\n'),
    ));
  } else {
    String? respuesta;
    try {
      respuesta = await state().remision?.addToDbRemisiones(
            user: state().user!,
          );
      Navigator.pop(event.context);
      // Navigator.pop(event.context);
      add(Load());
    } catch (e) {
      emit(state().copyWith(
        errorCounter: state().errorCounter + 1,
        message:
            '🤕Error enviando los datos de la remision: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
      ));
    }
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: respuesta ?? 'Error en el envío',
    ));
  }
  emit(state().copyWith(isLoading: false));
}

onUpdateRemision(
  UpdateRemision event,
  Emitter<MainState> emit,
  MainState Function() state,
  void Function(MainEvent event) add,
) async {
  emit(state().copyWith(isLoading: true));
  if (state().remision?.validar != null) {
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: state().remision?.validar?.join('\n'),
    ));
  } else {
    String? respuesta;
    try {
      respuesta = await state().remision?.updateToDbRemisiones(
            user: state().user!,
          );
      Navigator.pop(event.context);
      add(Load());
    } catch (e) {
      emit(state().copyWith(
        errorCounter: state().errorCounter + 1,
        message:
            '🤕Error enviando los datos de la remision: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
      ));
    }
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: respuesta ?? 'Error en el envío',
    ));
  }
  emit(state().copyWith(isLoading: false));
}

onAnularRemision(
  AnularRemision event,
  Emitter<MainState> emit,
  MainState Function() state,
  void Function(MainEvent event) add,
) async {
  emit(state().copyWith(isLoading: true));
  if (state().remision?.validar != null) {
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: state().remision?.validar?.join('\n'),
    ));
  } else {
    String? respuesta;
    try {
      state().remision!.cabecera.estado = 'anulado';
      respuesta = await state().remision?.updateToDbRemisiones(
            user: state().user!,
          );
      Navigator.pop(event.context);
      add(Load());
    } catch (e) {
      emit(state().copyWith(
        errorCounter: state().errorCounter + 1,
        message:
            '🤕Error enviando los datos de la remision: ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
      ));
    }
    emit(state().copyWith(
      dialogCounter: state().dialogCounter + 1,
      dialogMessage: respuesta ?? 'Error en el envío',
    ));
  }
  emit(state().copyWith(isLoading: false));
}

