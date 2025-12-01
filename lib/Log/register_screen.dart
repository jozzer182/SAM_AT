import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../resources/constants/apis.dart';
import 'auth_services.dart';
import 'package:http/http.dart' as http;
// import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController telController = TextEditingController();
  String? selectedItemPerfil = 'funcional';

  AuthService authService = AuthService();
  bool loading = false;
  String? errorMail;
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro Enel')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ColumnData(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> ColumnData() {
    return [
      Text(
        'Favor indique su correo corporativo "@enel.com" y una contraseña para acceder al aplicativo, no se sincronizará con la contraseña de red.',
        maxLines: 5,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 30.0),
      TextField(
        controller: nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Nombre - Apellido',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
      ),
      SizedBox(height: 30.0),
      TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: telController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: 'Telefono',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
      ),
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
      DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_person),
          labelText: 'Perfil',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        items: const [
          DropdownMenuItem(
            child: Text('Funcional'),
            value: 'funcional',
          ),
          DropdownMenuItem(
            child: Text('Contract Management'),
            value: 'contract',
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
          if (emailController.text == "" ||
              passwordController.text == "" ||
              nameController.text == "" ||
              telController.text == "") {
            errorMail = 'Se requieren los datos completos';
            // Get.snackbar('Atención', 'Se requieren los datos completos');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Por favor revise los campos, se requieren todos diligenciados'),
              backgroundColor: Colors.red,
            ));
          } else if (!emailController.text.contains('@enel')) {
            errorMail =
                'Este registro es válido solo para usuarios con correo @enel.com';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Este registro es válido solo para usuarios con correo @enel.com'),
              backgroundColor: Colors.red,
            ));
          } else {
            User? result = await authService.register(
              email: emailController.text,
              password: passwordController.text,
              nombre: nameController.text,
              telefono: telController.text,
              empresa: 'Enel',
              perfil: selectedItemPerfil ?? '',
              context: context,
            );
            if (result != null) {
              // print('Succes for email ${result.email}');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Se registro correctamente'),
                  backgroundColor: Colors.green));
              await result.updateDisplayName(nameController.text);
              await FirebaseAuth.instance.currentUser!
                  .sendEmailVerification()
                  .onError((error, stackTrace) {
                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                    backgroundColor: Colors.red));
              }).whenComplete(
                () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Se ha enviado el correo correctamente, por favor revise en su bandeja de SPAM'),
                    backgroundColor: Colors.green)),
              );
              var dataSend = {
                'info': {
                  "libro": "USUARIOS",
                  "hoja": "hoja",
                  'map': {
                    'correo': emailController.text,
                    'perfil': selectedItemPerfil ?? '',
                    'pdi': 'DE20222402',
                    'telefono': telController.text,
                    'empresa': 'ENEL',
                    'nombrecorto': 'ENEL',
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

              Navigator.pop(context);
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
