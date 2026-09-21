import 'package:flutter/material.dart';
import '../viewmodels/tienda_viewmodel.dart';
import '../widgets/barra_navegacion_inferior.dart';
import 'p_carrito.dart';
import 'p_detalle_producto.dart';

class PantallaResultadosBusqueda extends StatelessWidget {
  final TiendaViewModel viewModel;

  const PantallaResultadosBusqueda({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Resultados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return Badge(
                  isLabelVisible: viewModel.totalArticulosCarrito > 0,
                  label: Text(viewModel.totalArticulosCarrito.toString()),
                  offset: const Offset(-8, 8),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PantallaCarrito(viewModel: viewModel))),
                  ),
                );
              }
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16), color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Volkswagen Gol Trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('2016', style: TextStyle(color: Colors.grey)),
                ]),
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cambiar', style: TextStyle(color: Theme.of(context).colorScheme.primary))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list, size: 18), label: const Text('Filtros', style: TextStyle(color: Colors.black))),
                TextButton(onPressed: () {}, child: const Row(children: [Text('Ordenar por', style: TextStyle(color: Colors.black)), Icon(Icons.keyboard_arrow_down, color: Colors.black)])),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.productos.length,
              itemBuilder: (context, indice) {
                final producto = viewModel.productos[indice];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaDetalleProducto(viewModel: viewModel, producto: producto))),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16), elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.settings_suggest, color: Colors.grey)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(child: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                  const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                                ]),
                                Text(producto.modeloAuto, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(producto.nombreVendedor, style: const TextStyle(fontSize: 12)),
                                Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), Text(' ${producto.calificacion} (${producto.opiniones})', style: const TextStyle(fontSize: 12, color: Colors.grey))]),
                                const SizedBox(height: 8),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('\$ ${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(producto.condicion, style: TextStyle(color: producto.condicion == 'Usado' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                                ])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraNavegacionInferior(
        indiceActual: 1, viewModel: viewModel,
        alTocar: (indice) { if (indice == 0) Navigator.popUntil(context, (route) => route.isFirst); },
      ),
    );
  }
}