import 'dart:convert';
import 'package:http/http.dart' as http;

/// [ApiService] es una clase que proporciona métodos estáticos para interactuar con una API backend.
class ApiService {
  // URL base del servidor backend.
  static const String baseUrl = 'http://192.168.79.14:3000';

  /// Compara la contraseña del usuario con la almacenada en el servidor.
  ///
  /// Parámetros:
  /// - [email]: El email del usuario.
  /// - [password]: La contraseña del usuario.
  ///
  /// Retorna:
  /// - `true` si la contraseña es válida, `false` de lo contrario.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<bool> comparePassword(String email, String password) async {
    final url = Uri.parse('$baseUrl/comparePassword');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['isPasswordValid'];
    } else {
      throw Exception('Error ejecutando la consulta: ${response.statusCode}');
    }
  }

  /// Inserta un nuevo usuario en la base de datos.
  ///
  /// Parámetros:
  /// - [nombre]: El nombre del usuario.
  /// - [email]: El email del usuario.
  /// - [password]: La contraseña del usuario.
  ///
  /// Retorna:
  /// - `true` si el usuario fue insertado exitosamente, `false` de lo contrario.
  ///
  /// Lanza:
  /// - No lanza excepciones, pero imprime errores de conexión.
  static Future<bool> insertarUsuario(
      String nombre, String email, String password) async {
    final url = Uri.parse('$baseUrl/insertarUsuario');
    final body =
        jsonEncode({'nombre': nombre, 'email': email, 'contraseña': password});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // El usuario se insertó exitosamente
        return true;
      } else {
        // Ocurrió un error al insertar el usuario
        return false;
      }
    } catch (e) {
      // Error de conexión
      print('Error: $e');
      return false;
    }
  }

  /// Verifica si el usuario es administrador.
  ///
  /// Parámetros:
  /// - [email]: El email del usuario.
  ///
  /// Retorna:
  /// - `true` si el usuario es administrador, `false` de lo contrario.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<bool> isAdmin(String email) async {
    final url = Uri.parse('$baseUrl/esAdmin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isAdmin'];
    } else {
      throw Exception('Error al verificar si el usuario es administrador');
    }
  }

  /// Obtiene el nombre del menú dado su ID.
  ///
  /// Parámetros:
  /// - [idMenu]: El ID del menú.
  ///
  /// Retorna:
  /// - El nombre del menú si la consulta es exitosa, `null` de lo contrario.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<String?> getMenuName(int idMenu) async {
    final response = await http.get(Uri.parse('$baseUrl/nombreMenu/$idMenu'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['nombre'];
    } else {
      throw Exception('Error al obtener el nombre del menú');
    }
  }

  /// Verifica si el menú está activo dado su ID.
  ///
  /// Parámetros:
  /// - [idMenu]: El ID del menú.
  ///
  /// Retorna:
  /// - `true` si el menú está activo, `false` de lo contrario.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<bool> isMenuActive(int idMenu) async {
    final response = await http.get(Uri.parse('$baseUrl/menuActivo/$idMenu'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['activo'];
    } else {
      throw Exception('Error al obtener el estado del menú');
    }
  }

  /// Obtiene el nombre del submenú dado su ID.
  ///
  /// Parámetros:
  /// - [idMenu]: El ID del submenú.
  ///
  /// Retorna:
  /// - El nombre del submenú si la consulta es exitosa, `null` de lo contrario.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<String?> getSubmenuName(int idMenu) async {
    final response =
        await http.get(Uri.parse('$baseUrl/nombreSubmenu/$idMenu'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['nombre'];
    } else {
      throw Exception('Error al obtener el nombre del submenú');
    }
  }

  /// Verifica si el submenú está activo dado su ID.
  ///
  /// Parámetros:
  /// - [idMenu]: El ID del submenú.
  ///
  /// Retorna:
  /// - `true` si el submenú está activo, `false` de lo contrario.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<bool> isSubmenuActive(int idMenu) async {
    final response =
        await http.get(Uri.parse('$baseUrl/submenuActivo/$idMenu'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['activo'];
    } else {
      throw Exception('Error al obtener el estado del submenú');
    }
  }

  /// Fetch data from the SQL Server API.
  ///
  /// Retorna:
  /// - Una lista de mapas que representa las filas de datos.
  ///
  /// Lanza:
  /// - [Exception] si hay un error en la consulta.
  static Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/fetchData'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  static Future<void> sendEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'subject': 'Recuperación de contraseña',
        'message': 'Este es su enlace para recuperar la contraseña.',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar correo: ${response.body}');
    }
  }
}
