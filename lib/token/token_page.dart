import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/version.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({super.key});

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  TextEditingController _tokenController = TextEditingController();
  crearToken(String fecha, String correo, String pdi) {
    String tokenCorrecto = md5
        .convert(utf8.encode('$fecha - $correo - $pdi'))
        .toString(); // Convierte el hash en una cadena hexadecimal
    if (correo.isNotEmpty) {
      _tokenController.text = tokenCorrecto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GENERAR TOKEN'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? const LinearProgressIndicator() : const SizedBox();
            },
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Version.data,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              Version.status('Remisión', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Por favor informe el correo del usuario al que se le va a generar el token.'),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo',
                    hintText: 'Ingrese el correo del usuario',
                  ),
                  onChanged: (value) {
                    String fecha = DateTime.now().toString().substring(0, 10);
                    String pdi = state.user!.pdi;
                    crearToken(fecha, value, pdi);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Token',
                    hintText: 'Ingrese el correo del usuario para ver el token',
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Este token solo será válido por el día de hoy.'),
              ],
            ),
          );
        },
      ),
    );
  }
}
