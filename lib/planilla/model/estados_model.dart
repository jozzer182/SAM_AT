import 'package:flutter/material.dart';
import 'package:samat2co/registros/registro_fila_model.dart';

class Estados {
  String fechareg_s = '';
  String estadoreg_s = '';
  String mensajes_r = '';
  String funcional_pre = '';
  String fechareg_pre = '';
  String estadoreg_pre = '';
  String numero_sap = '';
  String soporte_sap = '';
  String funcional_sap = '';
  String fechareg_sap = '';
  String estadoreg_sap = '';
  String ctd_confirmado = '';
  String fechareg_confirmado = '';
  String estado_confirmado = '';
  String est_oficial = '';
  String est_oficial_fecha = '';
  String est_oficial_pers = '';
  String fechareg_r = '';
  String estadoreg_r = '';
  String almacenista_s = '';
  String comentario_s = '';
  String comentario_pre = '';
  String comentario_sap = '';
  String comentario_confirmado = '';
  String soporte_informe = '';
  Estados({
    this.fechareg_s = '',
    this.estadoreg_s = '',
    this.mensajes_r = '',
    this.funcional_pre = '',
    this.fechareg_pre = '',
    this.estadoreg_pre = '',
    this.numero_sap = '',
    this.soporte_sap = '',
    this.funcional_sap = '',
    this.fechareg_sap = '',
    this.estadoreg_sap = '',
    this.ctd_confirmado = '',
    this.fechareg_confirmado = '',
    this.estado_confirmado = '',
    this.est_oficial = '',
    this.est_oficial_fecha = '',
    this.est_oficial_pers = '',
    this.fechareg_r = '',
    this.estadoreg_r = '',
    this.almacenista_s = '',
    this.comentario_s = '',
    this.comentario_pre = '',
    this.comentario_sap = '',
    this.comentario_confirmado = '',
    this.soporte_informe = '',
    this.estado = 'borrador',
    this.estado_contrato = 'borrador',
    this.estado_enel = 'none',
    this.estado_sap = 'none',
    this.estado_enelColor = const Color.fromARGB(255, 226, 225, 225),
    this.estado_sapColor = const Color.fromARGB(255, 226, 225, 225),
    this.estado_contratoColor = const Color.fromARGB(255, 226, 225, 225),
  });

  List<String> toList() => [
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
        fechareg_r,
        estadoreg_r,
        almacenista_s,
        comentario_s,
        comentario_pre,
        comentario_sap,
        comentario_confirmado,
        soporte_informe,
      ];

  Color estado_enelColor = Colors.grey[300]!;
  Color estado_sapColor = Colors.grey[300]!;
  Color estado_contratoColor = Colors.grey[300]!;
  String estado = 'borrador';
  String estado_contrato = 'borrador';
  String estado_enel = 'none';
  String estado_sap = 'none';
  EstadoVista estadoVista = EstadoVista.primero;

  // Color get estado_contratoColor {
  //   Color colorTemp = Colors.grey[300]!;
  //   DateTime fecha1 = DateTime.parse(fechareg_r);
  //   if (estadoreg_r == 'borrador') {
  //     colorTemp = Colors.grey;
  //     estado_contrato = 'borrador';
  //   }
  //   if (estadoreg_r == 'calidad') {
  //     colorTemp = Colors.yellow;
  //     estado_contrato = 'calidad';
  //   }
  //   if (fechareg_s.isNotEmpty && DateTime.parse(fechareg_s).isAfter(fecha1)) {
  //     colorTemp = Colors.green;
  //     if (estadoreg_s == 'solicitado') {
  //       estado_enelColor = Colors.blue[200]!;
  //       estado_contrato = 'solicitado';
  //     }
  //   }
  //   if (fechareg_pre.isNotEmpty &&
  //       DateTime.parse(fechareg_pre).isAfter(fecha1) &&
  //       fechareg_s.isNotEmpty &&
  //       DateTime.parse(fechareg_pre).isAfter(DateTime.parse(fechareg_s))) {
  //     colorTemp = Colors.green;
  //     estado = estadoreg_pre;
  //     // estado_enel = estadoreg_pre;
  //     if (estadoreg_pre == 'true') {
  //       estado_enelColor = Colors.green[200]!;
  //       estado_enel = 'preaprobado';
  //     }
  //     if (estadoreg_pre == 'saperror') {
  //       estado_enelColor = Colors.yellow;
  //       estado_enel = 'saperror';
  //     }
  //   }
  //   if (fechareg_sap.isNotEmpty &&
  //       fechareg_pre.isNotEmpty &&
  //       (DateTime.parse(fechareg_sap).isAfter(DateTime.parse(fechareg_pre)) ||
  //           DateTime.parse(fechareg_sap)
  //               .isAtSameMomentAs(DateTime.parse(fechareg_pre)))) {
  //     colorTemp = Colors.green;
  //     estado_enelColor = Colors.green;
  //     if (estadoreg_sap == 'sapenconfirmacion') {
  //       estado_sapColor = Colors.green[200]!;
  //       estado_enel = 'aprobado';
  //       estado_sap = 'sapenconfirmacion';
  //     }
  //     if (estadoreg_sap == 'saperror') {
  //       estado_enelColor = Colors.yellow;
  //       estado_sapColor = Colors.grey;
  //       estado_enel = 'saperror';
  //       estado_sap = 'none';
  //     }

