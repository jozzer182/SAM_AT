import 'package:samat2co/bloc/main_bloc.dart';

onNewMessage(event, emit, state) {
  emit(state.copyWith(
    message: event.message,
    messageCounter:
        event.typeMessage == TypeMessage.error ? 0 : state.messageCounter + 1,
    errorCounter:
        event.typeMessage == TypeMessage.error ? state.errorCounter + 1 : 0,
    messageColor: event.color,
  ));
}