class ResgistroFila {
  String id;
  String pedido;
  String planilla;
  String unidad;
  String tipo_movimiento;
  String solicitante;
  String contrato;
  String nombre_pdi;
  String pdi;
  String proceso;
  String proyecto;
  String ingeniero_enel;
  String lcl;
  String pdl;
  String comentario;
  String destino;
  String almacenista_e;
  String tel_alm_e;
  String fecha_e;
  String fecha_r;
  String lider_contrato_e;
  String placa_cuadrilla_e;
  String tel_lider_e;
  String soporte_e;
  String soporte_informe;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd_e;
  String ctd_r;
  String ctd_total;
  String fechareg_r;
  String estadoreg_r;
  String comentario_s;
  String almacenista_s;
  String fechareg_s;
  String estadoreg_s;
  String mensajes_r;
  String comentario_pre;
  String funcional_pre;
  String fechareg_pre;
  String estadoreg_pre;
  String comentario_sap;
  String numero_sap;
  String soporte_sap;
  String funcional_sap;
  String fechareg_sap;
  String estadoreg_sap;
  String comentario_confirmado;
  String ctd_confirmado;
  String fechareg_confirmado;
  String estado_confirmado;
  String est_oficial;
  String est_oficial_fecha;
  String est_oficial_pers;
  ResgistroFila({
    required this.id,
    required this.pedido,
    required this.planilla,
    required this.unidad,
    required this.tipo_movimiento,
    required this.solicitante,
    required this.contrato,
    required this.nombre_pdi,
    required this.pdi,
    required this.proceso,
    required this.proyecto,
    required this.ingeniero_enel,
    required this.lcl,
    required this.pdl,
    required this.comentario,
    required this.destino,
    required this.almacenista_e,
    required this.tel_alm_e,
    required this.fecha_e,
    required this.fecha_r,
    required this.lider_contrato_e,
    required this.placa_cuadrilla_e,
    required this.tel_lider_e,
    required this.soporte_e,
    required this.soporte_informe,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_e,
    required this.ctd_r,
    required this.ctd_total,
    required this.fechareg_r,
    required this.estadoreg_r,
    required this.almacenista_s,
    required this.fechareg_s,
    required this.estadoreg_s,
    required this.mensajes_r,
    required this.funcional_pre,
    required this.fechareg_pre,
    required this.estadoreg_pre,
    required this.numero_sap,
    required this.soporte_sap,
    required this.funcional_sap,
    required this.fechareg_sap,
    required this.estadoreg_sap,
    required this.ctd_confirmado,
    required this.fechareg_confirmado,
    required this.estado_confirmado,
    required this.est_oficial,
    required this.est_oficial_fecha,
    required this.est_oficial_pers,
    required this.comentario_s,
    required this.comentario_pre,
    required this.comentario_sap,
    required this.comentario_confirmado,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
      'soporte_informe': soporte_informe,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_e': ctd_e,
      'ctd_r': ctd_r,
      'ctd_total': ctd_total,
      'fechareg_r': fechareg_r,
      'estadoreg_r': estadoreg_r,
      'almacenista_s': almacenista_s,
      'fechareg_s': fechareg_s,
      'estadoreg_s': estadoreg_s,
      'mensajes_r': mensajes_r,
      'funcional_pre': funcional_pre,
      'fechareg_pre': fechareg_pre,
      'estadoreg_pre': estadoreg_pre,
      'numero_sap': numero_sap,
      'soporte_sap': soporte_sap,
      'funcional_sap': funcional_sap,
      'fechareg_sap': fechareg_sap,
      'estadoreg_sap': estadoreg_sap,
      'ctd_confirmado': ctd_confirmado,
      'fechareg_confirmado': fechareg_confirmado,
      'estado_confirmado': estado_confirmado,
      'est_oficial': est_oficial,
      'est_oficial_fecha': est_oficial_fecha,
      'est_oficial_pers': est_oficial_pers,
      'comentario_s': comentario_s,
      'comentario_pre': comentario_pre,
      'comentario_sap': comentario_sap,
      'comentario_confirmado': comentario_confirmado,
    };
  }

