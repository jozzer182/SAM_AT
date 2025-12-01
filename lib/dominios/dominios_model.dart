// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../resources/constants/apis.dart';

class Dominio{
  List<DominioSingle> dominioList = [];
  Future<List<DominioSingle>> obtener() async {
    dominioList.clear();
    var dataSend = {
      'info': {'libro': 'USUARIOS', 'hoja': 'dominios'},
      'fname': 'getHoja'
    };
    final response = await http.post(
      Uri.parse(
          Api.samat),
      body: jsonEncode(dataSend),
    );
    // print('response ${response.body}');
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    for (var item in dataAsListMap) {
      dominioList.add(DominioSingle.fromMap(item));
    }
    return dominioList;
  }
}

class DominioSingle {
  String dominio;
  DominioSingle({
    required this.dominio,
  });

  DominioSingle copyWith({
    String? dominio,
  }) {
    return DominioSingle(
      dominio: dominio ?? this.dominio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dominio': dominio,
    };
  }

  factory DominioSingle.fromMap(Map<String, dynamic> map) {
    return DominioSingle(
      dominio: map['dominio'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DominioSingle.fromJson(String source) => DominioSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DominioSingle(dominio: $dominio)';

  @override
  bool operator ==(covariant DominioSingle other) {
    if (identical(this, other)) return true;
  
    return 
      other.dominio == dominio;
  }

  @override
  int get hashCode => dominio.hashCode;
}
