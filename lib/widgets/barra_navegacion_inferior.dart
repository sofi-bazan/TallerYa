import 'package:flutter/material.dart';
import '../viewmodels/tienda_viewmodel.dart';

class BarraNavegacionInferior extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int> alTocar;
  final TiendaViewModel viewModel;

  const BarraNavegacionInferior({
    super.key,
    required this.indiceActual,
    required this.alTocar,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: indiceActual,
        onTap: alTocar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return Badge(
                  isLabelVisible: viewModel.totalArticulosCarrito > 0,
                  label: Text(viewModel.totalArticulosCarrito.toString()),
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            activeIcon: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return Badge(
                  isLabelVisible: viewModel.totalArticulosCarrito > 0,
                  label: Text(viewModel.totalArticulosCarrito.toString()),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Mensajes'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}