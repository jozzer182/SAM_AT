part of '../../../bloc/main_bloc.dart';

class ChangeRemision extends MainEvent {
  final CampoRemision campo;
  final String valor;
  final int index;
  ChangeRemision({
    required this.campo,
    required this.valor,
    required this.index,
  });
}

class ModifyRemision extends MainEvent {
  final String index;
  final String method;
  ModifyRemision({
    required this.index,
    required this.method,
  });
}

class NewRemision extends MainEvent {}

class SaveRemision extends MainEvent {
  final BuildContext context;
  SaveRemision({
    required this.context,
  });
}

class UpdateRemision extends MainEvent {
  final BuildContext context;
  UpdateRemision({
    required this.context,
  });
}

class AnularRemision extends MainEvent {
  final BuildContext context;
  AnularRemision({
    required this.context,
  });
}
