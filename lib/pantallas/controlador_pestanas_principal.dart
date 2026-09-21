import 'package:flutter/material.dart';
import '../viewmodels/tienda_viewmodel.dart';
import '../widgets/barra_navegacion_inferior.dart';
import 'p_inicio.dart';
import 'p_carrito.dart';

class ControladorPestanasPrincipal extends StatefulWidget {
  final TiendaViewModel viewModel;
  const ControladorPestanasPrincipal({super.key, required this.viewModel});

  @override
  State<ControladorPestanasPrincipal> createState() => _ControladorPestanasPrincipalState();
}

class _ControladorPestanasPrincipalState extends State<ControladorPestanasPrincipal> {
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallas = [
      PantallaInicio(viewModel: widget.viewModel),
      const Center(child: Text('Buscador avanzado (Fuera de alcance)')),
      PantallaCarrito(viewModel: widget.viewModel),
      const Center(child: Text('Mensajes (Fuera de alcance)')),
      const Center(child: Text('Perfil (Fuera de alcance)')),
    ];

    return Scaffold(
      body: pantallas[_indiceSeleccionado],
      bottomNavigationBar: BarraNavegacionInferior(
        indiceActual: _indiceSeleccionado,
        viewModel: widget.viewModel,
        alTocar: (indice) => setState(() => _indiceSeleccionado = indice),
      ),
    );
  }
}