import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';

class GuardarDialog extends StatefulWidget {
  const GuardarDialog({
    super.key,
  });

  @override
  State<GuardarDialog> createState() => _GuardarDialogState();
}

class _GuardarDialogState extends State<GuardarDialog> {
  bool _sendEmail = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Guardar registro'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('¿Está seguro de guardar el registro?'),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _sendEmail,
                onChanged:  null , 
                //(value) {
                  //setState(() {
                    //_sendEmail = value ?? false;
                  //});
                //},
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
          onPressed: () async {
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
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
