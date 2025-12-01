import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samat2co/bloc/main_bloc.dart';
import 'package:samat2co/mm60/mm60_model.dart';

import 'package:samat2co/remisiones/remision/model/remision_cabecera_model.dart';
import 'package:samat2co/remisiones/remision/model/remision_registro_model.dart';
import 'package:samat2co/remisiones/remision/view/remision_buttons.dart';
import 'package:samat2co/remisiones/remision/view/remision_fields_v1.dart';

import '../../../version.dart';
import '../model/remision_enum.dart';

class RemisionPage extends StatefulWidget {
  final bool esNuevo;
  const RemisionPage({
    required this.esNuevo,
    super.key,
  });

  @override
  State<RemisionPage> createState() => _RemisionPageState();
}

class _RemisionPageState extends State<RemisionPage> {
  TextEditingController rowsController = TextEditingController();
  bool editAllFields = false;

  @override
  void initState() {
    if (widget.esNuevo) {
      BlocProvider.of<MainBloc>(context).add(
        NewRemision(),
      );
      editAllFields = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REMISION'),
        actions: [
          Builder(builder: (context) {
            if (widget.esNuevo) {
              return const SizedBox();
            }
            return ElevatedButton(
              onPressed: () {
                BlocProvider.of<MainBloc>(context).add(
                  AnularRemision(context: context),
                );
              },
              child: const Text('Anular Remisión'),
            );
          }),
          const SizedBox(width: 10),
          Builder(builder: (context) {
            if (widget.esNuevo) {
              return const SizedBox();
            }
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  editAllFields = !editAllFields;
                });
              },
              child: Text(editAllFields ? 'Editar todo' : 'Editar campos'),
            );
          }),
          const SizedBox(width: 10),
          Builder(builder: (context) {
            if (!editAllFields) {
              return const SizedBox();
            }
            return ElevatedButton(
              onPressed: () {
                if (widget.esNuevo) {
                  BlocProvider.of<MainBloc>(context).add(
                    SaveRemision(context: context),
                  );
                } else {
                  BlocProvider.of<MainBloc>(context).add(
                    UpdateRemision(context: context),
                  );
                }
                //salir de la pagina
                // Navigator.pop(context);
              },
              child: const Text('Guardar'),
            );
          }),
          const SizedBox(width: 10),
        ],
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
      body: SingleChildScrollView(
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state.remision == null) {
              return const SizedBox();
            }
            RemisionCabecera data = state.remision!.cabecera;
            List<RemisionRegistro> registros = state.remision?.registros ?? [];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  RowSized(
                    children: [
                      FieldPre(
                        tipoCampo: TipoCampo.desplegable,
                        flex: 3,
                        initialValue: data.tipo,
                        campo: CampoRemision.tipo,
                        label: 'Tipo Movimiento',
                        color: data.tipoColor,
                        edit: editAllFields,
                        opciones: const ["ingreso", "traslado (salida)"],
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RowSized(
                    children: [
                      FieldPre(
                        tipoCampo: TipoCampo.fecha,
                        flex: 3,
                        initialValue: data.fecha_i,
                        campo: CampoRemision.fecha_i,
                        label: 'Fecha Movimiento',
                        color: data.fecha_iColor,
                        edit: editAllFields,
                        // opciones: lcl.map((e) => e.lcl.trim().toLowerCase()),
                      ),
                      const SizedBox(width: 8),
                      FieldPre(
                        tipoCampo: TipoCampo.texto,
                        flex: 3,
                        initialValue: data.codigo_massy,
                        campo: CampoRemision.codigo_massy,
                        label: 'Código Massy ó TR',
                        color: data.codigo_massyColor,
                        edit: editAllFields,
                        // opciones: lcl.map((e) => e.lcl.trim().toLowerCase()),
                      ),
                      const SizedBox(width: 8),
                      FieldPre(
                        tipoCampo: TipoCampo.file,
                        flex: 3,
                        initialValue: data.soporte_i,
                        campo: CampoRemision.soporte_i,
                        label: 'Soporte de entrega',
                        color: data.soporte_iColor,
                        edit: editAllFields,
                        // opciones: lcl.map((e) => e.lcl.trim().toLowerCase()),
                      ),
                      const SizedBox(width: 8),
                      FieldPre(
                        tipoCampo: TipoCampo.texto,
                        flex: 3,
                        initialValue: data.comentario_i,
                        campo: CampoRemision.comentario_i,
                        label: 'Comentario',
                        color: Colors.grey,
                        edit: editAllFields,
                        // opciones: lcl.map((e) => e.lcl.trim().toLowerCase()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ButtonControlRows(
                    rowsController: rowsController,
                    edit: editAllFields,
                  ),
                  const SizedBox(height: 10),
                  const Title(),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      return RowRemision(
                        index: index,
                        data: registros[index],
                        editAllFields: editAllFields,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 1,
          child: Text('Item'),
        ),
        Expanded(
          flex: 2,
          child: Text('e4e'),
        ),
        Expanded(
          flex: 4,
          child: Text('Descripción'),
        ),
        Expanded(
          flex: 1,
          child: Text('Um'),
        ),
        Expanded(
          flex: 2,
          child: Text('Ctd'),
        ),
      ],
    );
  }
}

class RowRemision extends StatelessWidget {
  final int index;
  final RemisionRegistro data;
  final TextEditingController ctdController = TextEditingController();
  final bool editAllFields;
  RowRemision({
    required this.index,
    required this.data,
    required this.editAllFields,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!editAllFields) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(data.item),
          ),
          Expanded(
            flex: 2,
            child: Text(data.e4e),
          ),
          Expanded(
            flex: 4,
            child: Text(data.descripcion),
          ),
          Expanded(
            flex: 1,
            child: Text(data.um),
          ),
          Expanded(
            flex: 2,
            child: Text('${data.ctd}'),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 40,
        child: Row(
          // key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.item),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Autocomplete<Mm60Single>(
                // initialValue: e4eInit,
                displayStringForOption: (option) {
                  return option.material;
                },
                optionsBuilder: (textEditingValue) {
                  return context.read<MainBloc>().state.mm60!.mm60List.where(
                      (e) => e.material
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Material(
                    child: SizedBox(
                      width: 300,
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, i) {
                          Mm60Single option = options.toList()[i];
                          String textOption =
                              '${option.material} - ${option.descripcion}';
                          return ListTile(
                            title: Text(textOption,
                                style: const TextStyle(fontSize: 14)),
                            onTap: () {
                              onSelected(options.toList()[i]);
                              context.read<MainBloc>().add(
                                    ChangeRemision(
                                      index: index,
                                      campo: CampoRemision.e4e,
                                      valor: options.toList()[i].material,
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  // if (e4eInit.text.isNotEmpty && e4eInit.text.length == 6) {
                  // textEditingController.text = e4eInit.text;

                  textEditingController.value =
                      textEditingController.value.copyWith(
                    text: data.e4e,
                    selection: TextSelection.collapsed(offset: data.e4e.length),
                  );
                  // }
                  return TextFormField(
                    controller:
                        textEditingController, // Required by autocomplete
                    focusNode: focusNode, // Required by autocomplete
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'E4E',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: data.e4eColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: data.e4eColor, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<MainBloc>().add(
                            ChangeRemision(
                              index: index,
                              campo: CampoRemision.e4e,
                              valor: value,
                            ),
                          );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                data.descripcion,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                data.um,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            // Text('UMB'),
            Expanded(
              flex: 2,
              child: Builder(builder: (context) {
                ctdController.value = ctdController.value.copyWith(
                  text: data.ctd.toString(),
                  selection: TextSelection.collapsed(
                      offset: data.ctd.toString().length),
                );
                return TextFormField(
                  controller: ctdController,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Ctd',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.ctdColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.ctdColor, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<MainBloc>().add(
                          ChangeRemision(
                            index: index,
                            campo: CampoRemision.ctd,
                            valor: value,
                          ),
                        );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class RowSized extends StatelessWidget {
  final List<Widget> children;
  const RowSized({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: children,
      ),
    );
  }
}
