import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/dominios/dominios_model.dart';
import 'package:samat2co/pdi/pdi_model.dart';
import '../resources/constants/apis.dart';
import 'auth_services.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
// import 'home_screen.dart';

class RegisterOthers extends StatefulWidget {
  RegisterOthersState createState() => RegisterOthersState();
}

class RegisterOthersState extends State<RegisterOthers> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController pdiController = TextEditingController();
  String? nombrecorto;
  final translator = GoogleTranslator();
  String? empresaSeleccionada;
  Future<List<PdiSingle>?>? futurePdi;
  Future<List<DominioSingle>>? futureDomain;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    futurePdi = Pdi().obtener();
    futureDomain = Dominio().obtener();
    super.initState();
  }

  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  bool loading = false;
  String? errorMail;
  String? selectedItem = 'Item 1';
  String? selectedItemPerfil = 'almacen';

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro EECC')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 328,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ColumnData(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Cuerpo del formulario
  List<Widget> ColumnData() {
    return [
      Text(
        'Favor indique su correo corporativo y una contraseña para acceder al aplicativo.',
        maxLines: 5,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 30.0),
      TextFormField(
        controller: nameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Por favor ingrese un nombre y apellido';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Nombre - Apellido',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
      ),
      SizedBox(height: 30.0),
      TextFormField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: telController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: 'Telefono',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        validator: (value) {
          if (value != null && value.length < 10) {
            return 'Por favor ingrese un número válido (10 números)';
          } else {
            return null;
          }
        },
      ),
      SizedBox(height: 30.0),
      DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_person),
          labelText: 'Perfil',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        items: [
          DropdownMenuItem(
            child: Text('Almacén'),
            value: 'almacen',
          ),
          DropdownMenuItem(
            child: Text('Operación'),
            value: 'operacion',
          ),
          DropdownMenuItem(
            child: Text('Supervisores'),
            value: 'funcional',
          ),
        ],
        value: selectedItemPerfil,
        onChanged: (String? value) {
          setState(() {
            selectedItemPerfil = value;
          });
        },
      ),
      SizedBox(height: 30.0),
      desplegable(),
      SizedBox(height: 30.0),
      TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Correo',
          border: OutlineInputBorder(),
          errorText: authService.errorCall ?? errorMail,
          errorMaxLines: 2,
        ),
      ),
      SizedBox(height: 30.0),
      TextField(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Contraseña',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 30.0),
      ButtonLoginLoading(),
    ];
  }

  //Contruimos el future builder para traer los datos de PDI y nombre
  desplegable() {
    return FutureBuilder<List<PdiSingle>?>(
      future: futurePdi,
      builder: (context, AsyncSnapshot<List<PdiSingle>?> snapshot) {
        if (snapshot.data == null) return const CircularProgressIndicator();
        selectedItem = snapshot.data![0].empresa;
        return Column(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.factory),
                labelText: 'Empresa',
                border: OutlineInputBorder(),
                errorMaxLines: 2,
              ),
              items: items_dropdown(lista: snapshot.data),
              value: selectedItem,
              onChanged: (String? value) {
                setState(() {
                  selectedItem = value;
                  empresaSeleccionada = value;
                  final index = snapshot.data!
                      .indexWhere((element) => element.empresa == value);
                  // print(index);
                  // print(snapshot.data![index].pdi);
                  pdiController.text = snapshot.data![index].pdi;
                  nombrecorto = snapshot.data![index].nombrecorto;
                });
              },
            ),
            SizedBox(height: 30.0),
            TextField(
              enabled: false,
              controller: pdiController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.co_present_outlined),
                labelText: 'PDI',
                border: OutlineInputBorder(),
                errorMaxLines: 2,
              ),
            ),
          ],
        );
      },
    );
  }

  //Elementos de la lista desplegable, los dejo aparte por usar un MAP().tolist, se me hace mas organizado asi
  List<DropdownMenuItem<String>>? items_dropdown({List<PdiSingle>? lista}) {
    return lista!.map((e) {
      return DropdownMenuItem<String>(
        alignment: AlignmentDirectional.center,
        value: e.empresa,
        child: Container(
          width: 200,
          child: Text(e.empresa),
        ),
      );
    }).toList();
  }

  //Toda la funcion del boton de loading, en donde reviso que todo este acorde.
  Widget ButtonLoginLoading() {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return ElevatedButton(
        child: Text('Registrarse'),
        onPressed: () async {
          errorMail = null;
          setState(() {
            loading = true;
          });

          List<DominioSingle> dominios = await Dominio().obtener();

          if (emailController.text == "" ||
              passwordController.text == "" ||
              nameController.text == "" ||
              telController.text == "") {
            errorMail = 'Se requieren los datos completos';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Por favor revise los campos, se requieren todos diligenciados'),
              backgroundColor: Colors.red,
            ));
            // Get.snackbar('Atención', 'Se requieren los datos completos');
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('Se requieren los datos completos'),
            //   backgroundColor: Colors.red,
            // ));
            // } else if (!emailController.text.contains('@enel')) {
            //   errorMail =
            //       'Este registro es válido solo para usuarios con correo @enel.com';
          } else if (dominios.indexWhere(
                  (note) => emailController.text.contains(note.dominio)) !=
              -1) {
            // print('si esta contenido');
            // ignore: unused_local_variable
            String? emailrespuesta;
            try {
              emailrespuesta = await firebaseAuth
                  .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              )
                  .then((value) async {
                await value.user!
                    .updateDisplayName(nameController.text)
                    .then((value) async {
                  var dataSend = {
                    'info': {
                      "libro": "USUARIOS",
                      "hoja": "hoja",
                      'map': {
                        'correo': emailController.text,
                        'perfil': selectedItemPerfil ?? '',
                        'pdi': pdiController.text,
                        'telefono': telController.text,
                        'empresa': empresaSeleccionada ?? '',
                        'nombrecorto': nombrecorto ?? '',
                      }
                    },
                    'fname': 'addMap'
                  };
                  final response = await http.post(
                    Uri.parse(
                        Api.samat),
                    body: jsonEncode(dataSend),
                  );
                  // print('response ${response.body}');
                  var dataAsListMap;
                  if (response.statusCode == 302) {
                    var response2 = await http
                        .get(Uri.parse(response.headers["location"] ?? ''));
                    dataAsListMap = jsonDecode(response2.body);
                  } else {
                    dataAsListMap = jsonDecode(response.body);
                  }
                  print(dataAsListMap);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(dataAsListMap),
                      backgroundColor: Colors.green));
                  BlocProvider.of<MainBloc>(context).add(Load());
                  return null;
                });
                return value.user!.email;
              });
            } on FirebaseAuthException catch (e) {
              var translation =
                  await translator.translate(e.message.toString(), to: 'es');
              // Get.snackbar('Atención', translation.toString());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(translation.toString()),
                  backgroundColor: Colors.orange));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.orange,
              ));
            }

            try {
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Se ha enviado un correo de verificación, por favor revise su bandeja de entrada, de click en el enlace y vuelva a iniciar sesión.'),
                backgroundColor: Colors.orange,
              ));
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            } on Exception catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ));
            }
          }
          setState(() {
            loading = false;
          });
        },
      );
    }
  }
}
