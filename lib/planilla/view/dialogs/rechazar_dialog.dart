import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/planilla/model/cabecera_model.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';
import 'package:samat2co/user/user_model.dart';

class RechazarDialog extends StatefulWidget {
  const RechazarDialog({super.key});

  @override
  State<RechazarDialog> createState() => _RechazarDialogState();
}

class _RechazarDialogState extends State<RechazarDialog> {
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _motivoController = TextEditingController();
  bool _isTokenValid = false;
  bool _sendEmail = false;

  verificarToken(String token, String fecha, String correo, String pdi) {
    String tokenCorrecto = md5
        .convert(utf8.encode('$fecha - $correo - $pdi'))
        .toString(); // Convierte el hash en una cadena hexadecimal
    // print('Token correcto: $tokenCorrecto');
    if (token == tokenCorrecto) {
      setState(() {
        _isTokenValid = true;
      });
    } else {
      setState(() {
        _isTokenValid = false;
      });
    }
  }

  @override
  void initState() {
    _motivoController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        Cabecera cabecera = state.planilla!.cabecera;
        User user = state.user!;
        return AlertDialog(
          title: const Text('Rechazar registro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  'Para proceder con el rechazo, debe informar el token de seguridad, este lo puede conseguir con el almacenista que ha creado el registro:'),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Almacenista: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  TextSpan(
                    text: cabecera.almacenista_e,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Contacto: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  TextSpan(
                    text: cabecera.tel_alm_e,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tokenController,
                onChanged: (value) {
                  String fecha = DateTime.now().toString().substring(0, 10);
                  String correo = user.correo;
                  String pdi = cabecera.pdi;
                  // print('$fecha - $correo - $pdi');
                  verificarToken(value, fecha, correo, pdi);
                },
                decoration: InputDecoration(
                  labelText: 'Token de seguridad',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isTokenValid ? primary : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isTokenValid ? primary : Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                  'Tambien informar el motivo del rechazo, para que se pueda corregir la información suministrada:'),
              const SizedBox(height: 10),
              TextField(
                controller: _motivoController,
                decoration: InputDecoration(
                  labelText: 'Motivo del rechazo',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          _motivoController.text.isEmpty ? Colors.red : primary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          _motivoController.text.isEmpty ? Colors.red : primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _sendEmail,
                    onChanged: (value) {
                      setState(() {
                        _sendEmail = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    '¿Desea enviar una confirmación por correo electrónico?',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: !_isTokenValid
                  ? null
                  : () async {
                      context.read<MainBloc>().add(
                            ChangePlanilla(
                              index: 0,
                              tabla: 'planilla',
                              campo: CampoPlanilla.estadoreg_r,
                              valor: 'calidad',
                            ),
                          );
                      await Future.delayed(const Duration(milliseconds: 20));
                      context.read<MainBloc>().add(
                            ChangePlanilla(
                              index: 0,
                              tabla: 'planilla',
                              campo: CampoPlanilla.comentario,
                              valor: _motivoController.text,
                            ),
                          );
                      await Future.delayed(const Duration(milliseconds: 200));
                      BlocProvider.of<MainBloc>(context).add(
                        ValidarPlanilla(
                          esNuevo: false,
                          context: context,
                          sendEmail: _sendEmail,
                        ),
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
              child: const Text('Rechazar'),
            ),
          ],
        );
      },
    );
  }
}
