import 'package:bloc/bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/remisiones/remision/model/remision_model.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_model.dart';

Future onLoadRemisiones(
  LoadUserAndData event,
  Emitter emit,
  MainState Function() supraState,
) async {
  Remisiones remisiones = Remisiones();
  try {
    await remisiones.obtener(supraState().user!);
    emit(supraState().copyWith(remisiones: remisiones));
    // print('lcl: ${supraState().lcl?.lclList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de lcl ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}

onBuscarRemisiones(
  BuscarRemisiones event,
  Emitter emit,
  MainState Function() state,
) {
  state().remisiones!.buscar(event.busqueda);
  emit(state().copyWith(
    remisiones: state().remisiones,
  ));
}

onSeleccionarRemision(
  SeleccionarRemision event,
  Emitter emit,
  MainState Function() state,
) {
  Remision? remision = state().remisiones!.seleccionarRemision(event.pedido);
  emit(state().copyWith(
    remision: remision,
  ));
}
