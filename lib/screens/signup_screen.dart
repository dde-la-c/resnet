import 'package:flutter/material.dart';
import '../service/api_service.dart';

/// [SignUpScreen] es la pantalla de registro de usuarios de la aplicación.
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controladores para los campos de texto del nombre, email, contraseña y confirmación de contraseña.
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Mensaje para mostrar en caso de error o éxito en el registro.
  String _message = '';

  /// Método para manejar el proceso de registro de usuario.
  void _guardarUsuario() async {
    final nombre = _nombreController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validar que todos los campos estén completos.
    if (nombre.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _message = 'Por favor completa todos los campos';
      });
      return;
    }

    // Validar que las contraseñas coincidan.
    if (password != confirmPassword) {
      setState(() {
        _message = 'Las contraseñas no coinciden';
      });
      return;
    }

    // Enviar los datos del usuario al servidor para guardar.
    final isSuccess = await ApiService.insertarUsuario(nombre, email, password);

    // Mostrar mensaje de éxito o error según el resultado de la operación.
    if (isSuccess) {
      setState(() {
        _message = 'Usuario creado exitosamente';
      });
    } else {
      setState(() {
        _message = 'Error al crear el usuario';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para el nombre.
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            // Campo de texto para el correo electrónico.
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            // Campo de texto para la contraseña.
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true, // Ocultar texto para la contraseña.
            ),
            // Campo de texto para confirmar la contraseña.
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
              obscureText:
                  true, // Ocultar texto para la confirmación de la contraseña.
            ),
            SizedBox(height: 20),
            // Botón para crear la cuenta.
            ElevatedButton(
              onPressed: _guardarUsuario,
              child: Text('Crear Cuenta'),
            ),
            SizedBox(height: 20),
            // Mostrar mensaje de error o éxito.
            Text(_message),
          ],
        ),
      ),
    );
  }
}
