// part of 'main_bloc.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/action_color.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/dominios/dominios_model.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/pdis/pdis_model.dart';
import 'package:samat2co/pdi/pdi_model.dart';
import 'package:samat2co/people/people_b.dart';
import 'package:samat2co/plataforma/plataforma_model.dart';
import 'package:samat2co/wbe/wbe_model.dart';

Future onLoad(
  Load event,
  Emitter emit,
  MainState Function() supraState,
  add,
) async {
  //blanqueo de valores
  supraState().initial();

  //carga de datos
  emit(supraState().copyWith(isLoading: true));
  FutureGroup futureGroup = FutureGroup();
  futureGroup.add(onLoadPdi(event, emit, supraState));
  futureGroup.add(onLoadPdis(event, emit, supraState));
  futureGroup.add(onLoadDominio(event, emit, supraState));
  futureGroup.add(onLoadMm60(event, emit, supraState));
  futureGroup.add(onLoadPlataforma(event, emit, supraState));
  futureGroup.add(onLoadWbe(event, emit, supraState));
  futureGroup.add(themeLoader(event, emit, supraState));
  futureGroup.add(themeColorLoader(event, emit, supraState));
  futureGroup.add(onLoadPeople(event, emit, supraState));
  futureGroup.close();
  try {
    await futureGroup.future;
    await futureGroup.future.whenComplete(() async {
      print('Grupo 1 Cargado');
      // print('pdis: ${supraState().pdis!.pdisList.length}');
      // await onLoadUserAndData(event, emit, supraState);
      await add(LoadUserAndData());
    });
    // print('datos cargados');
    // emit(state.copyWith());
  } catch (e) {
    print(e);
    emit(supraState().copyWith(
      message: 'error cargando datos => $e',
      errorCounter: supraState().errorCounter + 1,
      messageColor: Colors.red,
    ));
  }
  // emit(supraState().copyWith(
  //   planillaEdit: PlanillaEdit(),
  // ));
  // print('------------------------------------------------------------');
  // print('plataforma: ${supraState().plataforma?.plataformaList.length ?? ''}');
  // print('------------------------------------------------------------');
  emit(supraState().copyWith(isLoading: false));
}

Future onLoadPdi(
  event,
  emit,
  MainState Function() supraState,
) async {
  Pdi pdi = Pdi();
  try {
    await pdi.obtener();
    emit(supraState().copyWith(pdi: pdi));
    // print('pdi: ${pdi.pdiList}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de pdis ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadPdis(
  event,
  emit,
  MainState Function() supraState,
) async {
  Pdis pdis = Pdis();
  try {
    // print('before call pdis');
    await pdis.obtener().whenComplete(() {
      emit(supraState().copyWith(pdis: pdis));
    });
    // print('pdis: ${supraState().pdis!.pdisList.length}');
  } catch (e) {
    // print('error pdis: $e');
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de pdis ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadDominio(event, emit, supraState) async {
  Dominio dominio = Dominio();
  try {
    await dominio.obtener();
    emit(supraState().copyWith(dominio: dominio));
    // print('dominio: ${dominio?.dominioList}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de dominios ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadMm60(event, emit, supraState) async {
  Mm60 mm60 = Mm60();
  try {
    await mm60.obtener();
    emit(supraState().copyWith(
      mm60: mm60,
    ));
    // print('mm60: ${supraState().mm60?.mm60List.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de mm60 ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadPlataforma(event, emit, supraState) async {
  Plataforma plataforma = Plataforma();
  try {
    await plataforma.obtener();
    emit(supraState().copyWith(plataforma: plataforma));
    // print('plataforma: ${supraState().plataforma?.plataformaList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de plataforma ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadWbe(event, emit, supraState) async {
  Wbe wbe = Wbe();
  try {
    await wbe.obtener();
    emit(supraState().copyWith(wbe: wbe));
    // print('wbe: ${supraState().wbe?.wbeList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de wbe ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

Future onLoadPeople(event, emit, supraState) async {
  People people = People();
  try {
    await people.obtener();
    emit(supraState().copyWith(people: people));
    // print('people: ${supraState().people?.peopleList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de people ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}
