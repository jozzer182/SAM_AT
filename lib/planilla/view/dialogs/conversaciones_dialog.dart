import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/conciliaciones/model/conciliaciones_reg_model.dart';

import 'messagebubble.dart';

class ConversacionesDialog extends StatefulWidget {
  const ConversacionesDialog({super.key});

  @override
  State<ConversacionesDialog> createState() => _ConversacionesDialogState();
}

class _ConversacionesDialogState extends State<ConversacionesDialog> {
  List<ConciliacionesReg> messages = [];

  @override
  void initState() {
    String planilla = context.read<MainBloc>().state.planilla!.cabecera.pedido;
    messages = context
        .read<MainBloc>()
        .state
        .conciliacionesList!
        .list
        .where((e) => e.planilla == planilla)
        .toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("MENSAJES"),
      content: Container(
        // Ajusta el ancho según tu necesidad.
        width: 400,
        // Ajusta la altura máxima para el scroll
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final mensaje = messages[index];
            return MessageBubble(
              message: mensaje.mensaje,
              sender: mensaje.persona,
              timestamp: mensaje.fecha,
              attachmentUrl: mensaje.adjunto,
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
