import 'package:firebase_auth/firebase_auth.dart';
import 'package:samat2co/usuarios/usuarios_model.dart';

class Version {
  static String data = "Versión 5.6 Actualización de Paquetes, upgrade a módulo LCLs";
  static String status(String page, String clase) {
    clase = clase.substring(clase.indexOf(":") + 1, clase.length);
    return "Conectado como: ${FirebaseAuth.instance.currentUser?.email ?? "Error"}, Fecha y hora: ${DateTime.now().toString().substring(0, 16)}, Página actual: $page($clase)";
  }
  static String user = FirebaseAuth.instance.currentUser?.email ?? "Error";
  static String pdi (){
    String correo = FirebaseAuth.instance.currentUser?.email ?? "Error";
    String pdiEncontrado = Usuarios().usuariosList.firstWhere((e) => e.correo == correo, orElse: () => UsuariosSingle.fromZero(),).pdi;
    return pdiEncontrado;
  } 
}

//initialization
Version version = Version();
