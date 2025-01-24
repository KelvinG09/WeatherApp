import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Networking {
  final String url;

  Networking({required this.url});

  Future<dynamic> getData() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Retorna el json completo para poderlo procesar
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
