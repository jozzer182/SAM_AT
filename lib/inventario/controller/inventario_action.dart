import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/inventario/inventario_model.dart';

Future onLoadInventario(
  event,
  emit,
  MainState Function() supraState,
) async {
  Inventario inventario = Inventario();
  try {
    inventario.crear(
      remisiones: supraState().remisiones!,
      planillas: supraState().planillas!,
      mm60: supraState().mm60!,
    );
    emit(supraState().copyWith(inventario: inventario));
    await Future.delayed(const Duration(milliseconds: 50));
    // print(
    // 'inventario: ${supraState().inventario?.inventarioList.length ?? ''}');
  } catch (e) {
    // print(e);
    emit(supraState().copyWith(
      errorCounter: supraState().errorCounter + 1,
      message:
          '🤕Error llamando📞 la lista de inventario ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${supraState().errorCounter + 1}',
    ));
  }
}
