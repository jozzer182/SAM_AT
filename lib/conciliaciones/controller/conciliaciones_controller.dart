import 'dart:convert';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../resources/constants/apis.dart';
import '../model/conciliaciones_reg_model.dart';
import '../model/concilicaicones_list_model.dart';

class ConciliacionesController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;

  ConciliacionesController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    try {
      ConciliacionesList conciliacionesList = ConciliacionesList();
      Map<String, Object> dataSend = {
        'info': {
          'libro': state().user?.pdi ?? "",
          'hoja': 'conciliaciones',
        },
        'fname': "getDB"
      };
      print(jsonEncode(dataSend));
      final Response response = await post(
        Uri.parse(Api.samat),
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      if (dataAsListMap is List && dataAsListMap.isNotEmpty) {
        conciliacionesList.list.addAll(
            dataAsListMap.map((e) => ConciliacionesReg.fromMap(e)).toList());
      }
      emit(state().copyWith(conciliacionesList: conciliacionesList));
      print("CONCILICACIONES ${conciliacionesList.list.length}");
    } catch (e) {
      bl.errorCarga("CONCILICACIONES", e);
    }
  }

  setConciliacion(ConciliacionesReg conciliacion) async {
    emit(state().copyWith(conciliacion: conciliacion));
  }

  get enviar async {
    try {
      bl.startLoading;
      ConciliacionesReg conciliacion = state().conciliacion!;
      Map<String, Object> dataSend = {
        'info': {
          'libro': state().user?.pdi ?? "",
          'hoja': 'conciliaciones',
          'map': conciliacion.toMap(),
        },
        'fname': "addConciliacion"
      };
      print(jsonEncode(dataSend));
      final Response response = await post(
        Uri.parse(Api.samat),
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      bl.mensajeFlotante(message: dataAsListMap.toString());
      // print("CONCILICACIONES ${conciliacionesList.list.length}");
    } catch (e) {
      bl.errorCarga("CONCILICACIONES", e);
    }
    bl.stopLoading;
  }
}
