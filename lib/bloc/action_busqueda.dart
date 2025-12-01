import 'package:samat2co/bloc/main_bloc.dart';

onBusqueda(event, emit, MainState Function() supraState) {
  String table = event.table;
  // print('onBusqueda');
  if (table == "mb51") supraState().mb51!.buscar(event.value);
  if (table == "mb52") supraState().mb52!.buscar(event.value);
  if (table == "plataforma") supraState().plataforma!.buscar(event.value);
  // if (table == "lcl") supraState().lcl!.buscar(event.value);
  if (table == "inventario") supraState().inventario!.buscar(event.value);
  if (table == "registros") supraState().planillas!.buscar(event.value);
  if (table == "registrosimple") supraState().planillas!.buscarsimple(event.value);
  if (table == "deudaAlmacen") supraState().deudaAlmacen!.buscar(event.value);
  if (table == "deudaOperativa") supraState().deudaOperativa!.buscar(event.value);
  emit(supraState().copyWith());
}

onListLoadMore(event, emit, MainState Function() supraState) {
  String table = event.table;
  if (table == 'mb51') supraState().mb51!.view = supraState().mb51!.view + 10;
  if (table == 'mb52') supraState().mb52!.view = supraState().mb52!.view + 10;
  if (table == 'plataforma') {
    supraState().plataforma!.view = supraState().plataforma!.view + 10;
  }
  if (table == 'lcl') supraState().lcl!.view = supraState().lcl!.view + 10;
  if (table == 'inventario') {
    supraState().inventario!.view = supraState().inventario!.view + 10;
  }
  emit(supraState().copyWith());
}
