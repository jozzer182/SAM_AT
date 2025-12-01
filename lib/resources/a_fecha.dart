import 'package:intl/intl.dart';

DateTime aFecha(String fecha) {
  if (fecha.contains("T")) {
    return DateTime.parse(fecha);
  }
  // Reemplazar el espacio no separable (NBSP) por un espacio normal
  try {
    fecha = fecha.replaceAll(String.fromCharCode(160), ' ');
    // Reemplazar "a. m." por "AM" y "p. m." por "PM"
    fecha = fecha.replaceAll('a. m.', 'AM').replaceAll('p. m.', 'PM');
    final DateFormat format = DateFormat("d/M/y, h:mm:ss a");
    return format.parse(fecha);
  } catch (e) {
    return DateTime(1990, 1, 1);
  }
}
