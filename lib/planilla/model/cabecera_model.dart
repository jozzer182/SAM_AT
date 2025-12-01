import 'package:flutter/material.dart';
import 'package:samat2co/registros/registro_fila_model.dart';

class Cabecera {
  String pedido = '';
  String planilla = '';
  String unidad = '';
  String tipo_movimiento = '';
  String solicitante = '';
  String contrato = '';
  String nombre_pdi = '';
  String pdi = '';
  String proceso = '';
  String proyecto = '';
  String ingeniero_enel = '';
  String lcl = '';
  String pdl = '';
  String comentario = '';
  String destino = '';
  String almacenista_e = '';
  String tel_alm_e = '';
  String fecha_e = '';
  String fecha_r = '';
  String lider_contrato_e = '';
  String placa_cuadrilla_e = '';
  String tel_lider_e = '';
  String soporte_e = '';
  Cabecera({
    this.pedido = '',
    this.planilla = '',
    this.unidad = '',
    this.tipo_movimiento = '',
    this.solicitante = '',
    this.contrato = '',
    this.nombre_pdi = '',
    this.pdi = '',
    this.proceso = '',
    this.proyecto = '',
    this.ingeniero_enel = '',
    this.lcl = '',
    this.pdl = '',
    this.comentario = '',
    this.destino = '',
    this.almacenista_e = '',
    this.tel_alm_e = '',
    this.fecha_e = '',
    this.fecha_r = '',
    this.lider_contrato_e = '',
    this.placa_cuadrilla_e = '',
    this.tel_lider_e = '',
    this.soporte_e = '',
  });

  List<String> toList() => [
    pedido,
    planilla,
    unidad,
    tipo_movimiento,
    solicitante,
    contrato,
    nombre_pdi,
    pdi,
    proceso,
    proyecto,
    ingeniero_enel,
    lcl,
    pdl,
    comentario,
    destino,
    almacenista_e,
    tel_alm_e,
    fecha_e,
    fecha_r,
    lider_contrato_e,
    placa_cuadrilla_e,
    tel_lider_e,
    soporte_e
  ];

  Color get pedidoColor => pedido.isEmpty ? Colors.red : Colors.green;
  Color planillaColor({
    required Iterable<String> planillas,
    required bool esNuevo,
  }) {
    if (esNuevo) {
      return planillas.contains(planilla) || planilla.isEmpty
          ? Colors.red
          : Colors.green;
    }
    return planilla.isEmpty ? Colors.red : Colors.green;
  }

  Color get unidadColor => unidad.isEmpty ? Colors.red : Colors.green;
  Color get tipo_movimientoColor =>
      tipo_movimiento.isEmpty ? Colors.red : Colors.green;
  Color get solicitanteColor => solicitante.isEmpty ? Colors.red : Colors.green;
  Color get contratoColor => contrato.isEmpty ? Colors.red : Colors.green;
  Color get nombre_pdiColor => nombre_pdi.isEmpty ? Colors.red : Colors.green;
  Color get pdiColor => pdi.isEmpty ? Colors.red : Colors.green;
  Color get procesoColor => proceso.isEmpty ? Colors.red : Colors.green;
  Color get proyectoColor => proyecto.isEmpty ? Colors.red : Colors.green;
  Color get ingeniero_enelColor =>
      ingeniero_enel.isEmpty ? Colors.red : Colors.green;
  Color get lclColor => lcl.isEmpty ? Colors.red : Colors.green;
  Color get pdlColor => pdl.isEmpty ? Colors.red : Colors.green;
  Color get comentarioColor => comentario.isEmpty ? Colors.red : Colors.green;
  Color get destinoColor => destino.isEmpty ? Colors.red : Colors.green;
  Color get almacenista_eColor =>
      almacenista_e.isEmpty ? Colors.red : Colors.green;
  Color get tel_alm_eColor => tel_alm_e.isEmpty ? Colors.red : Colors.green;
  Color get fecha_eColor => fecha_e.isEmpty ? Colors.red : Colors.green;
  Color get fecha_rColor => fecha_r.isEmpty ? Colors.red : Colors.green;
  Color get lider_contrato_eColor =>
      lider_contrato_e.isEmpty ? Colors.red : Colors.green;
  Color get placa_cuadrilla_eColor =>
      placa_cuadrilla_e.isEmpty ? Colors.red : Colors.green;
  Color get tel_lider_eColor => tel_lider_e.isEmpty ? Colors.red : Colors.green;
  Color get soporte_eColor => soporte_e.isEmpty ? Colors.red : Colors.green;

  Map get toMap => {
        'pedido': pedido,
        'planilla': planilla,
        'unidad': unidad,
        'tipo_movimiento': tipo_movimiento,
        'solicitante': solicitante,
        'contrato': contrato,
        'nombre_pdi': nombre_pdi,
        'pdi': pdi,
        'proceso': proceso,
        'proyecto': proyecto,
        'ingeniero_enel': ingeniero_enel,
        'lcl': lcl,
        'pdl': pdl,
        'comentario': comentario,
        'destino': destino,
        'almacenista_e': almacenista_e,
        'tel_alm_e': tel_alm_e,
        'fecha_e': fecha_e,
        'fecha_r': fecha_r,
        'lider_contrato_e': lider_contrato_e,
        'placa_cuadrilla_e': placa_cuadrilla_e,
        'tel_lider_e': tel_lider_e,
        'soporte_e': soporte_e,
      };

  factory Cabecera.fromResgistroFila(ResgistroFila registro) {
    return Cabecera(
      pedido: registro.pedido,
      planilla: registro.planilla,
      unidad: registro.unidad,
      tipo_movimiento: registro.tipo_movimiento,
      solicitante: registro.solicitante,
      contrato: registro.contrato,
      nombre_pdi: registro.nombre_pdi,
      pdi: registro.pdi,
      proceso: registro.proceso,
      proyecto: registro.proyecto,
      ingeniero_enel: registro.ingeniero_enel,
      lcl: registro.lcl,
      pdl: registro.pdl,
      comentario: registro.comentario,
      destino: registro.destino,
      almacenista_e: registro.almacenista_e,
      tel_alm_e: registro.tel_alm_e,
      fecha_e: registro.fecha_e,
      fecha_r: registro.fecha_r,
      lider_contrato_e: registro.lider_contrato_e,
      placa_cuadrilla_e: registro.placa_cuadrilla_e,
      tel_lider_e: registro.tel_lider_e,
      soporte_e: registro.soporte_e,
    );
  }

  factory Cabecera.nuevo() {
    return Cabecera(
      pedido: '',
      planilla: '',
      unidad: '',
      tipo_movimiento: '',
      solicitante: '',
      contrato: '',
      nombre_pdi: '',
      pdi: '',
      proceso: '',
      proyecto: '',
      ingeniero_enel: '',
      lcl: '',
      pdl: '',
      comentario: '',
      destino: '',
      almacenista_e: '',
      tel_alm_e: '',
      fecha_e: '',
      fecha_r: '',
      lider_contrato_e: '',
      placa_cuadrilla_e: '',
      tel_lider_e: '',
      soporte_e: '',
    );
  }
}
