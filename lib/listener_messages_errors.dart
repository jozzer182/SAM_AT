import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/main_bloc.dart';

// ignore: non_constant_identifier_names
class ListenerCustom extends StatelessWidget {
  final Widget child;
  const ListenerCustom({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listenWhen: (previous, current) =>
          previous.errorCounter != current.errorCounter,
      listener: (context, state) {
        print(state.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: state.messageColor,
            content: Text(state.message),
          ),
        );
      },
      child: BlocListener<MainBloc, MainState>(
        listenWhen: (previous, current) =>
            previous.messageCounter != current.messageCounter,
        listener: (context, state) {
          print(state.dialogMessage);
          if (state.dialogMessage.isNotEmpty) {
            showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  title: const Text('Atención'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.dialogMessage),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }),
            );
          }
        },
        child: child,
      ),
    );
  }
}
