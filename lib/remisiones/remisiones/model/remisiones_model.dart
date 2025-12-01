import 'dart:convert';

import 'package:samat2co/remisiones/remision/model/remision_model.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_registros_model.dart';
import 'package:samat2co/user/user_model.dart';
import 'package:http/http.dart';

import '../../../resources/constants/apis.dart';

class Remisiones {
  List<RemisionesRegistros> registrosList = [];
  List<RemisionesRegistros> registrosListSearch = [];
  List<Remision> remisionesList = [];
  List<Remision> remisionesListSearch = [];
  Remision? remisionSelected;
  int view = 50;
  Map itemsAndFlex = {
    'pedido': 2,
    'codigo_massy': 2,
    'fecha_i': 2,
    'soporte_r': 1,
    'item': 1,
    'e4e': 2,
    'descripcion': 6,
    'um': 1,
    'ctd': 1,
    'X': 1,
  };

  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  List<TitleModel> titles = [
    TitleModel('id', 'id', 2),
    TitleModel('pedido', 'pedido', 2),
    TitleModel('codigo_massy', 'código massy', 2),
    TitleModel('fecha_i', 'Ingreso', 3),
    TitleModel('almacenista_i', 'almacenista', 4),
    TitleModel('soporte_i', 'adj.', 1),
    TitleModel('item', 'item', 1),
    TitleModel('e4e', 'e4e', 2),
    TitleModel('descripcion', 'descripción', 3),
    TitleModel('um', 'um', 1),
    TitleModel('ctd', 'ctd', 1),
    TitleModel('comentario_i', 'comentario', 3),
  ];

  buscar(String busqueda) {
    registrosListSearch = [...registrosList];
    registrosListSearch = registrosList
        .where((element) => element.toMap().values.any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  Future obtener(User user) async {
    var dataSend = {
      'info': {'libro': user.pdi, 'hoja': 'ingresos'},
      'fname': "getDB"
    };
    // print(jsonEncode(dataSend));
    final response = await post(
      Uri.parse(Api.samat),
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    for (var item in dataAsListMap) {
      if (item['estado'] != 'anulado') {
        registrosList.add(RemisionesRegistros.fromMap(item));
      }
    }
    // print(registrosList.length);
    registrosList = registrosList.reversed.toList();
    registrosListSearch = [...registrosList];

    //creacion de remision
    List<String> pedidosList =
        registrosList.map((e) => e.pedido).toSet().toList();

    List<RemisionesRegistros> remisionTemporal = [];

    for (String pedido in pedidosList) {
      for (RemisionesRegistros registro in registrosList) {
        if (registro.pedido == pedido) {
          remisionTemporal.add(registro);
        }
      }
      remisionTemporal.sort((a, b) => a.item.compareTo(b.item));
      remisionesList.add(
        Remision.fromRemisionesRegistros(remisionTemporal),
      );
      remisionTemporal.clear();
    }
  }

  Remision? seleccionarRemision(String pedido) {
    remisionSelected =
        remisionesList.firstWhere((e) => e.cabecera.pedido == pedido);
    return remisionSelected;
  }
}

class TitleModel {
  final String key;
  final String title;
  final int flex;
  TitleModel(
    this.key,
    this.title,
    this.flex,
  );
}
