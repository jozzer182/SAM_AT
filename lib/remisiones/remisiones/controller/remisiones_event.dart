part of '../../../bloc/main_bloc.dart';

class BuscarRemisiones extends MainEvent {
  final String busqueda;
  BuscarRemisiones(this.busqueda);
}

class SeleccionarRemision extends MainEvent {
  final String pedido;
  SeleccionarRemision(this.pedido);
}