  factory ResgistroFila.fromMap(Map<String, dynamic> map) {
    if (map['estadoreg_r'] == 'anulado') {
      map['est_oficial'] = 'anulado';
    }
    if (map['numero_sap'].toString().isNotEmpty &&
        map['soporte_sap'].toString().isNotEmpty &&
        map['funcional_sap'].toString().isNotEmpty &&
        map['fechareg_sap'].toString().isNotEmpty &&
        map['estadoreg_sap'].toString().isNotEmpty) {
      map['est_oficial'] = map['estadoreg_sap'].toString();
      map['est_oficial_fecha'] = map['fechareg_sap'].toString();
      map['est_oficial_pers'] = map['funcional_sap'].toString();
      map['fechareg_pre'] = map['fechareg_sap'].toString();
    }
    return ResgistroFila(
      id: map['id'].toString(),
      pedido: map['pedido'].toString(),
      planilla: map['planilla'].toString(),
      unidad: map['unidad'].toString(),
      tipo_movimiento: map['tipo_movimiento'].toString(),
      solicitante: map['solicitante'].toString(),
      contrato: map['contrato'].toString(),
      nombre_pdi: map['nombre_pdi'].toString(),
      pdi: map['pdi'].toString(),
      proceso: map['proceso'].toString(),
      proyecto: map['proyecto'].toString(),
      ingeniero_enel: map['ingeniero_enel'].toString(),
      lcl: map['lcl'].toString(),
      pdl: map['pdl'].toString(),
      comentario: map['comentario'].toString(),
      destino: map['destino'].toString(),
      almacenista_e: map['almacenista_e'].toString(),
      tel_alm_e: map['tel_alm_e'].toString(),
      fecha_e: map['fecha_e'].toString().isNotEmpty
          ? map['fecha_e'].toString().substring(0, 10)
          : map['fecha_e'].toString(),
      fecha_r: map['fecha_r'].toString().isNotEmpty
          ? map['fecha_r'].toString().substring(0, 10)
          : map['fecha_r'].toString(),
      lider_contrato_e: map['lider_contrato_e'].toString(),
      placa_cuadrilla_e: map['placa_cuadrilla_e'].toString(),
      tel_lider_e: map['tel_lider_e'].toString(),
      soporte_e: map['soporte_e'].toString(),
      soporte_informe: map['soporte_informe'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd_e: map['ctd_e'].toString(),
      ctd_r: map['ctd_r'].toString(),
      ctd_total: map['ctd_total'].toString(),
      fechareg_r: map['fechareg_r'].toString(),
      estadoreg_r: map['estadoreg_r'].toString(),
      almacenista_s: map['almacenista_s'].toString(),
      fechareg_s: map['fechareg_s'].toString(),
      estadoreg_s: map['estadoreg_s'].toString(),
      mensajes_r: map['mensajes_r'].toString(),
      funcional_pre: map['funcional_pre'].toString(),
      fechareg_pre: map['fechareg_pre'].toString(),
      estadoreg_pre: map['estadoreg_pre'].toString(),
      numero_sap: map['numero_sap'].toString(),
      soporte_sap: map['soporte_sap'].toString(),
      funcional_sap: map['funcional_sap'].toString(),
      fechareg_sap: map['fechareg_sap'].toString(),
      estadoreg_sap: map['estadoreg_sap'].toString(),
      ctd_confirmado: map['ctd_confirmado'].toString(),
      fechareg_confirmado: map['fechareg_confirmado'].toString(),
      estado_confirmado: map['estado_confirmado'].toString(),
      est_oficial: map['est_oficial'].toString(),
      est_oficial_fecha: map['est_oficial_fecha'].toString(),
      est_oficial_pers: map['est_oficial_pers'].toString(),
      comentario_s: map['comentario_s'].toString(),
      comentario_pre: map['comentario_pre'].toString(),
      comentario_sap: map['comentario_sap'].toString(),
      comentario_confirmado: map['comentario_confirmado'].toString(),
    );
  }

  List<String> toList() => [
        id,
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
        soporte_e,
        soporte_informe,
        item,
        e4e,
        descripcion,
        um,
        ctd_e,
        ctd_r,
        ctd_total,
        fechareg_r,
        estadoreg_r,
        almacenista_s,
        fechareg_s,
        estadoreg_s,
        mensajes_r,
        funcional_pre,
        fechareg_pre,
        estadoreg_pre,
        numero_sap,
        soporte_sap,
        funcional_sap,
        fechareg_sap,
        estadoreg_sap,
        ctd_confirmado,
        fechareg_confirmado,
        estado_confirmado,
        est_oficial,
        est_oficial_fecha,
        est_oficial_pers,
      ];
}
