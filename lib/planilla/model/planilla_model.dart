// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/pdis/pdis_model.dart';
import 'package:samat2co/people/people_b.dart';
import 'package:samat2co/planilla/model/cabecera_model.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';
import 'package:samat2co/registros/registro_fila_model.dart';
import 'package:samat2co/planilla/model/registro_model.dart';
import 'package:samat2co/user/user_model.dart';

import '../../lcl/model/lcl_model.dart';
import '../../resources/constants/apis.dart';
import 'estados_model.dart';

// Creare una calse para contener los campos de una planilla,
// el encabezado deberian ser string, y los registros los puedo guardar como una lista de resgistros
// sin embargo para crearlo necesito como entrada una lista de registros
// lo cuales previamente filtrare, de alli extraere una lista de resgistros sencillos sin encabezado
// y extraere los campos de encabezado.

class Planilla {
  List<Registro> registros = [];
  Cabecera cabecera = Cabecera();
  Estados estados = Estados();
  int precio = 0;

  Planilla({
    required this.registros,
    required this.cabecera,
    required this.estados,
    this.precio = 0,
  });

  List<String> toList() => [
        ...registros.map((e) => e.toListPdf()).expand((el) => el).toList(),
        ...cabecera.toList(),
        ...estados.toList(),
      ];

  factory Planilla.fromInit() {
    return Planilla(
      registros: [],
      cabecera: Cabecera(),
      estados: Estados(),
    );
  }

  factory Planilla.fromResgistroFila(List<ResgistroFila> planillaList) {
    return Planilla(
      registros: List.generate(
        planillaList.length,
        (i) => Registro.fromResgistroFila(planillaList[i]),
      ),
      cabecera: Cabecera.fromResgistroFila(planillaList.first),
      estados: Estados.fromResgistroFila(planillaList.first),
    );
  }

  factory Planilla.nuevo() {
    return Planilla(
      registros: List.generate(
        3,
        (i) => Registro.nuevo(i),
      ),
      cabecera: Cabecera.nuevo(),
      estados: Estados.nuevo(),
    );
  }

  modifyList(String index, String method) {
    if (method == 'agregar') agregar;
    if (method == 'eliminar') eliminar;
    if (method == 'resize') resize(index);
    if (method == 'clear') clear;
  }

  void crear({
    required User user,
    required Pdis pdis,
    required Mm60 mm60,
  }) {
    //Datos de registros
    registros.clear();
    registros = List.generate(3, (index) => Registro.nuevo(index + 1));
    //Datos de Cabecera
    // DateTime date = DateTime.now();
    // String dateString =
    //     '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    cabecera.tipo_movimiento = 'Salida';
    cabecera.almacenista_e = user.correo;
    cabecera.tel_alm_e = user.telefono;
    cabecera.pdi = user.pdi;
    PdisSingle pdisSingle = pdis.pdisList.firstWhere(
      (e) => e.pdi == user.pdi,
      orElse: () => PdisSingle.zero(),
    );
    if (pdisSingle.pdi.isNotEmpty) {
      cabecera.nombre_pdi = pdisSingle.nombrepdi;
      cabecera.contrato = pdisSingle.contrato;
    }
    //Datos de estados
    estados.fechareg_r = DateTime.now().toString().substring(0, 16);
    estados.estadoreg_r = 'borrador';
    estados.est_oficial_fecha = DateTime.now().toString().substring(0, 16);
    estados.est_oficial = 'borrador';
    estados.est_oficial_pers = user.correo;

    //CREAR json para guardar historia de mensajes
    List mensajes = [];
    mensajes.add({
      'fecha': estados.fechareg_r,
      'estado': estados.estadoreg_r,
      'mensaje': 'Planilla creada',
      'persona': user.correo,
    });
    estados.mensajes_r = jsonEncode(mensajes);
  }

  get agregar {
    registros.add(Registro.nuevo(registros.length + 1));
  }

  get eliminar {
    registros.removeLast();
  }

