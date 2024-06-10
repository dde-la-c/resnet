import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

/// La función principal de la aplicación que se ejecuta al iniciar.
void main() {
  runApp(MyApp());
}

/// La clase [MyApp] es el punto de entrada principal de la aplicación.
/// Esta clase extiende de [StatelessWidget] ya que no mantiene ningún estado.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp es el widget raíz de la aplicación. Configura el tema y la navegación.
    return MaterialApp(
      home:
          LoginScreen(), // La pantalla principal de la aplicación es LoginScreen.
    );
  }
}
