import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Agregamos el núcleo de Firebase
import 'firebase_options.dart'; // Agregamos el archivo que generó la terminal

import 'viewmodels/tienda_viewmodel.dart';
import 'pantallas/controlador_pestanas_principal.dart';

void main() async {
  // Esta línea es OBLIGATORIA. Le dice a Flutter que espere a que Firebase se conecte
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase usando las credenciales generadas para Android/iOS
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(AplicacionRepuestoYa());
}

class AplicacionRepuestoYa extends StatelessWidget {
  final TiendaViewModel viewModel = TiendaViewModel();

  AplicacionRepuestoYa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepuestoYa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          primary: const Color(0xFFD32F2F),
          surface: Colors.white,
          background: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: ControladorPestanasPrincipal(viewModel: viewModel),
    );
  }
}