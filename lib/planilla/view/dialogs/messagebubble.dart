import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fecha/hora
import 'package:url_launcher/url_launcher.dart'; // Para abrir URL en el navegador

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final DateTime timestamp;
  final String attachmentUrl;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.attachmentUrl,
  }) : super(key: key);

  // Ajusta la lógica si quieres mostrar la burbuja a la derecha o izquierda,
  // por ejemplo, si 'sender' es el usuario actual.
  bool get isMyMessage => sender.toLowerCase().contains('enel.com'); // Ejemplo

  // Método para abrir el enlace del adjunto en una nueva pestaña (Flutter Web).
  Future<void> _openAttachment(String url) async {
    // Verifica si se puede abrir el enlace
    if (await canLaunchUrl(Uri.parse(url))) {
      // Abre en una nueva pestaña (webOnlyWindowName: '_blank')
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } else {
      debugPrint("No se pudo abrir el enlace: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      // Si es mi mensaje, lo alineamos a la derecha, si no, a la izquierda
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMyMessage ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remitente
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMyMessage ? Colors.blueGrey : Colors.black54,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            // Mensaje
            Text(message),
            // Ícono de adjunto (si aplica)
            if (attachmentUrl.isNotEmpty) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _openAttachment(attachmentUrl),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, size: 14, color: Colors.indigo),
                    SizedBox(width: 4),
                    Text(
                      'Abrir adjunto',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            // Fecha/hora
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(timestamp),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
