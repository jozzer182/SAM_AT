import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:samat2co/mb51/mb51_model.dart';
import 'package:samat2co/mb52/mb52_model.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/planillas/planillas_model.dart';
import 'package:samat2co/resources/a_entero.dart';

import '../lcl/model/lcl_model.dart';

class DeudaOperativa {
  List<DeudaOperativaSingle> deudaOperativa = [];
  List<DeudaOperativaSingle> deudaOperativaListSearch = [];
  List<DeudaOperativaSingle> deudaOperativaListSearch2 = [];
  List<DeudaOperativaSingle> deudaOperativaPerson = [];
  List<DeudaOperativaSingle> deudaOperativaPersonSearch = [];
  int totalValor = 0;
  int totalSobrantes = 0;
  int totalFaltantes = 0;
  Map itemsAndFlex = {
    'lcl': 2,
    'destino': 2,
    'funcional': 4,
    'operativo': 4,
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'ctd_total': 1,
    'ctd_con': 1,
    'faltanteUnidades': 1,
    'faltanteValor': 2,
    'mb52': 1,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  Map itemsAndFlex2 = {
    // 'lcl': 2,
    'funcional': 4,
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'ctd_total': 1,
    'ctd_con': 1,
    'faltanteUnidades': 1,
    'faltanteValor': 2,
  };
  get keys2 {
    return itemsAndFlex2.keys.toList();
  }

  get listaTitulo2 {
    return [
      for (var key in keys2) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    deudaOperativaListSearch = [...deudaOperativa];
    deudaOperativaListSearch = deudaOperativa
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
    deudaOperativaListSearch2 = [...deudaOperativaListSearch];
    deudaOperativaListSearch2.sort((b, a) =>
        int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));
    deudaOperativaPersonSearch = [...deudaOperativaPerson];
    deudaOperativaPersonSearch = deudaOperativaPerson
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  busquedaEspecifica(String e4e, String funcional) {
    deudaOperativaListSearch = [...deudaOperativa];
    deudaOperativaListSearch = deudaOperativa
        .where((e) => e.e4e == e4e && e.funcional == funcional)
        .toList();
  }

  crear({
    required Mm60 mm60,
    required Mb51 mb51,
    required Planillas planillas,
    required Lcl lcl,
    required Mb52 mb52,
  }) {
    // var registros = registros.registrosOperativos;
    // print('registros: ${registros}');
    // print('registros: ${registros.porLCL}');
    var porLCL = planillas.porLCL;
    // print('From Deuda OP before legporLCL');
    var mb51Reg = mb51.porLCL;
    // print('porLCL: ${porLCL}');
    for (var planilla in porLCL) {

      int totalMB52 = mb52.mb52List
          .where((e) => e.material == planilla['e4e'])
          .map((e) => aEntero(e.ctd))
          .fold(0, (p, a) => p + a)
          .toInt();
      // print('From deuda op registro: $registro');
      var mm60Single = mm60.mm60List.firstWhere(
        (e) => e.material == planilla['e4e'].toString(),
        orElse: () => Mm60Single.fromInit(),
      );
      var valorUnitario = int.parse(mm60Single.precio);
      var cantidadSap = mb51Reg.firstWhere(
        (e) => e['lcl'] == planilla['lcl'] && e['e4e'] == planilla['e4e'],
        orElse: () => {'ctd': 0},
      )['ctd'];
      var faltanteUnidades = int.parse(planilla['ctd_total'].toString()) +
          int.parse(cantidadSap.toString());
      var funcional = planillas.registrosList
          .firstWhere((e) => e.lcl == planilla['lcl'])
          .ingeniero_enel;

      if (int.parse(planilla['ctd_total'].toString()) != 0 &&
          planilla['estado'] != "sapenconfirmacion" &&
          planilla['estado'] != "confirmado") {
        int totalE4eLCL = porLCL
            .where((e) =>
                e['lcl'] == planilla['lcl'] &&
                e['e4e'] == planilla['e4e'] 
                // &&
                // e['estado'] != "sapenconfirmacion" &&
                // e['estado'] != "confirmado"
                )
            .map((e) => e['ctd_total'])
            .fold(0, (p, a) => p + a as int)
            .toInt();

        //para prevenir el caso en que una LCL se ha consumido parcialmente
        int correccionSap = totalE4eLCL + cantidadSap as int;
        if (correccionSap > 0) correccionSap = 0;

        faltanteUnidades = int.parse(planilla['ctd_total'].toString()) +
            int.parse(correccionSap.toString());

        deudaOperativa.add(
          DeudaOperativaSingle(
            lcl: planilla['lcl'],
            destino: "",
            funcional: funcional.toString(),
            operativo: "",
            e4e: planilla['e4e'].toString(),
            descripcion: mm60Single.descripcion,
            um: planilla['um'],
            ctd_total: planilla['ctd_total'].toString(),
            ctd_con: correccionSap.toString(),
            faltanteUnidades: faltanteUnidades.toString(),
            // faltanteUnidades: '0',
            faltanteValor: (faltanteUnidades * valorUnitario).toString(),
            mb52: totalMB52.toString(),
          ),
        );
      } else {
        deudaOperativa.add(
          DeudaOperativaSingle(
            lcl: planilla['lcl'],
            destino: "",
            funcional: funcional.toString(),
            operativo: "",
            e4e: planilla['e4e'].toString(),
            descripcion: mm60Single.descripcion,
            um: planilla['um'],
            ctd_total: planilla['ctd_total'].toString(),
            ctd_con: planilla['ctd_total'].toString(),
            faltanteUnidades: '0',
            // faltanteUnidades: '0',
            faltanteValor: '0',
            mb52: totalMB52.toString(),
          ),
        );
      }
      // print(deudaOperativa.last);
    }
    total();

    for (var reg in deudaOperativa) {
      reg.funcional = lcl.lclList
          .firstWhere((e) => e.lcl == reg.lcl,
              orElse: () => LclSingle.fromUser("*${reg.funcional}"))
          .usuario
          .toUpperCase();
      reg.destino =
          planillas.registrosList.firstWhere((e) => e.lcl == reg.lcl).destino;
      reg.operativo = planillas.registrosList
          .firstWhere((e) => e.lcl == reg.lcl && e.destino == reg.destino)
          .ingeniero_enel
          .toUpperCase();
    }
    deudaOperativa.sort((a, b) =>
        int.parse('${b.lcl}${a.e4e}').compareTo(int.parse('${a.lcl}${b.e4e}')));
    deudaOperativaListSearch = [...deudaOperativa];
    deudaOperativaListSearch2 = [...deudaOperativa];
    deudaOperativaListSearch2.sort((b, a) =>
        int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));

    var porFuncional = deudaOperativa
        // .where((e) => int.parse(e.faltanteUnidades) > 0)
        .map((e) => {
              ...e.toMap(),
              ...{
                'sal': int.parse(e.ctd_total),
                'sap': int.parse(e.ctd_con),
                'fal': int.parse(e.faltanteUnidades),
                'valor': int.parse(e.faltanteValor),
              }
            })
        .toList();
    // print(deudaActiva);
    var keysToSelect = ['funcional', 'e4e', 'descripcion', 'um'];
    var keysToSum = ['sal', 'sap', 'fal', 'valor'];
    var registrosCalc = groupByList(porFuncional, keysToSelect, keysToSum);
    // print('registrosCalc: ${registrosCalc.length}');
    for (var reg in registrosCalc) {
      int totalMB52 = mb52.mb52List
          .where((e) => e.material == reg['e4e'])
          .map((e) => aEntero(e.ctd))
          .fold(0, (p, a) => p + a)
          .toInt();
      deudaOperativaPerson.add(
        DeudaOperativaSingle(
          funcional: reg['funcional'],
          operativo: "",
          lcl: '',
          destino: '',
          e4e: reg['e4e'],
          descripcion: reg['descripcion'],
          um: reg['um'],
          ctd_total: reg['sal'].toString(),
          ctd_con: reg['sap'].toString(),
          faltanteUnidades: reg['fal'].toString(),
          faltanteValor: reg['valor'].toString(),
          mb52: totalMB52.toString(),
        ),
      );
      // print(deudaActivaList.last);
    }
    deudaOperativaPerson.sort(
        (a, b) => '${b.funcional}${a.e4e}'.compareTo('${a.funcional}${b.e4e}'));
    deudaOperativaPersonSearch = [...deudaOperativaPerson];

    // var regPorFuncional = registrosCalc.porFuncional;
    // var legPorFuncional = mb51.porFuncional;
    // // print('porLCL: ${legPorLCL.length}');
    // for (var registro in regPorFuncional) {
    //   var mm60Single = mm60.mm60List.firstWhere(
    //     (e) => e.material == registro['e4e'].toString(),
    //     orElse: () => Mm60Single.fromInit(),
    //   );
    //   var valorUnitario = int.parse(mm60Single.precio);
    //   var cantidadSap = legPorFuncional.firstWhere(
    //     (e) =>
    //         e['ingeniero_enel'].toString().toLowerCase() ==
    //             registro['ingeniero_enel'].toString().toLowerCase() &&
    //         e['e4e'] == registro['e4e'],
    //     orElse: () => {'ctd': 0},
    //   )['ctd'];
    //   var faltanteUnidades = int.parse(registro['ctd_total'].toString()) +
    //       int.parse(cantidadSap.toString());
    //   var funcional = registro['ingeniero_enel'];

    //   if (int.parse(registro['ctd_total'].toString()) != 0) {
    //     deudaOperativaPerson.add(DeudaOperativaSingle(
    //       lcl: registro['ingeniero_enel'],
    //       funcional: funcional.toString(),
    //       e4e: registro['e4e'].toString(),
    //       descripcion: registro['descripcion'],
    //       um: registro['um'],
    //       ctd_total: registro['ctd_total'].toString(),
    //       ctd_con: cantidadSap.toString(),
    //       faltanteUnidades: faltanteUnidades.toString(),
    //       // faltanteUnidades: '0',
    //       faltanteValor: (faltanteUnidades * valorUnitario).toString(),
    //     ));
    //   }
    //   // print(deudaOperativa.last);
    // }
    // deudaOperativaPersonSearch = [...deudaOperativaPerson];
    return deudaOperativa;
  }

  void total() {
    totalValor = 0;
    for (var deuda in deudaOperativa) {
      int valor = int.parse(deuda.faltanteValor);
      totalValor += valor;
      if (valor < 0) totalSobrantes += valor;
      if (valor > 0) totalFaltantes += valor;
    }
  }

  List<DeudaActiva> get registrosOperativos {
    List<DeudaActiva> deudaActivaList = [];
    var deudaActiva = deudaOperativa
        .where((e) => int.parse(e.faltanteUnidades) > 0)
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd': int.parse(e.faltanteUnidades),
              }
            })
        .toList();
    // print(deudaActiva);
    var keysToSelect = ['e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd'];
    var registros = groupByList(deudaActiva, keysToSelect, keysToSum);
    registros.sort(
        (a, b) => int.parse('${a['e4e']}').compareTo(int.parse('${b['e4e']}')));
    for (var reg in registros) {
      deudaActivaList.add(DeudaActiva(
        ctd: reg['ctd'].toString(),
        e4e: reg['e4e'],
        descripcion: reg['descripcion'],
        um: reg['um'],
      ));
      // print(deudaActivaList.last);
    }

    return deudaActivaList;
  }

  //Agrupar y summar los registros ingresados
  List<Map<String, dynamic>> groupByList(
    List<Map<String, dynamic>> data,
    List<String> keysToSelect,
    List<String> keysToSum,
  ) {
    List<Map<String, dynamic>> dataKeyAsJson = data.map((e) {
      e['asJson'] = {};
      for (var key in keysToSelect) {
        e['asJson'].addAll({key: e[key]});
        e.remove(key);
      }
      e['asJson'] = jsonEncode(e['asJson']);
      return e;
    }).toList();
    // print('dataKeyAsJson = $dataKeyAsJson');

    Map<dynamic, Map<String, int>> groupAsMap =
        groupBy(dataKeyAsJson, (Map e) => e['asJson'])
            .map((key, value) => MapEntry(key, {
                  for (var keySum in keysToSum)
                    keySum: value.fold<int>(0, (p, a) => p + (a[keySum] as int))
                }));

    List<Map<String, dynamic>> result = groupAsMap.entries.map((e) {
      Map<String, dynamic> newMap = jsonDecode(e.key);
      return {...newMap, ...e.value};
    }).toList();
    // print('result = $result');

    return result;
  }

  @override
  String toString() =>
      'DeudaOperativa(deudaOperativa=[]: $deudaOperativa=[], totalValor=0: $totalValor=0)';
}

