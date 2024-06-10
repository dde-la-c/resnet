import 'package:flutter/material.dart';
import '../service/api_service.dart';

/// [HomeScreen] es la pantalla principal después de un inicio de sesión exitoso.
/// Muestra opciones de menú que pueden estar activas o inactivas, y diferentes submenús.
class HomeScreen extends StatefulWidget {
  final bool isAdmin;

  /// Constructor de [HomeScreen] que acepta un parámetro [isAdmin] para determinar si el usuario es administrador.
  HomeScreen({required this.isAdmin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables para almacenar los nombres y estados de los menús y submenús.
  String menuName1 = 'Loading...';
  String menuName2 = 'Loading...';
  bool isMenu1Active = false;
  bool isMenu2Active = false;

  String submenuName1 = 'Loading...';
  String submenuName2 = 'Loading...';
  bool isSubmenu1Active = false;
  bool isSubmenu2Active = false;

  @override
  void initState() {
    super.initState();
    _loadMenuNamesAndStatus();
  }

  /// Método para cargar los nombres y estados de los menús y submenús desde la API.
  Future<void> _loadMenuNamesAndStatus() async {
    try {
      // Llamadas a la API para obtener los nombres y estados de los menús y submenús.
      String? name1 = await ApiService.getMenuName(1);
      String? name2 = await ApiService.getMenuName(2);
      bool active1 = await ApiService.isMenuActive(1);
      bool active2 = await ApiService.isMenuActive(2);

      String? subName1 = await ApiService.getSubmenuName(1);
      String? subName2 = await ApiService.getSubmenuName(2);
      bool subActive1 = await ApiService.isSubmenuActive(1);
      bool subActive2 = await ApiService.isSubmenuActive(2);

      // Actualizar el estado de la pantalla con los datos obtenidos.
      setState(() {
        menuName1 = name1 ?? 'No disponible';
        menuName2 = name2 ?? 'No disponible';
        isMenu1Active = active1;
        isMenu2Active = active2;

        submenuName1 = subName1 ?? 'No disponible';
        submenuName2 = subName2 ?? 'No disponible';
        isSubmenu1Active = subActive1;
        isSubmenu2Active = subActive2;
      });
    } catch (e) {
      // Manejar errores en caso de que las llamadas a la API fallen.
      setState(() {
        menuName1 = 'Error';
        menuName2 = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Menú desplegable en la AppBar
          PopupMenuButton<String>(
            onSelected: (String result) {
              // Acciones a realizar según la opción seleccionada
              switch (result) {
                case 'option1':
                  print('$menuName1 seleccionada');
                  break;
                case 'option2':
                  print('$menuName2 seleccionada');
                  break;
                case 'adminOption':
                  print('Opción de administrador seleccionada');
                  break;
                case 'logout':
                  print('Cerrar sesión');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (isMenu1Active)
                PopupMenuItem<String>(
                  value: 'option1',
                  child: Text(menuName1),
                ),
              if (isMenu2Active)
                PopupMenuItem<String>(
                  value: 'option2',
                  child: PopupMenuButton<String>(
                    onSelected: (String subResult) {
                      // Acciones a realizar según la subopción seleccionada
                      switch (subResult) {
                        case 'subOption1':
                          print('Subopción 1 seleccionada');
                          break;
                        case 'subOption2':
                          print('Subopción 2 seleccionada');
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      if (isSubmenu1Active && isMenu2Active || widget.isAdmin)
                        PopupMenuItem<String>(
                            value: 'subOption1', child: Text(submenuName1)),
                      if (isSubmenu2Active && isMenu2Active || widget.isAdmin)
                        PopupMenuItem<String>(
                          value: 'subOption2',
                          child: Text(submenuName2),
                        ),
                    ],
                    child: ListTile(
                      title: Text(menuName2),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
                ),
              if (widget.isAdmin)
                const PopupMenuItem<String>(
                  value: 'adminOption',
                  child: Text('Opción de administrador'),
                ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenido al Home Screen'),
      ),
    );
  }
}
