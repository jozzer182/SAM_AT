import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Stream<User?> stateLogin = FirebaseAuth.instance.authStateChanges();
  String? errorCall;
  String? errorPassworReset;
  final translator = GoogleTranslator();

  Future<User?> login(
      String email, String password, BuildContext context) async {
    errorCall = null;
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      var translation =
          await translator.translate(e.message.toString(), to: 'es');
      // Get.snackbar('Atención', translation.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(translation.toString()),
                  backgroundColor: Colors.orange));
      errorCall = translation.toString();
    } catch (e) {
      // print(e);
    }
    return null;
  }

  Future<User?> register({
    required String email,
    required String password,
    required String nombre,
    required String telefono,
    required String empresa,
    required String perfil,
    required BuildContext context,
    String? pdi,
  }) async {
    errorCall = null;

    // UserCredential userCredential;
    return await firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      value.user!.updateDisplayName(nombre);
      const JsonEncoder encoder = JsonEncoder();
      final data = {
        'telefono': telefono,
        'empresa': empresa,
        'pdi': pdi ?? 'x',
        'perfil': perfil,
      };
      final String jsonString = encoder.convert(data);
      // print(jsonString);
      value.user!.updatePhotoURL(jsonString);
      return value.user;
    }).onError((FirebaseAuthException e, stackTrace) async {
      var translation =
          await translator.translate(e.message.toString(), to: 'es');
      // Get.snackbar('Atención', translation.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(translation.toString()),
                  backgroundColor: Colors.orange));
      errorCall = translation.toString();
      return null;
    });
  }

  // Future<void> updateUser(String pdi) async {
  //   const JsonEncoder encoder = JsonEncoder();
  //   final data = {
  //     'telefono': PersonData().telefono,
  //     'empresa': PersonData().empresa,
  //     'pdi': pdi,
  //     'perfil': PersonData().perfil,
  //   };
  //   final String jsonString = encoder.convert(data);
  //   FirebaseAuth.instance.currentUser!.updatePhotoURL(jsonString);
  // }

  // Future<void> passwordReset({required String email}) async {
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //   } on FirebaseAuthException catch (e) {
  //     var translation =
  //         await translator.translate(e.message.toString(), to: 'es');
  //     errorPassworReset = translation.toString();
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  Future<void> singOut() async {
    await firebaseAuth.signOut();
  }
}
