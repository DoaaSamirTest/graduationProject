import 'package:flutter/material.dart';
import 'package:gproject/utils/theme_data.dart';
import 'screens/home_screen.dart';
import 'screens/medicine_details_screen.dart';
import 'screens/control_screen.dart';
import 'screens/search_screen.dart';
import 'utils/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(MedicineApp());
}

class MedicineApp extends StatelessWidget {
  const MedicineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الأدوية الآلي',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      routes: {
        '/home': (context) => HomeScreen(),
        '/details': (context) => MedicineDetailsScreen(),
        '/control': (context) => ControlScreen(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}
