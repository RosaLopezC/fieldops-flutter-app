import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://31.97.91.123/api';

  Future<Map<String, dynamic>> login(String dni, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'dni': dni,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['user']['rol'] != 'encargado') {
          return {
            'success': false,
            'message': 'Acceso denegado. Solo encargados pueden ingresar.',
          };
        }

        // Convertir explícitamente a Map<String, String>
        final Map<String, String> userData = {
          'nombre': '${data['user']['nombres']} ${data['user']['apellidos']}'.trim(),
          'dni': data['user']['dni'].toString(),
        };

        return {
          'success': true,
          'token': data['access'],
          'user': userData, // Ahora es Map<String, String>
        };
      } else {
        return {
          'success': false,
          'message': data['detail'] ?? 'Error al iniciar sesión',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión',
      };
    }
  }
}