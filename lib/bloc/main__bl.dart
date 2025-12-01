// ignore_for_file: prefer_adjacent_string_concatenation, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';

import 'main_bloc.dart';

class Bl {
  var emit;
  MainState Function() state;
  void Function(MainEvent) add;
  Bl(this.emit, this.state, this.add);

  get startLoading => emit(state().copyWith(isLoading: true));
  get stopLoading => emit(state().copyWith(isLoading: false));

  // get startLoadingFEM => emit(state().copyWith(isLoadingFem: true));
  // get stopLoadingFEM => emit(state().copyWith(isLoadingFem: false));

  get recargar => add(Load());

  mensaje({
    required String message,
    Color messageColor = Colors.red,
  }) {
    emit(
      state().copyWith(
        message: message,
        messageColor: messageColor,
        errorCounter: state().errorCounter + 1,
      ),
    );
  }

  mensajeFlotante({
    required String message,
    Color messageColor = Colors.red,
  }) {
    emit(
      state().copyWith(
        dialogMessage: message,
        // messageColor: messageColor,
        messageCounter: state().messageCounter + 1,
      ),
    );
  }

  errorCarga(String element, Object e) {
    String message =
        '🤕Error llamando📞 la tabla de datos/función ${element} ' +
            '⚠️$e => ${e.runtimeType}, intente recargar la página🔄, ';
    print(message);
    mensaje(message: message);
  }
}
