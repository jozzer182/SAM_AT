import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/remisiones/remision/model/remision_cabecera_model.dart';
import 'package:samat2co/remisiones/remision/model/remision_enum.dart';
import 'package:samat2co/remisiones/remision/model/remision_registro_model.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_registros_model.dart';
import 'package:samat2co/resources/a_entero.dart';

import 'package:samat2co/user/user_model.dart';

import '../../../resources/constants/apis.dart';

class Remision {
  List<RemisionRegistro> registros = [];
  RemisionCabecera cabecera = RemisionCabecera.zero();

  Remision({
    required this.registros,
    required this.cabecera,
  });

  factory Remision.fromInit(User user) {
    return Remision(
      registros: List.generate(
        3,
        (index) => RemisionRegistro.fromInit(index + 1),
      ),
      cabecera: RemisionCabecera.fromInit(user),
    );
  }

  factory Remision.fromRemisionesRegistros(
      List<RemisionesRegistros> remisionesRegistrosList) {
    return Remision(
      registros: List.generate(
        remisionesRegistrosList.length,
        (index) => RemisionRegistro.fromRemisionesRegistros(
            remisionesRegistrosList[index]),
      ),
      cabecera: RemisionCabecera.fromRemisionesRegistros(
          remisionesRegistrosList.first),
    );
  }

  modifyList({
    required String index,
    required String method,
  }) {
    if (method == 'agregar') agregar;
    if (method == 'eliminar') eliminar;
    if (method == 'resize') resize(index);
    if (method == 'clear') clear;
  }

  get agregar {
    registros.add(RemisionRegistro.fromInit(registros.length + 1));
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
        registros.add(RemisionRegistro.fromInit(i + 1));
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

  Future<String> lastNumberReg(User user) async {
    Map dataSend = {
      'info': {'libro': user.pdi, 'hoja': 'ingresos'},
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
    required CampoRemision campo,
    required String valor,
    required int index,
    required Mm60 mm60,
  }) {
    // if (campo == CampoRemision.id) cabecera.id = valor;
    if (campo == CampoRemision.pedido) cabecera.pedido = valor;
    if (campo == CampoRemision.codigo_massy) cabecera.codigo_massy = valor;
    if (campo == CampoRemision.fecha_i) cabecera.fecha_i = valor;
    if (campo == CampoRemision.almacenista_i) cabecera.almacenista_i = valor;
    if (campo == CampoRemision.tel_i) cabecera.tel_i = valor;
    if (campo == CampoRemision.soporte_i) cabecera.soporte_i = valor;
    // if (campo == CampoRemision.item) cabecera.item = valor;
    if (campo == CampoRemision.e4e) {
      registros[index].e4e = valor;
      Mm60Single mm60Encontrado = mm60.mm60List.firstWhere(
        (e) => e.material.contains(valor),
        orElse: () => Mm60Single(
          material: 'material',
          precio: 'precio',
          descripcion: 'No encontrado',
          ultima_m: 'modif',
          tpmt: 'tpmt',
          grupo: '',
          um: 'na',
          mon: 'mon',
          actualizado: '',
        ),
      );
      registros[index].descripcion = mm60Encontrado.descripcion;
      registros[index].um = mm60Encontrado.um;
    }
    // if (campo == CampoRemision.descripcion) cabecera.descripcion = valor;
    // if (campo == CampoRemision.um) cabecera.um = valor;
    if (campo == CampoRemision.ctd) {
      registros[index].ctd = aEntero(valor);
    }
    if (campo == CampoRemision.proyecto) cabecera.proyecto = valor;
    // if (campo == CampoRemision.ingeniero_enel) cabecera.ingeniero_enel = valor;
    // if (campo == CampoRemision.almacenista_r) cabecera.almacenista_r = valor;
    // if (campo == CampoRemision.tel_r) cabecera.tel_r = valor;
    // if (campo == CampoRemision.fecha_r) cabecera.fecha_r = valor;
    // if (campo == CampoRemision.unidad_r) cabecera.unidad_r = valor;
    // if (campo == CampoRemision.soporte_r) cabecera.soporte_r = valor;
    if (campo == CampoRemision.reportado) cabecera.reportado = valor;
    if (campo == CampoRemision.comentario_i) cabecera.comentario_i = valor;
    if (campo == CampoRemision.estado) cabecera.estado = valor;
    if (campo == CampoRemision.tipo) {
      cabecera.tipo = valor;
    }
  }

  List? get validar {
    List faltantes = [];
    Color r = Colors.red;
    RemisionCabecera e = cabecera;
    if (e.codigo_massyColor == r) faltantes.add('Código Massy');
    if (e.soporte_iColor == r) faltantes.add('Soporte de Entrega');
    for (RemisionRegistro reg in registros) {
      String f = 'Item: ${reg.item} =>';
      if (reg.e4eColor == r) f += ' E4e,';
      if (reg.ctdColor == r) f += ' Ctd,';
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

  Future<String?> addToDbRemisiones({
    required User user,
  }) async {
    List<Map> list = [];
    if (cabecera.tipo == "traslado (salida)") {
      for (RemisionRegistro element in registros) {
        element.ctd = element.ctd * -1;
      }
    }
    cabecera.estado = "correcto";
    for (RemisionRegistro material in registros) {
      list.add({...material.toMap(), ...cabecera.toMap()});
    }
    Map<String, Object> dataSend = {
      'info': {'libro': user.pdi, 'listMap': list, 'hoja': 'ingresos'},
      'fname': "addListMapDB"
    };
    // print(jsonEncode(dataSend));
    var response = await post(Uri.parse(Api.samat), body: jsonEncode(dataSend));
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

  Future<String?> updateToDbRemisiones({
    required User user,
  }) async {
    if (cabecera.tipo == "traslado (salida)") {
      for (RemisionRegistro element in registros) {
        element.ctd = element.ctd.abs() * -1;
      }
    }

    List<Map> list = [];
    for (RemisionRegistro material in registros) {
      list.add({...material.toMap(), ...cabecera.toMap()});
    }
    Map<String, Object> dataSend = {
      'info': {'libro': user.pdi, 'listMap': list, 'hoja': 'ingresos'},
      'fname': "updateListMapDB"
    };
    // print(jsonEncode(dataSend));
    var response = await post(Uri.parse(Api.samat), body: jsonEncode(dataSend));
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
}
