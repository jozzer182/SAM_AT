part of '../../bloc/main_bloc.dart';

class PlanillaNuevo extends MainEvent {}

class ValidarPlanilla extends MainEvent {
  final bool esNuevo;
  final BuildContext context;
  final bool sendEmail;
  ValidarPlanilla({
    required this.esNuevo,
    required this.context,
    this.sendEmail = false,
  });
}

class ChangePlanilla extends MainEvent {
  final String valor;
  final CampoPlanilla campo;
  final String tabla;
  final int index;
  ChangePlanilla({
    required this.valor,
    required this.campo,
    required this.tabla,
    required this.index,
  });
}

class ChangePlanillaList extends MainEvent {
// Mm60B mm60b;
  final int index;
  final String tabla;
  final String? e4e;
  final String? ctd_e;
  final String? ctd_r;
  ChangePlanillaList({
    // required this.mm60b,
    required this.index,
    required this.tabla,
    this.e4e,
    this.ctd_e,
    this.ctd_r,
  });
}

class ModifyPlanilla extends MainEvent {
  final String index;
  final String method;
  final String table;
  ModifyPlanilla({
    required this.index,
    required this.method,
    required this.table,
  });
}

class SeleccionarPlanilla extends MainEvent {
  final Planilla planilla;
  SeleccionarPlanilla({
    required this.planilla,
  });
}
