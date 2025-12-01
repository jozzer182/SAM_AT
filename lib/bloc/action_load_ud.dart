import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:samat2co/bloc/action_load.dart';
import 'package:samat2co/bloc/main__bl.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/deuda_almacen/deudaalmacen_model.dart';
import 'package:samat2co/deuda_bruta/deudabruta_model.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_model.dart';
import 'package:samat2co/inventario/controller/inventario_action.dart';
import 'package:samat2co/remisiones/model/nuevoingreso_model.dart';
import 'package:samat2co/remisiones/model/traslado_model.dart';
import 'package:samat2co/mb51/mb51_model.dart';
import 'package:samat2co/mb52/mb52_model.dart';
// import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/planilla/controller/action_planillas.dart';
import 'package:samat2co/planillas/planillas_model.dart';

import 'package:samat2co/perfiles/perfiles_model.dart';

import 'package:samat2co/remisiones/remisiones/controller/remisiones_action.dart';
import 'package:samat2co/user/user_model.dart';
import 'package:samat2co/usuarios/usuarios_model.dart';

import '../conciliaciones/controller/conciliaciones_controller.dart';
import '../lcl/controller/lcl_ctrl.dart';

//-------------------------------------------------------------------------
// Logica de creación de usuario y obtensión de datos

Future onLoadUserAndData(
  LoadUserAndData event,
  emit,
  MainState Function() supraState,
  add
) async {
  emit(supraState().resetUser());
  FutureGroup futureGroup1 = FutureGroup();
  futureGroup1.add(onLoadUsuarios(event, emit, supraState));
  futureGroup1.add(onLoadPerfiles(event, emit, supraState));
  futureGroup1.close();
  try {
    await futureGroup1.future;
  } catch (e) {
    emit(supraState().copyWith(
      message: 'error cargando datos => $e',
      errorCounter: supraState().errorCounter + 1,
      messageColor: Colors.red,
    ));
  }
  // print('onLoadUserAndData after await');
  createUser(event, emit, supraState);
  onLoadPlanilla(event, emit, supraState);
  onLoadNuevoIngreso(event, emit, supraState);
  onLoadNuevoTraslado(event, emit, supraState);
  if (!(supraState().user!.pdi == 'XXXXXXXXXX')) {
    //Obtener MB51, MB52, BD
    // print('entrando a onLoadMb52');
    FutureGroup futureGroup2 = FutureGroup();
    // FutureGroup futureGroup3 = FutureGroup();
    futureGroup2.add(onLoadMb52(event, emit, supraState));
    futureGroup2.add(onLoadMb51(event, emit, supraState));
    // futureGroup2.add(onLoadLcl(event, emit, supraState));
    futureGroup2.add(onLoadRemisiones(event, emit, supraState));
    futureGroup2.add(onLoadPlanillas(event, emit, supraState));
    futureGroup2.add(ConciliacionesController(Bl(emit, supraState, add)).obtener);
    futureGroup2.add(LclCtrl(Bl(emit, supraState, add)).obtener);
    futureGroup2.close();
    try {
      // print('entrando al futuregroup');
      await futureGroup2.future;
      await onLoadInventario(event, emit, supraState);
      await onLoadDeudaBruta(event, emit, supraState);
      await onLoadDeudaOperativa(event, emit, supraState);
      await onLoadDeudaAlmacen(event, emit, supraState);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      emit(supraState().copyWith(
        message: 'error cargando datos => $e',
        errorCounter: supraState().errorCounter + 1,
        messageColor: Colors.red,
      ));
    }
  }
  if (supraState().mm60 != null) {
    emit(
      supraState().copyWith(
        isLoading: false,
      ),
    );
  }
  return "ok";
}

