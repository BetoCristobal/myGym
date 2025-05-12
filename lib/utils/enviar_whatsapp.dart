import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


enviarWhatsapp(DateTime proximoPago, String telefonoString) async {
  String proximaFechaPago = DateFormat('dd-MM-yyyy').format(proximoPago);
  //int telefono = int.parse(telefonoString);

  final url = 
    'https://wa.me/521$telefonoString?text=${Uri.encodeComponent("Hola que tal,recordandote que tu fecha de pago es el proximo $proximaFechaPago.\n Nunca dejes de entrenar,que tengas un bonito día.")}';

  try {
    print("Intentando lanzar: $url");
    final Uri uri = Uri.parse(url);
    if(await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("No se pudo abrir whatsApp");
    }
  } catch (e) {
    print("Error $e");
  }
}