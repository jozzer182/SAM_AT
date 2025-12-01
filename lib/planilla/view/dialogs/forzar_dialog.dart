import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/planilla/model/planilla_enum.dart';

class ForzarErrorDialog extends StatefulWidget {
  const ForzarErrorDialog({super.key});

  @override
  State<ForzarErrorDialog> createState() => _ForzarErrorDialogState();
}

class _ForzarErrorDialogState extends State<ForzarErrorDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return AlertDialog(
        title: const Text('Forzar registro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Está seguro de forzar el registro?'),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Motivo',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _controller.text.isEmpty ? Colors.red : primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _controller.text.isEmpty ? Colors.red : primary,
                  ),
                ),
              ),
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
            onPressed: _controller.text.isEmpty
                ? null
                : () async {
                    context.read<MainBloc>().add(
                          ChangePlanilla(
                            index: 0,
                            tabla: "planilla",
                            campo: CampoPlanilla.comentario_sap,
                            valor: _controller.text,
                          ),
                        );
                    await Future.delayed(const Duration(milliseconds: 50));
                    context.read<MainBloc>().add(
                          ChangePlanilla(
                            index: 0,
                            tabla: "planilla",
                            campo: CampoPlanilla.estadoreg_sap,
                            valor: 'saperror',
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
            child: const Text('Forzar'),
          ),
        ]);
  }
}
