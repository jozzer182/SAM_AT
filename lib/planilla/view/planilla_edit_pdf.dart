import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:samat2co/planilla/model/planilla_model.dart';
import 'package:samat2co/planilla/model/registro_model.dart';
import 'package:universal_html/html.dart' as html;

Future generatePdf({
  required Planilla planilla,
}) async {
  pw.Document doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      header: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          // margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'PLANILLA No. ${planilla.cabecera.pedido}',
            style: pw.Theme.of(context).defaultTextStyle.copyWith(
                  color: PdfColors.grey,
                ),
          ),
        );
      },
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey),
              ),
            ],
          ),
        );
      },
      build: (pw.Context context) => [
        // pw.Paragraph(text: "LISTA DE CONCILIACIÓN"),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Row(
          children: [
            fieldPdf(
              campo: 'LCL',
              valor: planilla.cabecera.lcl,
            ),
            fieldPdf(
              campo: 'UNIDAD',
              valor: planilla.cabecera.unidad,
            ),
            fieldPdf(
              campo: 'MOV',
              valor: planilla.cabecera.tipo_movimiento,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              campo: 'CONSECUTIVO',
              valor: planilla.cabecera.planilla,
            ),
            fieldPdf(
              campo: 'DESTINO',
              valor: planilla.cabecera.destino,
            ),
            fieldPdf(
              campo: 'ING. CONTRATO',
              valor: planilla.cabecera.solicitante,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              campo: 'CONTRATO',
              valor: planilla.cabecera.contrato,
            ),
            fieldPdf(
              campo: 'PDI',
              valor: planilla.cabecera.pdi,
            ),
            fieldPdf(
              campo: 'NOMBRE PDI',
              valor: planilla.cabecera.nombre_pdi,
            ),
            fieldPdf(
              campo: 'PROYECTO',
              valor: planilla.cabecera.proyecto,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              flex: 2,
              campo: 'PROCESO',
              valor: planilla.cabecera.proceso,
            ),
            fieldPdf(
              campo: 'FUN. CONTRATO',
              valor: planilla.cabecera.lider_contrato_e,
            ),
            fieldPdf(
              campo: 'PLACA MOVIL',
              valor: planilla.cabecera.placa_cuadrilla_e,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              flex: 2,
              campo: 'ING. ENEL',
              valor: planilla.cabecera.ingeniero_enel,
            ),
            fieldPdf(
              campo: 'PDL - ID',
              valor: planilla.cabecera.pdl,
            ),
            fieldPdf(
              campo: 'TEL FUN.',
              valor: planilla.cabecera.tel_lider_e,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              campo: 'FEHCA ENTREGA',
              valor: planilla.cabecera.fecha_e,
            ),
            fieldPdf(
              campo: 'FECHA REINTEGRO',
              valor: planilla.cabecera.fecha_r,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              campo: 'OBSERVACIONES',
              valor: planilla.cabecera.comentario,
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            fieldPdf(
              campo: 'ALMACENISTA ENTREGA',
              valor: planilla.cabecera.almacenista_e,
            ),
            fieldPdf(
              campo: 'TEL. ALMACENISTA',
              valor: planilla.cabecera.tel_alm_e,
            ),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Text(
          "Tabla 1, Materiales suministrados",
          style: pw.Theme.of(context).defaultTextStyle.copyWith(
                fontStyle: pw.FontStyle.italic,
                fontSize: 10.0,
              ),
        ),
        pw.Table.fromTextArray(
          context: context,
          data: [
            [
              'E4e',
              'Descripción',
              'Um',
              'Ctd Total',
            ],
            for (Registro row in planilla.registros) row.toListPdf(),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Column(
              children: [
                pw.Text('SOPORTE PLANILLA'),
                pw.UrlLink(
                  destination: planilla.cabecera.soporte_e,
                  child: pw.BarcodeWidget(
                    data: planilla.cabecera.soporte_e,
                    width: 60,
                    height: 60,
                    barcode: pw.Barcode.qrCode(),
                    drawText: false,
                  ),
                ),
              ],
            ),
            if (planilla.estados.soporte_informe.isNotEmpty)
              pw.Column(
                children: [
                  pw.Text('SOPORTE INFORME'),
                  pw.UrlLink(
                    destination: planilla.estados.soporte_informe,
                    child: pw.BarcodeWidget(
                      data: planilla.estados.soporte_informe,
                      width: 60,
                      height: 60,
                      barcode: pw.Barcode.qrCode(),
                      drawText: false,
                    ),
                  ),
                ],
              ),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Table.fromTextArray(
          context: context,
          data: [
            [
              'Estado Contrato',
              'Estado Enel',
              'Estado SAP',
            ],
            [
              planilla.estados.estado_contrato,
              planilla.estados.estado_enel,
              planilla.estados.estado_sap,
            ],
          ],
        ),
      ],
    ),
  );

  final pdfBytes = await doc.save();
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, "_blank");
  // html.Url.revokeObjectUrl(url);
}

pw.Expanded fieldPdf({
  int flex = 1,
  required String campo,
  required String valor,
}) {
  return pw.Expanded(
    flex: flex,
    child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$campo: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: valor),
        ],
      ),
    ),
  );
}
