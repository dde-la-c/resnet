import 'package:flutter/material.dart';
import '../service/api_service.dart';

// Definición de la clase StatefulWidget para la pantalla de correo electrónico
class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

// Estado asociado con la pantalla de correo electrónico
class _EmailScreenState extends State<EmailScreen> {
  // Controlador para el campo de texto del correo electrónico
  final TextEditingController _emailController = TextEditingController();

  // Clave global para el formulario, utilizada para validaciones
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Función asincrónica para enviar el correo electrónico
  Future<void> _sendEmail() async {
    // Verifica si el formulario es válido
    if (_formKey.currentState!.validate()) {
      try {
        // Llama al servicio API para enviar el correo electrónico
        await ApiService.sendEmail(_emailController.text, 1);
        // Muestra un mensaje de éxito en la interfaz de usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo enviado exitosamente')),
        );
      } catch (e) {
        // Muestra un mensaje de error en la interfaz de usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar correo: $e')),
        );
      }
    }
  }

  // Método build para construir la interfaz de usuario de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Correo de Recuperación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el correo electrónico del usuario
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo del Usuario'),
                // Validador para el campo de texto
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Botón para enviar el correo de recuperación
              ElevatedButton(
                onPressed: _sendEmail,
                child: Text('Enviar Correo de Recuperación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
