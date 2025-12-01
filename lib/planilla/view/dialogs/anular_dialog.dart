import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';

class AnularDialog extends StatefulWidget {
  const AnularDialog({super.key});

  @override
  State<AnularDialog> createState() => _AnularDialogState();
}

class _AnularDialogState extends State<AnularDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Anular registro'),
      content: const Text('¿Está seguro de anular el registro?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            context.read<MainBloc>().add(
                  ChangePlanilla(
                    index: 0,
                    tabla: "planilla",
                    campo: CampoPlanilla.estadoreg_r,
                    valor: 'anulado',
                  ),
                );
            await Future.delayed(const Duration(milliseconds: 200));
            BlocProvider.of<MainBloc>(context).add(
              ValidarPlanilla(
                esNuevo: false,
                context: context,
              ),
            );
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('Anular'),
        ),
      ],
    );
  }
}
