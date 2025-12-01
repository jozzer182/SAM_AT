import 'dart:convert';

import 'package:http/http.dart' as http;

import '../resources/constants/apis.dart';


class People {
  List<PeopleSingle> people = [];
  
  Future<List<PeopleSingle>> obtener() async {
    var dataSend = {
      'dataReq': {'hoja': 'people'},
      'fname': "getMainData"
    };
    final response = await http.post(
      Uri.parse(
          Api.sam),
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
      people.add(PeopleSingle.fromMap(item));
    }
    // remove duplicates
    // people = people.toSet().toList();

    return people;
  }

  @override
  String toString() => 'People(people: $people)';
}


class PeopleSingle {
  String name;
  String email;
  String mobilePhone;
  PeopleSingle({
    required this.name,
    required this.email,
    required this.mobilePhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobilePhone': mobilePhone,
    };
  }

  factory PeopleSingle.fromMap(Map<String, dynamic> map) {
    return PeopleSingle(
      name: map['name'].toString(),
      email: map['email'].toString(),
      mobilePhone: map['mobilePhone'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PeopleSingle.fromJson(String source) => PeopleSingle.fromMap(json.decode(source));

  List<String> toList(){
    return [name,	email,	mobilePhone];
  }


  @override
  String toString() => 'PeopleSingle(name: $name, email: $email, mobilePhone: $mobilePhone)';
}