class DeudaActiva {
  String e4e;
  String descripcion;
  String um;
  String ctd;
  DeudaActiva({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
  });

  DeudaActiva copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd,
  }) {
    return DeudaActiva(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd: ctd ?? this.ctd,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
    };
  }

  factory DeudaActiva.fromMap(Map<String, dynamic> map) {
    return DeudaActiva(
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd: map['ctd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaActiva.fromJson(String source) =>
      DeudaActiva.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaActiva(e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaActiva &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd == ctd;
  }

  @override
  int get hashCode {
    return e4e.hashCode ^ descripcion.hashCode ^ um.hashCode ^ ctd.hashCode;
  }
}

class DeudaOperativaSingle {
  String lcl;
  String destino;
  String funcional;
  String operativo;
  String e4e;
  String descripcion;
  String um;
  String ctd_total;
  String ctd_con;
  String faltanteUnidades;
  String faltanteValor;
  String mb52;
  DeudaOperativaSingle({
    required this.lcl,
    required this.destino,
    required this.funcional,
    required this.operativo,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_total,
    required this.ctd_con,
    required this.faltanteUnidades,
    required this.faltanteValor,
    required this.mb52,
  });

  List<String> toList() => [
        lcl,
        destino,
        funcional,
        operativo,
        e4e,
        descripcion,
        um,
        ctd_total,
        ctd_con,
        faltanteUnidades,
        faltanteValor,
        mb52,
      ];

  DeudaOperativaSingle copyWith({
    String? lcl,
    String? destino,
    String? funcional,
    String? operativo,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd_total,
    String? ctd_con,
    String? faltanteUnidades,
    String? faltanteValor,
    String? mb52,
  }) {
    return DeudaOperativaSingle(
      lcl: lcl ?? this.lcl,
      destino: destino ?? this.destino,
      funcional: funcional ?? this.funcional,
      operativo: operativo ?? this.operativo,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd_total: ctd_total ?? this.ctd_total,
      ctd_con: ctd_con ?? this.ctd_con,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
      mb52: mb52 ?? this.mb52,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lcl': lcl,
      'destino': destino,
      'funcional': funcional,
      'operativo': operativo,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_total': ctd_total,
      'ctd_con': ctd_con,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
      'mb52': mb52,
    };
  }

  factory DeudaOperativaSingle.fromMap(Map<String, dynamic> map) {
    return DeudaOperativaSingle(
      lcl: map['lcl'] ?? '',
      destino: map['destino'] ?? '',
      funcional: map['funcional'] ?? '',
      operativo: map['operativo'] ?? '',
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd_total: map['ctd_total'] ?? '',
      ctd_con: map['ctd_con'] ?? '',
      faltanteUnidades: map['faltanteUnidades'] ?? '',
      faltanteValor: map['faltanteValor'] ?? '',
      mb52: map['mb52'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaOperativaSingle.fromJson(String source) =>
      DeudaOperativaSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaOperativaSingle(lcl: $lcl, destino $destino, funcional: $funcional, e4e: $e4e, descripcion: $descripcion, um: $um, ctd_total: $ctd_total, ctd_con: $ctd_con, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaOperativaSingle &&
        other.lcl == lcl &&
        other.funcional == funcional &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd_total == ctd_total &&
        other.ctd_con == ctd_con &&
        other.faltanteUnidades == faltanteUnidades &&
        other.faltanteValor == faltanteValor;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
        funcional.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd_total.hashCode ^
        ctd_con.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }
}