  //     estado = estadoreg_sap;
  //   }
  //   if (fechareg_confirmado.isNotEmpty &&
  //       fechareg_sap.isNotEmpty &&
  //       (DateTime.parse(fechareg_confirmado)
  //           .isAfter(DateTime.parse(fechareg_sap)))) {
  //     colorTemp = Colors.green;
  //     estado_enelColor = Colors.green;
  //     estado = estado_confirmado;
  //     if (estado_confirmado == 'true') {
  //       estado_sapColor = Colors.green;
  //       estado_sap = 'confirmado';
  //     }
  //   }
  //   return colorTemp;
  // }

  Color get fechareg_sColor => fechareg_s.isEmpty ? Colors.red : Colors.green;
  Color get estadoreg_sColor => estadoreg_s.isEmpty ? Colors.red : Colors.green;
  Color get mensajes_rColor => mensajes_r.isEmpty ? Colors.red : Colors.green;
  Color get funcional_preColor =>
      funcional_pre.isEmpty ? Colors.red : Colors.green;
  Color get fechareg_preColor =>
      fechareg_pre.isEmpty ? Colors.red : Colors.green;
  Color get estadoreg_preColor =>
      estadoreg_pre.isEmpty ? Colors.red : Colors.green;
  Color get numero_sapColor => numero_sap.isEmpty ? Colors.red : Colors.green;
  Color get soporte_sapColor => soporte_sap.isEmpty ? Colors.red : Colors.green;
  Color get funcional_sapColor =>
      funcional_sap.isEmpty ? Colors.red : Colors.green;
  Color get fechareg_sapColor =>
      fechareg_sap.isEmpty ? Colors.red : Colors.green;
  Color get estadoreg_sapColor =>
      estadoreg_sap.isEmpty ? Colors.red : Colors.green;
  Color get ctd_confirmadoColor =>
      ctd_confirmado.isEmpty ? Colors.red : Colors.green;
  Color get fechareg_confirmadoColor =>
      fechareg_confirmado.isEmpty ? Colors.red : Colors.green;
  Color get estado_confirmadoColor =>
      estado_confirmado.isEmpty ? Colors.red : Colors.green;
  Color get est_oficialColor => est_oficial.isEmpty ? Colors.red : Colors.green;
  Color get est_oficial_fechaColor =>
      est_oficial_fecha.isEmpty ? Colors.red : Colors.green;
  Color get est_oficial_persColor =>
      est_oficial_pers.isEmpty ? Colors.red : Colors.green;
  Color get fechareg_rColor => fechareg_r.isEmpty ? Colors.red : Colors.green;
  Color get estadoreg_rColor => estadoreg_r.isEmpty ? Colors.red : Colors.green;
  Color get almacenista_sColor =>
      almacenista_s.isEmpty ? Colors.red : Colors.green;
  Color get comentario_sColor =>
      comentario_s.isEmpty ? Colors.red : Colors.green;
  Color get comentario_preColor =>
      comentario_pre.isEmpty ? Colors.red : Colors.green;
  Color get comentario_sapColor =>
      comentario_sap.isEmpty ? Colors.red : Colors.green;
  Color get comentario_confirmadoColor =>
      comentario_confirmado.isEmpty ? Colors.red : Colors.green;
  Color get soporte_informeColor =>
      soporte_informe.isEmpty ? Colors.orange : Colors.green;

  Map get toMap => {
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
        'fechareg_r': fechareg_r,
        'estadoreg_r': estadoreg_r,
        'almacenista_s': almacenista_s,
        'comentario_s': comentario_s,
        'comentario_pre': comentario_pre,
        'comentario_sap': comentario_sap,
        'comentario_confirmado': comentario_confirmado,
        'soporte_informe': soporte_informe,
      };

