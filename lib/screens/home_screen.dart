import 'package:flutter/material.dart';
import 'package:pruebaresnet/screens/excel_screen.dart';
import 'package:pruebaresnet/screens/email_screen.dart';
import 'package:pruebaresnet/screens/pdf_screen.dart';
import '../service/api_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;

  HomeScreen({required this.isAdmin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> _loadMenuNamesAndStatus() async {
    try {
      String? name1 = await ApiService.getMenuName(1);
      String? name2 = await ApiService.getMenuName(2);
      bool active1 = await ApiService.isMenuActive(1);
      bool active2 = await ApiService.isMenuActive(2);

      String? subName1 = await ApiService.getSubmenuName(1);
      String? subName2 = await ApiService.getSubmenuName(2);
      bool subActive1 = await ApiService.isSubmenuActive(1);
      bool subActive2 = await ApiService.isSubmenuActive(2);

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
      setState(() {
        menuName1 = 'Error';
        menuName2 = 'Error';
      });
    }
  }

  void _navigateToDataTableScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataTableScreen(),
      ),
    );
  }

  void _navigateToEmailScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailScreen(),
      ),
    );
  }

  void _navigateToPdfScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfExportScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'subOption1':
                  _navigateToDataTableScreen(context);
                  break;
                case 'subOption2':
                  _navigateToEmailScreen(context);
                  break;
                case 'subOption3':
                  _navigateToPdfScreen(context);
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
                  child: Text(menuName2),
                ),
              if (widget.isAdmin)
                PopupMenuItem<String>(
                  value: 'admin',
                  child: PopupMenuButton<String>(
                    onSelected: (String subResult) {
                      switch (subResult) {
                        case 'subOption1':
                          _navigateToDataTableScreen(context);
                          break;
                        case 'subOption2':
                          _navigateToEmailScreen(context);
                          break;
                        case 'subOption3':
                          _navigateToPdfScreen(context);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      if (isSubmenu1Active && isMenu2Active || widget.isAdmin)
                        PopupMenuItem<String>(
                          value: 'subOption1',
                          child: Text(submenuName1),
                        ),
                      if (isSubmenu2Active && isMenu2Active || widget.isAdmin)
                        PopupMenuItem<String>(
                          value: 'subOption2',
                          child: Text(submenuName2),
                        ),
                      // if (isSubmenu2Active && isMenu2Active || widget.isAdmin)
                      PopupMenuItem<String>(
                        value: 'subOption3',
                        child: Text("pdf"),
                      ),
                    ],
                    child: ListTile(
                      title: Text('admin'),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
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