Future<Usuarios> onLoadUsuarios(
    event, emit, MainState Function() supraState) async {
  Usuarios usuarios = Usuarios();
  try {
    await usuarios.obtener();
    emit(supraState().copyWith(usuarios: usuarios));
    // emit(state.copyWith(usuarios: usuarios));
    // print('usuarios: ${usuarios.usuariosList}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de usuarios ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
  return usuarios;
}

Future onLoadPerfiles(event, emit, MainState Function() supraState) async {
  Perfiles perfiles = Perfiles();
  try {
    await perfiles.obtener();
    emit(supraState().copyWith(perfiles: perfiles));
    // print('perfiles: ${supraState().perfiles?.perfilesList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de perfiles ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

createUser(event, emit, MainState Function() supraState) {
  User user = User();
  List<UsuariosSingle> listaUsuarios = supraState().usuarios!.usuariosList;
  String correo = FirebaseAuth.instance.currentUser?.email ?? "Error";
  // print('------------------------------------------------------------');
  // print('fom createUser listaUsuarios: $listaUsuarios');
  // print('fom createUser user: $correo');
  UsuariosSingle usuarioEncontrado = listaUsuarios
      .firstWhere((e) => e.correo == correo, orElse: UsuariosSingle.fromZero);
  List<PerfilesSingle> perfiles = supraState().perfiles!.perfilesList;
  List<String> permisos = perfiles
      .where((e) => e.perfil == usuarioEncontrado.perfil)
      .map((e) => e.permiso)
      .toList();
  user.set(
    id: usuarioEncontrado.id,
    correo: correo,
    perfil: usuarioEncontrado.perfil,
    pdi: usuarioEncontrado.pdi,
    telefono: usuarioEncontrado.telefono,
    empresa: usuarioEncontrado.empresa,
    nombrecorto: usuarioEncontrado.nombrecorto,
    permisos: permisos,
  );
  emit(supraState().copyWith(user: user));
  if (user.pdi == 'XXXXXXXXXX') {
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message: 'Por favor inicia sesión para continuar',
    ));
  }
}

Future onLoadMb52(event, emit, MainState Function() supraState) async {
  Mb52 mb52 = Mb52();
  try {
    await mb52.obtener(supraState().user!.pdi);
    emit(supraState().copyWith(mb52: mb52));
    // print('onLoadMb52: ${supraState().mb52?.mb52List ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de mb52 ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
  // print('saliendo del inload');
  // return mb52;
}

Future onLoadMb51(event, emit, MainState Function() supraState) async {
  Mb51 mb51 = Mb51();
  try {
    await mb51.obtener(supraState().user!.pdi);
    emit(supraState().copyWith(mb51: mb51));
    // print('mb51: ${supraState().mb51?.mb51List.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de mb51 ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

// Future onLoadRegistros(event, emit, MainState Function() supraState) async {
//   Registros registros = Registros();
//   try {
//     await registros.obtener(supraState().user!);
//     emit(supraState().copyWith(registros: registros));
//     // print('registros: ${supraState().registros?.registrosList.length ?? ''}');
//   } catch (e) {
//     // print(e);
//     emit(supraState().copyWith(
//       errorCounter: supraState().errorCounter + 1,
//       message:
//           '🤕Error llamando📞 la lista de registros ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
//     ));
//   }
// }

Future onLoadPlanillas(event, emit, MainState Function() supraState) async {
  Planillas planillas = Planillas();
  if (supraState().mm60 == null) await onLoadMm60(event, emit, supraState);
  try {
    await planillas.obtener(
      user: supraState().user!,
      mm60: supraState().mm60!,
    );
    emit(supraState().copyWith(planillas: planillas));
    // print('planillas: ${supraState().planillas?.planillasList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de planillas ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

// Future onLoadLcl(event, emit, MainState Function() supraState) async {
//   Lcl lcl = Lcl();
//   try {
//     await lcl.obtener(supraState().user!);
//     emit(supraState().copyWith(lcl: lcl));
//     // print('lcl: ${supraState().lcl?.lclList.length ?? ''}');
//   } catch (e) {
//     // print(e);
//     emit(supraState().copyWith(
//       errorCounter: supraState().errorCounter + 1,
//       message:
//           '🤕Error llamando📞 la lista de lcl ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
//     ));
//   }
// }

onLoadNuevoIngreso(event, emit, MainState Function() supraState) {
  NuevoIngreso nuevoIngreso = NuevoIngreso();
  try {
    nuevoIngreso.crear(supraState().user!);
    emit(supraState().copyWith(nuevoIngreso: nuevoIngreso));
    // print('nuevoIngreso: ${supraState().nuevoIngreso?.nuevoIngresoList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de nuevoIngreso ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

onLoadNuevoTraslado(event, emit, MainState Function() supraState) {
  NuevoTraslado nuevoTraslado = NuevoTraslado();
  try {
    nuevoTraslado.crear(supraState().user!);
    emit(supraState().copyWith(nuevoTraslado: nuevoTraslado));
    // print('nuevoTraslado: ${supraState().nuevoTraslado?.nuevoTrasladoList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de nuevoTraslado ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

// Future onLoadInventario(event, emit, MainState Function() supraState) async {
//   Inventario inventario = Inventario();
//   try {
//     inventario.crear(
//       ingresos: supraState().ingresos!,
//       planillas: supraState().planillas!,
//     );
//     emit(supraState().copyWith(inventario: inventario));
//     await Future.delayed(const Duration(milliseconds: 50));
//     // print(
//     // 'inventario: ${supraState().inventario?.inventarioList.length ?? ''}');
//   } catch (e) {
//     // print(e);
//     emit(supraState().copyWith(
//       errorCounter: supraState().errorCounter + 1,
//       message:
//           '🤕Error llamando📞 la lista de inventario ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
//     ));
//   }
// }

Future onLoadDeudaBruta(event, emit, MainState Function() supraState) async {
  DeudaBruta deudaBruta = DeudaBruta();
  try {
    // print('1. onLoadDeudaBruta: ${supraState().mb52?.mb52List.where((e) => e.material == "520012").toList() ?? ''}');
    deudaBruta.crear(
      mb52: supraState().mb52!,
      inventario: supraState().inventario!,
      mm60: supraState().mm60!,
    );
    emit(supraState().copyWith(deudaBruta: deudaBruta));
    await Future.delayed(const Duration(milliseconds: 50));
    // print('2. onLoadDeudaBruta: ${supraState().mb52?.mb52List.where((e) => e.material == "520012").toList() ?? ''}');

    // print(
    //     'deudaBruta: ${supraState().deudaBruta?.deudaBrutaList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de deudaBruta ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadDeudaOperativa(
    event, emit, MainState Function() supraState) async {
  DeudaOperativa deudaOperativa = DeudaOperativa();
  // Mm60 mm60 = Mm60();
  if (supraState().mm60 == null) {
    await onLoadMm60(event, emit, supraState);
  }
  // print('onLoadDeudaOperativa - mb51: ${supraState().mb51}');
  // print('onLoadDeudaOperativa - registros: ${supraState().registros}');
  // print('onLoadDeudaOperativa - lcl: ${supraState().lcl}');
  // print('onLoadDeudaOperativa - mm60: ${supraState().mm60}');
  try {
    deudaOperativa.crear(
      mb51: supraState().mb51!,
      planillas: supraState().planillas!,
      lcl: supraState().lcl!,
      mm60: supraState().mm60!,
      mb52: supraState().mb52!,
    );
    emit(supraState().copyWith(deudaOperativa: deudaOperativa));
    await Future.delayed(const Duration(milliseconds: 50));
    // print(
    //     'deudaOperativa: ${supraState().deudaOperativa?.deudaOperativa.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de deudaOperativa ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadDeudaAlmacen(event, emit, MainState Function() supraState) async {
  DeudaAlmacen deudaAlmacen = DeudaAlmacen();
  // Mm60 mm60 = Mm60();
  // if (supraState().mm60 == null) {
  //   await onLoadMm60(event, emit, supraState);
  // }
  // print('onLoadDeudaOperativa - mb51: ${supraState().mb51}');
  // print('onLoadDeudaOperativa - registros: ${supraState().registros}');
  // print('onLoadDeudaOperativa - lcl: ${supraState().lcl}');
  // print('onLoadDeudaOperativa - mm60: ${supraState().mm60}');
  try {
    deudaAlmacen.crear(
      deudaBruta: supraState().deudaBruta!,
      deudaOperativa: supraState().deudaOperativa!,
    );
    emit(supraState().copyWith(deudaAlmacen: deudaAlmacen));
    await Future.delayed(const Duration(milliseconds: 50));
    // print(
    //     'deudaAlmacen: ${supraState().deudaAlmacen?.deudaAlmacen.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de deudaAlmacen ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}