  factory Estados.fromResgistroFila(ResgistroFila registro) {
    String estado = 'borrador';
    String estado_contrato = 'borrador';
    String estado_enel = 'none';
    String estado_sap = 'none';
    Color estado_enelColor = Colors.grey[300]!;
    Color estado_sapColor = Colors.grey[300]!;
    Color estado_contratoColor = Colors.grey[300]!;
    DateTime fecha1 = DateTime.parse(registro.fechareg_r);
    if (registro.estadoreg_r == 'borrador') {
      estado_contratoColor = Colors.grey;
      estado_contrato = 'borrador';
    }
    if (registro.estadoreg_r == 'calidad') {
      estado_contratoColor = Colors.yellow;
      estado_contrato = 'calidad';
      estado = 'calidad';
    }
    if (registro.fechareg_s.isNotEmpty &&
        DateTime.parse(registro.fechareg_s).isAfter(fecha1)) {
      estado_contratoColor = Colors.green;
      if (registro.estadoreg_s == 'solicitado') {
        estado_enelColor = Colors.blue[200]!;
        estado_contrato = 'solicitado';
        estado = 'solicitado';
      }
    }
    if (registro.fechareg_pre.isNotEmpty &&
        DateTime.parse(registro.fechareg_pre).isAfter(fecha1) &&
        registro.fechareg_s.isNotEmpty &&
        DateTime.parse(registro.fechareg_pre)
            .isAfter(DateTime.parse(registro.fechareg_s))) {
      estado_contratoColor = Colors.green;
      // estado = registro.estadoreg_pre;
      // estado_enel = estadoreg_pre;
      if (registro.estadoreg_pre == 'true') {
        estado_enelColor = Colors.green[200]!;
        estado_enel = 'preaprobado';
        estado = 'preaprobado';
      }
      if (registro.estadoreg_pre == 'saperror') {
        estado_enelColor = Colors.yellow;
        estado_enel = 'saperror';
        estado = 'saperror';
      }
    }
    if (registro.fechareg_sap.isNotEmpty &&
        registro.fechareg_pre.isNotEmpty &&
        (DateTime.parse(registro.fechareg_sap)
                .isAfter(DateTime.parse(registro.fechareg_pre)) ||
            DateTime.parse(registro.fechareg_sap)
                .isAtSameMomentAs(DateTime.parse(registro.fechareg_pre)))) {
      estado_contratoColor = Colors.green;
      estado_enelColor = Colors.green;
      if (registro.estadoreg_sap == 'sapenconfirmacion') {
        estado_sapColor = Colors.green[200]!;
        estado_enel = 'aprobado';
        estado_sap = 'sapenconfirmacion';
        estado = 'aprobado';
      }
      if (registro.estadoreg_sap == 'saperror') {
        estado_enelColor = Colors.yellow;
        estado_sapColor = Colors.grey;
        estado_enel = 'saperror';
        estado = 'saperror';
        estado_sap = 'none';
      }

      estado = registro.estadoreg_sap;
    }
    if (registro.fechareg_confirmado.isNotEmpty &&
        registro.fechareg_sap.isNotEmpty &&
        (DateTime.parse(registro.fechareg_confirmado)
            .isAfter(DateTime.parse(registro.fechareg_sap)))) {
      estado_contratoColor = Colors.green;
      estado_enelColor = Colors.green;
      // estado = registro.estado_confirmado;
      if (registro.estado_confirmado == 'true') {
        estado_sapColor = Colors.green;
        estado_sap = 'confirmado';
        estado = 'confirmado';
      }
    }

    if (registro.estadoreg_r == 'anulado') {
      estado_contratoColor = Colors.red;
      estado_enelColor = Colors.grey;
      estado_sapColor = Colors.grey;
      estado_contrato = 'anulado';
      estado = 'anulado';
    }

    return Estados(
      fechareg_s: registro.fechareg_s,
      estadoreg_s: registro.estadoreg_s,
      mensajes_r: registro.mensajes_r,
      funcional_pre: registro.funcional_pre,
      fechareg_pre: registro.fechareg_pre,
      estadoreg_pre: registro.estadoreg_pre,
      numero_sap: registro.numero_sap,
      soporte_sap: registro.soporte_sap,
      funcional_sap: registro.funcional_sap,
      fechareg_sap: registro.fechareg_sap,
      estadoreg_sap: registro.estadoreg_sap,
      ctd_confirmado: registro.ctd_confirmado,
      fechareg_confirmado: registro.fechareg_confirmado,
      estado_confirmado: registro.estado_confirmado,
      est_oficial: registro.est_oficial,
      est_oficial_fecha: registro.est_oficial_fecha,
      est_oficial_pers: registro.est_oficial_pers,
      fechareg_r: registro.fechareg_r,
      estadoreg_r: registro.estadoreg_r,
      almacenista_s: registro.almacenista_s,
      comentario_s: registro.comentario_s,
      comentario_pre: registro.comentario_pre,
      comentario_sap: registro.comentario_sap,
      comentario_confirmado: registro.comentario_confirmado,
      soporte_informe: registro.soporte_informe,
      estado: estado,
      estado_contrato: estado_contrato,
      estado_enel: estado_enel,
      estado_sap: estado_sap,
      estado_enelColor: estado_enelColor,
      estado_sapColor: estado_sapColor,
      estado_contratoColor: estado_contratoColor,
    );
  }

  factory Estados.nuevo() {
    return Estados(
      fechareg_s: '',
      estadoreg_s: '',
      mensajes_r: '',
      funcional_pre: '',
      fechareg_pre: '',
      estadoreg_pre: '',
      numero_sap: '',
      soporte_sap: '',
      funcional_sap: '',
      fechareg_sap: '',
      estadoreg_sap: '',
      ctd_confirmado: '',
      fechareg_confirmado: '',
      estado_confirmado: '',
      est_oficial: '',
      est_oficial_fecha: '',
      est_oficial_pers: '',
      fechareg_r: '',
      estadoreg_r: '',
      almacenista_s: '',
      comentario_s: '',
      comentario_pre: '',
      comentario_sap: '',
      comentario_confirmado: '',
      soporte_informe: '',
    );
  }
}

enum EstadoVista {
  primero,
  segundo,
  tercero,
}
