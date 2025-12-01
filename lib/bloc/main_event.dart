part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class Load extends MainEvent {}

class LoadUserAndData extends MainEvent {}

enum TypeMessage { error, message }

class NewMessage extends MainEvent {
  final String message;
  final Color color;
  final TypeMessage typeMessage;
  NewMessage({
    required this.message,
    required this.color,
    required this.typeMessage,
  });
}

class Loading extends MainEvent {
  final bool isLoading;
  Loading({
    required this.isLoading,
  });
}

class ThemeChange extends MainEvent {
  ThemeChange();
}

class ThemeColorChange extends MainEvent {
  final Color color;
  ThemeColorChange({
    required this.color,
  });
}

class ListLoadMore extends MainEvent {
  final String table;

  ListLoadMore({
    required this.table,
  });
}

class Busqueda extends MainEvent {
  final String value;
  final String table;
  Busqueda({
    required this.value,
    required this.table,
  });
}

class AnularDato extends MainEvent {
  final String id;
  final String pedido;
  final String item;
  final String hoja;
  final String tabla;
  final BuildContext context;
  AnularDato({
    required this.id,
    required this.pedido,
    required this.item,
    required this.hoja,
    required this.tabla,
    required this.context,
  });
}

// class ValidarPlanilla extends MainEvent {
//   final String tabla;
//   final BuildContext context;
//   ValidarPlanilla({
//     required this.tabla,
//     required this.context,
//   });
// }

// class ChangePlanilla extends MainEvent {
//   final String valor;
//   final CampoPlanilla campo;
//   final String tabla;
//   final int index;
//   ChangePlanilla({
//     required this.valor,
//     required this.campo,
//     required this.tabla,
//     required this.index,
//   });
// }

// class ChangePlanillaList extends MainEvent {
// // Mm60B mm60b;
//   int index;
//   String tabla;
//   String? e4e;
//   String? ctd_e;
//   String? ctd_r;
//   ChangePlanillaList({
//     // required this.mm60b,
//     required this.index,
//     required this.tabla,
//     this.e4e,
//     this.ctd_e,
//     this.ctd_r,
//   });
// }

// class ModifyPlanilla extends MainEvent {
//   String index;
//   String method;
//   String table;
//   ModifyPlanilla({
//     required this.index,
//     required this.method,
//     required this.table,
//   });
// }

class SeleccionarPedido extends MainEvent {
  final String pedido;
  SeleccionarPedido({
    required this.pedido,
  });
}

class BusquedaEspecifica extends MainEvent {
  final String tabla;
  final String e4e;
  final String? funcional;
  final String? lcl;
  BusquedaEspecifica({
    required this.tabla,
    required this.e4e,
    this.funcional,
    this.lcl,
  });
}

// class SeleccionarPlanilla extends MainEvent {
//   final Planilla planilla;
//   SeleccionarPlanilla({
//     required this.planilla,
//   });
// }

class SeleccionarEstado extends MainEvent {
  final EstadoVista estado;
  SeleccionarEstado({
    required this.estado,
  });
}
