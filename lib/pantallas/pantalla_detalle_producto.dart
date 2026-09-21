import 'package:flutter/material.dart';
import '../viewmodels/tienda_viewmodel.dart';
import '../modelos/producto.dart';

class PantallaDetalleProducto extends StatelessWidget {
  final TiendaViewModel viewModel;
  final Producto producto;

  const PantallaDetalleProducto({super.key, required this.viewModel, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalle del repuesto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 250, width: double.infinity, color: Colors.grey.shade200, child: const Icon(Icons.settings_suggest, size: 100, color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (indice) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12), width: 8, height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: indice == 0 ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(producto.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(producto.modeloAuto, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: producto.condicion == 'Usado' ? Colors.green.shade50 : Colors.orange.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: producto.condicion == 'Usado' ? Colors.green : Colors.orange)),
                        child: Text(producto.condicion, style: TextStyle(color: producto.condicion == 'Usado' ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('\$ ${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(25)), child: const Icon(Icons.storefront, color: Colors.white)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(producto.nombreVendedor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Text('Taller', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), Text(' ${producto.calificacion} (${producto.opiniones} opiniones)', style: const TextStyle(fontSize: 12, color: Colors.grey))]),
                        ])),
                        OutlinedButton(onPressed: () {}, child: const Text('Ver perfil'))
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Descripción', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Alternador original en buen estado. Se entrega probado y con garantía.', style: TextStyle(color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 24),
                  const Text('Compatibilidad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _construirItemChequeo('Marca: Volkswagen'), _construirItemChequeo('Modelo: Gol Trend'), _construirItemChequeo('Año: 2016'),
                  const SizedBox(height: 24),
                  Text('Stock disponible: ${producto.stock} unidades', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () {}, icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.primary),
                label: Text('Consultar al\nvendedor', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                onPressed: () {
                  viewModel.agregarAlCarrito(producto);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agregado al carrito')));
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Agregar al\ncarrito', textAlign: TextAlign.center),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirItemChequeo(String texto) {
    return Padding(padding: const EdgeInsets.only(bottom: 6.0), child: Row(children: [const Icon(Icons.check, color: Colors.green, size: 18), const SizedBox(width: 8), Text(texto)]));
  }
}