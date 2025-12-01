import 'dart:convert';

import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/planilla/model/planilla_model.dart';
import 'package:samat2co/registros/registro_fila_model.dart';
import 'package:http/http.dart' as http;
import 'package:samat2co/user/user_model.dart';

import '../resources/constants/apis.dart';
import '../resources/group.dart';

class Planillas {
  List<ResgistroFila> registrosList = [];
  List<ResgistroFila> registrosListSearch = [];
  List<Planilla> planillasList = [];
  List<Planilla> planillasListSearch = [];
  Planilla planillaSelected = Planilla.fromInit();
  int view = 50;
  Future obtener({
    required User user,
    required Mm60 mm60,
  }) async {
    registrosList.clear();
    registrosListSearch.clear();
    Map<String, Object> dataSend = {
      'info': {'libro': user.pdi, 'hoja': 'registros'},
      'fname': "getDB"
    };
    // print(jsonEncode(dataSend));
    final http.Response response = await http.post(
      Uri.parse(Api.samat),
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    for (var item in dataAsListMap) {
      // print(item["id"]);
      registrosList.add(ResgistroFila.fromMap(item));
    }
    // registrosList.sort((a, b) => b.pedido.compareTo(a.pedido));
    registrosList = registrosList.reversed.toList();
    registrosListSearch = [...registrosList];
    // Calculamos el total de planillas diferentes
    List<String> pedidos = registrosList.map((e) => e.pedido).toSet().toList();
    pedidos.sort();
    pedidos = pedidos.reversed.toList();
    // print('planillas: $planillas');
    List<ResgistroFila> planillaTemp = [];
    //Para cada planilla diferente, guardamos los registros en un temporal
    //Despues si lo agregamos al modelo de planilla
    for (String pedido in pedidos) {
      for (ResgistroFila registroFila in registrosList) {
        if (pedido == registroFila.pedido) {
          planillaTemp.add(registroFila);
        }
      }
      //Obtener el Precio
      int precioTemp = 0;
      for (ResgistroFila registro in planillaTemp) {
        // print('registro.e4e ${registro.e4e}');
        precioTemp += int.parse(
          mm60.mm60List
              .firstWhere(
                (e) => e.material == registro.e4e,
                orElse: () => Mm60Single.zero(),
              )
              .precio,
        );
      }
      planillasList.add(Planilla.fromResgistroFila(planillaTemp)
        ..precio = precioTemp
        ..registros.sort((a, b) => a.item.compareTo(b.item)));
      planillaTemp.clear();
    }
    planillasListSearch = [...planillasList];
    // print('planillas $planillas');
    // print('planillasList $planillasList');
  }

  //make a searcher for planillasList
  buscar(String value) {
    planillasListSearch = [...planillasList];
    planillasListSearch = planillasList
        .where(
          (Planilla e) => e.toList().any(
                (el) => el.toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              ),
        )
        .toList();
  }

  buscarsimple(String value) {
    // print('buscar');
    registrosListSearch = [...registrosList];
    registrosListSearch = registrosList
        .where(
          (ResgistroFila e) => e.toList().any(
                (el) => el.toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get porLCL {
    var dataAsListMap2 = registrosList
        .where((e) =>
            (e.est_oficial == 'borrador' ||
                e.est_oficial == 'solicitado' ||
                e.est_oficial == 'preaprobado' ||
                e.est_oficial == 'calidad' ||
                e.est_oficial == 'sapenconfirmacion' ||
                e.est_oficial == 'saperror') &&
            e.estadoreg_r != 'anulado')
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd_total': int.parse(e.ctd_total),
                'estado': e.est_oficial,
              }
            })
        .toList();
    // print('dataAsListMap2 from regsitros porLCL : $dataAsListMap2');
    //agrupar y sumar por e4e
    var keysToSelect = ['lcl', 'e4e', 'descripcion', 'um', 'estado'];
    var keysToSum = ['ctd_total'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    registros.sort((a, b) => int.parse('${a['lcl']}${a['e4e']}')
        .compareTo(int.parse('${b['lcl']}${b['e4e']}')));
    return registros;
  }
}
