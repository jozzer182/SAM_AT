import 'onlycsv.dart';

class DescargaHojas {
  DateTime date = DateTime.now();
  Future<List<List<String>>> ahora(
      {required List datos, required String nombre}) async {
    List<String> keys = datos[0].toMap().keys.toList();
    List<List<String>> datosParaDescarga = [];
    datosParaDescarga.add(keys);
    for (var row in datos) {
      datosParaDescarga.add(row.toList());
    }
    // print('datosParaDescarga: $datosParaDescarga');
    await SaveAsCsv().saveCSV(
        dataValue: datosParaDescarga,
        fileName:
            '$nombre al ${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}');
    return datosParaDescarga;
  }
}

//initialization 
DescargaHojas descarga = DescargaHojas();