  resize(String index) {
    index = index.isEmpty ? '1' : index;
    int size = int.parse(index);
    int len = registros.length;
    if (size > len) {
      for (int i = len; i < size; i++) {
        registros.add(Registro.nuevo(i + 1));
      }
    } else {
      for (int i = size; i < len; i++) {
        registros.removeLast();
      }
    }
  }

  get clear {
    registros.clear();
    resize('3');
  }

  Future<String> get lastNumberReg async {
    Map dataSend = {
      'info': {'libro': cabecera.pdi, 'hoja': 'registros'},
      'fname': "lastNumberReg"
    };
    // print(jsonEncode(dataSend));
    Response response =
        await post(Uri.parse(Api.samat), body: jsonEncode(dataSend));
    // print(response.body);
    String respuesta = jsonDecode(response.body) ?? 'error';
    // print(respuesta);
    return respuesta;
  }

  asignar({
    required CampoPlanilla campo,
    required String valor,
    required int index,
    required Lcl lcl,
    required People people,
    required User user,
  }) {
    //Cabecera
    if (campo == CampoPlanilla.pedido) cabecera.pedido = valor; //OK
    if (campo == CampoPlanilla.planilla) {
      cabecera.planilla = valor; //FUTURE BUILDER
    }
    if (campo == CampoPlanilla.unidad) cabecera.unidad = valor; //OK
    if (campo == CampoPlanilla.tipo_movimiento) {
      cabecera.tipo_movimiento = valor; //OK --> DESPLEGABLE
    }
    if (campo == CampoPlanilla.solicitante) cabecera.solicitante = valor; //OK
    if (campo == CampoPlanilla.contrato) cabecera.contrato = valor; //OK
    if (campo == CampoPlanilla.nombre_pdi) cabecera.nombre_pdi = valor; //OK
    if (campo == CampoPlanilla.pdi) cabecera.pdi = valor; //OK
    if (campo == CampoPlanilla.proceso) cabecera.proceso = valor; //OK
    if (campo == CampoPlanilla.proyecto) cabecera.proyecto = valor; // OK
    if (campo == CampoPlanilla.ingeniero_enel) {
      cabecera.ingeniero_enel = valor; //OK --> DESPLEGABLE
    }
    if (campo == CampoPlanilla.lcl) {
      cabecera.lcl = valor.toLowerCase(); //OK
      LclSingle lclSapSingle = lcl.lclList.firstWhere(
        (e) => e.lcl == valor,
        orElse: () => LclSingle.fromInit(),
      );
      String usuario = lclSapSingle.usuario;
      if (people.people
          .map((e) => e.name.toLowerCase())
          .contains(usuario.toLowerCase())) {
        cabecera.ingeniero_enel = usuario.toLowerCase();
      }
      String grupo = lclSapSingle.grupo;
      if (grupo == 'PM&C') cabecera.unidad = 'PM&C';
      if (grupo == 'ORA') cabecera.unidad = 'ORA';
    }
    if (campo == CampoPlanilla.pdl) cabecera.pdl = valor; //OK
    if (campo == CampoPlanilla.comentario) cabecera.comentario = valor; //OK
    if (campo == CampoPlanilla.destino) cabecera.destino = valor; //OK
    if (campo == CampoPlanilla.almacenista_e) {
      cabecera.almacenista_e = valor; //OK
    }
    if (campo == CampoPlanilla.tel_alm_e) cabecera.tel_alm_e = valor; //OK
    if (campo == CampoPlanilla.fecha_e) cabecera.fecha_e = valor; //OK
    if (campo == CampoPlanilla.fecha_r) cabecera.fecha_r = valor; //OK
    if (campo == CampoPlanilla.lider_contrato_e) {
      cabecera.lider_contrato_e = valor; //OK
    }
    if (campo == CampoPlanilla.placa_cuadrilla_e) {
      cabecera.placa_cuadrilla_e = valor; //OK
    }
    if (campo == CampoPlanilla.tel_lider_e) cabecera.tel_lider_e = valor; //OK
    if (campo == CampoPlanilla.soporte_e) cabecera.soporte_e = valor; //OK

    // Registros
    if (campo == CampoPlanilla.id) registros[index].id = valor;
    if (campo == CampoPlanilla.item) registros[index].item = int.parse(valor);
    if (campo == CampoPlanilla.e4e) registros[index].e4e = valor;
    if (campo == CampoPlanilla.descripcion) {
      registros[index].descripcion = valor;
    }
    if (campo == CampoPlanilla.um) registros[index].um = valor;
    if (campo == CampoPlanilla.ctd_e) registros[index].ctd_e = int.parse(valor);
    if (campo == CampoPlanilla.ctd_r) registros[index].ctd_r = int.parse(valor);
    if (campo == CampoPlanilla.ctd_total) {
      registros[index].ctd_total = int.parse(valor);
    }
    //Estados
    if (campo == CampoPlanilla.soporte_informe) estados.soporte_informe = valor;
    if (campo == CampoPlanilla.fechareg_r) estados.fechareg_r = valor;
    if (campo == CampoPlanilla.estadoreg_r) {
      estados.estadoreg_r = valor;
      if (valor == 'calidad') {
        estados.fechareg_r = DateTime.now().toString();
      }
    }
    if (campo == CampoPlanilla.almacenista_s) estados.almacenista_s = valor;
    if (campo == CampoPlanilla.fechareg_s) estados.fechareg_s = valor;
    if (campo == CampoPlanilla.estadoreg_s) estados.estadoreg_s = valor;
    if (campo == CampoPlanilla.comentario_s) {
      estados.comentario_s = valor;
      if (valor.isEmpty) {
        estados.fechareg_s = '';
        estados.estadoreg_s = '';
        estados.almacenista_s = '';
      } else {
        estados.fechareg_s = DateTime.now().toString();
        estados.estadoreg_s = 'solicitado';
        estados.almacenista_s = user.correo;
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'solicitado';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_s,
          estado: 'solicitado',
        );
      }
    }

