// ignore: depend_on_referenced_packages
// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:samat2co/bloc/action_busqueda.dart';
import 'package:samat2co/bloc/action_load.dart';
import 'package:samat2co/bloc/action_color.dart';
import 'package:samat2co/bloc/action_load_ud.dart';
import 'package:samat2co/bloc/action_message.dart';
import 'package:samat2co/conciliaciones/model/conciliaciones_reg_model.dart';
import 'package:samat2co/conciliaciones/model/concilicaicones_list_model.dart';
import 'package:samat2co/planilla/controller/action_planillas.dart';
import 'package:samat2co/deuda_almacen/deudaalmacen_model.dart';
import 'package:samat2co/deuda_bruta/deudabruta_model.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_model.dart';
import 'package:samat2co/dominios/dominios_model.dart';
import 'package:samat2co/inventario/inventario_model.dart';
import 'package:samat2co/remisiones/model/nuevoingreso_model.dart';
import 'package:samat2co/remisiones/remision/controller/remision_action.dart';
import 'package:samat2co/remisiones/remision/model/remision_enum.dart';
import 'package:samat2co/remisiones/remision/model/remision_model.dart';
import 'package:samat2co/remisiones/model/traslado_model.dart';
import 'package:samat2co/mb51/mb51_model.dart';
import 'package:samat2co/mb52/mb52_model.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/pdis/pdis_model.dart';
import 'package:samat2co/planilla/model/estados_model.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';
import 'package:samat2co/planilla/model/planilla_model.dart';
import 'package:samat2co/planillas/planillas_model.dart';

import 'package:samat2co/pdi/pdi_model.dart';
import 'package:samat2co/people/people_b.dart';
import 'package:samat2co/perfiles/perfiles_model.dart';
import 'package:samat2co/plataforma/plataforma_model.dart';
import 'package:samat2co/usuarios/usuarios_model.dart';
import 'package:samat2co/wbe/wbe_model.dart';

import '../conciliaciones/controller/conciliaciones_controller.dart';
import '../lcl/model/lcl_model.dart';
import '../planillas/controller/planillas_ctrl.dart';
import '../remisiones/remisiones/controller/remisiones_action.dart';
import '../remisiones/remisiones/model/remisiones_model.dart';
import '../user/user_model.dart';
import 'action_tbd.dart';
import 'main__bl.dart';
part 'main_event.dart';
part 'main_state.dart';
part '../planilla/controller/event_planillas.dart';
part '../remisiones/remisiones/controller/remisiones_event.dart';
part '../remisiones/remision/controller/remision_event.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<Loading>(onLoading);
    on<Load>((ev, em) async => onLoad(ev, em, supraState, add));
    on<LoadUserAndData>(
        (ev, em) async => onLoadUserAndData(ev, em, supraState, add));
    on<NewMessage>((ev, em) => onNewMessage(ev, em, state));
    on<ThemeChange>((ev, em) => onThemeChange(ev, em, supraState));
    on<ThemeColorChange>((ev, em) => onThemeColorChange(ev, em, supraState));
    on<ListLoadMore>((ev, em) => onListLoadMore(ev, em, supraState));
    on<Busqueda>((ev, em) => onBusqueda(ev, em, supraState));
    on<ValidarPlanilla>((ev, em) => onValidarPlanilla(ev, em, supraState, add));
    on<ChangePlanilla>((ev, em) => onChangePlanilla(ev, em, supraState));
    on<ChangePlanillaList>(
        (ev, em) => onChangePlanillaList(ev, em, supraState));
    on<ModifyPlanilla>((ev, em) => onModifyPlanilla(ev, em, supraState));
    // on<SeleccionarPedido>((ev, em) => onSeleccionarPedido(ev, em, supraState));
    on<BusquedaEspecifica>(
        (ev, em) => onBusquedaEspecifica(ev, em, supraState));
    on<SeleccionarPlanilla>(
        (ev, em) => onSeleccionarPlanilla(ev, em, supraState));
    on<SeleccionarEstado>((ev, em) => onSeleccionarEstado(ev, em, supraState));
    on<PlanillaNuevo>((ev, em) => onLoadPlanilla(ev, em, supraState));
    on<BuscarRemisiones>((ev, em) => onBuscarRemisiones(ev, em, supraState));
    on<SeleccionarRemision>(
        (ev, em) => onSeleccionarRemision(ev, em, supraState));
    on<ChangeRemision>((ev, em) => onChangeRemision(ev, em, supraState));
    on<ModifyRemision>((ev, em) => onModifyRemision(ev, em, supraState));
    on<NewRemision>((ev, em) => onNewRemision(ev, em, supraState));
    on<SaveRemision>((ev, em) => onSaveRemision(ev, em, supraState, add));
    on<UpdateRemision>((ev, em) => onUpdateRemision(ev, em, supraState, add));
    on<AnularRemision>((ev, em) => onAnularRemision(ev, em, supraState, add));
  }

  MainState supraState() => state;

  MainState passState() => state;

  Bl get bl => Bl(emit, passState, add);

  ConciliacionesController get conciliacionesController =>
      ConciliacionesController(bl);
  PlanillasController get planillasController => PlanillasController(bl);

  onLoading(event, emit) {
    emit(state.copyWith(
      isLoading: event.isLoading,
    ));
  }
}
