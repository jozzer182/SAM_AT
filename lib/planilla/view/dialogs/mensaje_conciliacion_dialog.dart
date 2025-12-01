// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:samat2co/conciliaciones/model/conciliaciones_reg_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/file_uploader.dart';

class MensajeConciliacionDialog extends StatefulWidget {
  final bool esNuevo;
  const MensajeConciliacionDialog({
    required this.esNuevo,
    super.key,
  });

  @override
  State<MensajeConciliacionDialog> createState() =>
      _MensajeConciliacionDialogState();
}

class _MensajeConciliacionDialogState extends State<MensajeConciliacionDialog> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController para = TextEditingController();
  final TextEditingController fileUploadController = TextEditingController();
  List<String> opcionesTipo = [
    "",
    "Error Cantidad",
    "Error Código",
    "Error LCl",
    "Error Destino",
    "Otro Error"
  ];

  String tipo = "";
  // String para = "";

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    para.addListener(() {
      setState(() {});
    });
    bool esEnel = context
        .read<MainBloc>()
        .state
        .user!
        .correo
        .toLowerCase()
        .contains("enel.com");
    para.text = esEnel
        ? context.read<MainBloc>().state.planilla!.cabecera.almacenista_e
        : context.read<MainBloc>().state.planilla!.cabecera.ingeniero_enel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    final String emailPattern =
        r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$';
    final RegExp regex = RegExp(emailPattern);
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text(
            widget.esNuevo ? "INICIAR CONCILIACIÓN" : "Agregar Mensaje",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(state.user?.correo ?? "Error"),
                  const Gap(40),
                  Text(DateTime.now().toString().substring(0, 16)),
                ],
              ),
              const Gap(10),
              TextField(
                controller: para,
                decoration: InputDecoration(
                  labelText: 'Para',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: para.text.isEmpty || !regex.hasMatch(para.text)
                          ? Colors.red
                          : primary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: para.text.isEmpty || !regex.hasMatch(para.text)
                          ? Colors.red
                          : primary,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              widget.esNuevo
                  ? SizedBox(
                      height: 40,
                      child: DropdownButtonFormField(
                        // value: "Error Cantidad",
                        items: opcionesTipo
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: tipo.isEmpty ? Colors.red : primary,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (f) {
                          setState(() {
                            tipo = f.toString();
                          });
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
              const Gap(10),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _controller,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Mensaje',
                    border: const OutlineInputBorder(),
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
              ),
              const Gap(10),
              state.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 500,
                      child: TextField(
                        controller: fileUploadController,
                        readOnly: true,
                        onTap: () async {
                          context.read<MainBloc>().add(
                                Loading(isLoading: true),
                              );
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            var file = result.files.first;
                            fileUploadController.text =
                                await FileUploadToDrive.uploadAndGetUrl(
                              file: file,
                              carpeta: "informe",
                              pdi: state.user?.pdi ?? "",
                            );

                            context.read<MainBloc>().add(
                                  Loading(isLoading: false),
                                );
                          }
                          context.read<MainBloc>().add(
                                Loading(isLoading: false),
                              );
                        },
                        decoration: InputDecoration(
                          labelText: "Adjunto (Opcional)",
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              // borderSide: BorderSide(
                              //   color: color,
                              // ),
                              ),
                          focusedBorder: const OutlineInputBorder(
                              // borderSide: BorderSide(
                              //   color: color,
                              //   width: 2,
                              // ),
                              ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: fileUploadController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse(fileUploadController.text));
                                  },
                                  icon: const Icon(Icons.file_present),
                                ),
                        ),
                      ),
                    )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            state.isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: para.text.isEmpty ||
                            !regex.hasMatch(para.text) ||
                            _controller.text.isEmpty 
                        ? null
                        : () async {
                            ConciliacionesReg conciliacion = ConciliacionesReg(
                              id: 0,
                              planilla: state.planilla?.cabecera.pedido ?? "",
                              mensaje: _controller.text,
                              fecha: DateTime.now(),
                              tipo: tipo,
                              adjunto: fileUploadController.text,
                              persona: state.user?.correo ?? "Error",
                              estado: "OK",
                              para: para.text,
                              subestacion: state.planilla?.cabecera.destino
                                      .toUpperCase() ??
                                  "Error",
                            );
                            await BlocProvider.of<MainBloc>(context)
                                .conciliacionesController
                                .setConciliacion(conciliacion);

                            await BlocProvider.of<MainBloc>(context)
                                .conciliacionesController
                                .enviar;

                            // BlocProvider.of<MainBloc>(context).add(
                            //   ValidarPlanilla(
                            //     esNuevo: false,
                            //     context: context,
                            //     sendEmail: _sendEmail,
                            //   ),
                            // );
                            // Navigator.of(context).pop();
                            // Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                    child: const Text('Guardar'),
                  ),
          ],
        );
      },
    );
  }
}