    if (campo == CampoPlanilla.mensajes_r) estados.mensajes_r = valor;
    if (campo == CampoPlanilla.funcional_pre) estados.funcional_pre = valor;
    if (campo == CampoPlanilla.fechareg_pre) {
      // print('From Model estados.fechareg_pre = $valor');
      estados.fechareg_pre = valor;
    }
    if (campo == CampoPlanilla.estadoreg_pre) {
      estados.estadoreg_pre = valor;
      if (estados.comentario_pre.isNotEmpty && valor == 'true') {
        estados.fechareg_pre = DateTime.now().toString();
        estados.funcional_pre = user.correo;
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'preaprobado';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_pre,
          estado: 'preaprobado',
        );
      } else {
        estados.fechareg_pre = '';
        estados.funcional_pre = '';
      }
    }
    if (campo == CampoPlanilla.comentario_pre) {
      estados.comentario_pre = valor;
      if (valor.isNotEmpty && estados.estadoreg_pre == 'true') {
        estados.fechareg_pre = DateTime.now().toString();
        estados.funcional_pre = user.correo;
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'preaprobado';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_pre,
          estado: 'preaprobado',
        );
      } else {
        estados.fechareg_pre = '';
        estados.funcional_pre = '';
      }
    }

    if (campo == CampoPlanilla.numero_sap) {
      if (valor.endsWith(',')) {
        // print('termina con ,');
        String newValor = valor.substring(0, valor.length - 1);
        estados.numero_sap = "{\"numero_sap\":[$newValor]}";
      } else {
        estados.numero_sap = "{\"numero_sap\":[$valor]}";
      }
      // print(estados.numero_sap);
      if (valor.isNotEmpty &&
          estados.soporte_sap.isNotEmpty &&
          estados.comentario_sap.isNotEmpty) {
        estados.funcional_sap = user.correo;
        estados.estadoreg_sap = 'sapenconfirmacion';
        estados.fechareg_sap = DateTime.now().toString();
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'sapenconfirmacion';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_sap,
          estado: 'sapenconfirmacion',
        );
      } else {
        estados.funcional_sap = '';
        estados.fechareg_sap = '';
        estados.estadoreg_sap = '';
      }
    }
    if (campo == CampoPlanilla.soporte_sap) {
      estados.soporte_sap = valor;
      if (valor.isNotEmpty &&
          estados.comentario_sap.isNotEmpty &&
          estados.numero_sap.isNotEmpty) {
        estados.funcional_sap = user.correo;
        estados.estadoreg_sap = 'sapenconfirmacion';
        estados.fechareg_sap = DateTime.now().toString();
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'sapenconfirmacion';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_sap,
          estado: 'sapenconfirmacion',
        );
      } else {
        estados.funcional_sap = '';
        estados.fechareg_sap = '';
        estados.estadoreg_sap = '';
      }
    }
    if (campo == CampoPlanilla.comentario_sap) {
      estados.comentario_sap = valor;
      if (valor.isNotEmpty &&
          estados.numero_sap.isNotEmpty &&
          estados.soporte_sap.isNotEmpty) {
        estados.funcional_sap = user.correo;
        estados.estadoreg_sap = 'sapenconfirmacion';
        estados.fechareg_sap = DateTime.now().toString();
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'sapenconfirmacion';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_sap,
          estado: 'sapenconfirmacion',
        );
      } else {
        estados.funcional_sap = '';
        estados.fechareg_sap = '';
        estados.estadoreg_sap = '';
      }
    }

    if (campo == CampoPlanilla.funcional_sap) estados.funcional_sap = valor;
    if (campo == CampoPlanilla.fechareg_sap) estados.fechareg_sap = valor;
    if (campo == CampoPlanilla.estadoreg_sap) {
      estados.estadoreg_sap = valor;
      if (valor == 'saperror') {
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'saperror';
        estados.est_oficial_pers = user.correo;
        estados.fechareg_sap = DateTime.now().toString();
        estados.funcional_sap = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_sap,
          estado: 'saperror',
        );
      }
    }
    if (campo == CampoPlanilla.ctd_confirmado) estados.ctd_confirmado = valor;
    if (campo == CampoPlanilla.fechareg_confirmado) {
      estados.fechareg_confirmado = valor;
    }
    if (campo == CampoPlanilla.estado_confirmado) {
      estados.estado_confirmado = valor;
      if (estados.comentario_confirmado.isNotEmpty && valor == 'true') {
        estados.fechareg_confirmado = DateTime.now().toString();
        estados.ctd_confirmado = registros
            .map((e) => e.ctd_total)
            .reduce((value, element) => value + element)
            .toString();
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'confirmado';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_confirmado,
          estado: 'confirmado',
        );
      } else {
        estados.fechareg_confirmado = '';
        estados.ctd_confirmado = '';
      }
    }
    if (campo == CampoPlanilla.comentario_confirmado) {
      estados.comentario_confirmado = valor;
      if (valor.isNotEmpty && estados.estado_confirmado == 'true') {
        estados.fechareg_confirmado = DateTime.now().toString();
        estados.ctd_confirmado = registros
            .map((e) => e.ctd_total)
            .reduce((value, element) => value + element)
            .toString();
        estados.est_oficial_fecha = DateTime.now().toString();
        estados.est_oficial = 'confirmado';
        estados.est_oficial_pers = user.correo;
        agregarMensaje(
          user: user,
          mensaje: estados.comentario_confirmado,
          estado: 'confirmado',
        );
      } else {
        estados.fechareg_confirmado = '';
        estados.ctd_confirmado = '';
      }
    }

    if (campo == CampoPlanilla.est_oficial) estados.est_oficial = valor;
    if (campo == CampoPlanilla.est_oficial_fecha) {
      estados.est_oficial_fecha = valor;
    }
    if (campo == CampoPlanilla.est_oficial_pers) {
      estados.est_oficial_pers = valor;
    }
  }

  agregarMensaje({
    required User user,
    required String mensaje,
    required String estado,
  }) {
    if (estados.mensajes_r.isNotEmpty && mensaje.isNotEmpty) {
      List mensajes = json.decode(estados.mensajes_r);
      int indexM = mensajes.indexWhere(
        (e) {
          // DateTime fecha = DateTime.parse(e['fecha']);
          // print('fecha: $fecha');
          return DateTime.parse(e['fecha']).isAfter(
                DateTime.now().subtract(
                  const Duration(minutes: 3),
                ),
              ) &&
              e['persona'] == user.correo &&
              e['estado'] == estado;
        },
      );
      if (indexM != -1) {
        mensajes[indexM]['fecha'] = DateTime.now().toString();
        mensajes[indexM]['estado'] = estado;
        mensajes[indexM]['mensaje'] = mensaje;
        mensajes[indexM]['persona'] = user.correo;
      } else {
        mensajes.add(
          {
            'fecha': DateTime.now().toString(),
            'estado': estado,
            'mensaje': mensaje,
            'persona': user.correo,
          },
        );
      }
      estados.mensajes_r = json.encode(mensajes);
    }
  }

  List? get validar {
    var faltantes = [];
    Color r = Colors.red;
    Cabecera c = cabecera;
    //validate all fields
    if (c.lclColor == r) faltantes.add('LCL/TICKET');
    if (c.solicitanteColor == r) faltantes.add('INGENIERO A CARGO');
    if (c.procesoColor == r) faltantes.add('PROCESO');
    if (c.placa_cuadrilla_eColor == r) faltantes.add('PLACA MOVIL');
    if (c.lider_contrato_eColor == r) faltantes.add('CUADRILLERO');
    if (c.tel_lider_eColor == r) faltantes.add('TEL CUADRILLERO');
    if (c.ingeniero_enelColor == r) faltantes.add('RESPONSABLE ENEL');
    if (c.pdlColor == r) faltantes.add('PDL');
    if (c.fecha_eColor == r) faltantes.add('FECHA ENTREGA');
    if (c.almacenista_eColor == r) faltantes.add('ALMACENISTA QUE ENTREGA');
    if (c.tel_alm_eColor == r) faltantes.add('TEL ALMACENISTA QUE ENTREGA');
    if (c.soporte_eColor == r) faltantes.add('SOPORTE ADJUNTO');
    for (Registro reg in registros) {
      String f = 'Item: ${reg.item} =>';
      if (reg.e4eColor == r) f += ' E4e,';
      if (reg.ctdEColor == r) f += ' Ctd Entregada,';
      if (f != 'Item: ${reg.item} =>') faltantes.add(f);
    }
    if (faltantes.isNotEmpty) {
      faltantes.insert(0,
          'Por favor revise los siguientes campos en la planilla, para poder realizar el guardado:');
      return faltantes;
    } else {
      return null;
    }
  }

  Future<String?> enviar({
    required User user,
    required bool esNuevo,
  }) async {
    List list = [];
    for (Registro row in registros) {
      list.add({
        ...row.toMap(),
        ...cabecera.toMap,
        ...estados.toMap,
      });
    }
    Map dataSend = {};
    if (esNuevo) {
      dataSend = {
        'info': {'libro': user.pdi, 'listMap': list, 'hoja': 'registros'},
        'fname': "addListMapDB"
      };
    } else {
      dataSend = {
        'info': {'libro': user.pdi, 'listMap': list, 'hoja': 'registros'},
        'fname': "updateListMapDB"
      };
      // print(jsonEncode(dataSend));
    }

    var response = await post(Uri.parse(Api.samat), body: jsonEncode(dataSend));
    // print(response.body);
    var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
    // print(respuesta);
    if (respuesta is List) {
      respuesta =
          'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
    } else {
      print(respuesta);
    }
    return respuesta;
  }

  Future<String?> enviarEmail({
    required User user,
  }) async {
    Map dataSend = {
      'info': {
        'data': {
          'cabecera': cabecera.toMap,
          'estados': estados.toMap,
          'registros': registros.map((e) => e.toMap()).toList(),
          'user': user.toMap()
        },
      },
      'fname': "sendMail"
    };
    // print(jsonEncode(dataSend));
    var response = await post(Uri.parse(Api.samat), body: jsonEncode(dataSend));
    return response.body;
  }

  @override
  String toString() =>
      'Planilla(cabecera: $cabecera, estados $estados, registros: $registros, precio: $precio)';
}
