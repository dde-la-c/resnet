import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'signup_screen.dart'; // Importa la pantalla de registro
import 'home_screen.dart'; // Importa la pantalla a la que quieres navegar después del login exitoso

/// [LoginScreen] es la pantalla principal de inicio de sesión de la aplicación.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de texto de email y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Mensaje para mostrar en caso de error en el login
  String _message = '';

  /// Método para manejar el proceso de login
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Llamada al servicio para comparar la contraseña
    final isValid = await ApiService.comparePassword(email, password);

    if (isValid) {
      // Verificar si el usuario es administrador
      bool isAdmin = await ApiService.isAdmin(email);

      // Navegar a la pantalla principal si el login es exitoso
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: isAdmin)),
      );
    } else {
      // Mostrar mensaje de error si el login falla
      setState(() {
        _message = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para el email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Campo de texto para la contraseña
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // Ocultar texto para la contraseña
            ),
            SizedBox(height: 20),
            // Botón de login
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            // Mostrar mensaje de error si lo hay
            Text(_message),
            SizedBox(height: 20),
            // Botón para navegar a la pantalla de registro
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de registro cuando se hace clic en el botón de Sign Up
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
