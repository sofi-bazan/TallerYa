import 'package:flutter/material.dart';
import '../viewmodels/tienda_viewmodel.dart';
import '../modelos/articulo_carrito.dart';
import '../widgets/barra_navegacion_inferior.dart';

class PantallaCarrito extends StatefulWidget {
  final TiendaViewModel viewModel;
  const PantallaCarrito({super.key, required this.viewModel});

  @override
  State<PantallaCarrito> createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  String _metodoEntrega = 'domicilio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Carrito de compras', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (widget.viewModel.carrito.isEmpty) return const Center(child: Text('El carrito está vacío.'));
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.viewModel.totalArticulosCarrito} productos en el carrito', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...widget.viewModel.carrito.map((articulo) => _construirArticuloCarrito(articulo)),
                  const SizedBox(height: 24),
                  const Text('Resumen del pedido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal', style: TextStyle(color: Colors.grey)), Text('\$ ${widget.viewModel.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Envío', style: TextStyle(color: Colors.grey)), Text('\$ ${widget.viewModel.costoEnvio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24, thickness: 1),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('\$ ${widget.viewModel.total.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))]),
                  const SizedBox(height: 24),
                  const Text('Método de entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          value: 'domicilio', groupValue: _metodoEntrega, activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (valor) => setState(() => _metodoEntrega = valor!),
                          title: const Text('Envío a domicilio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: const Text('Llega en 2 a 4 días hábiles', style: TextStyle(fontSize: 12)),
                          secondary: Text('\$ ${widget.viewModel.costoEnvio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          value: 'taller', groupValue: _metodoEntrega, activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (valor) => setState(() => _metodoEntrega = valor!),
                          title: const Text('Retiro en taller', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: const Text('Coordinás con el vendedor', style: TextStyle(fontSize: 12)),
                          secondary: const Text('Gratis', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Procesando pago simulado...'))),
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock_outline, size: 14, color: Colors.grey), SizedBox(width: 4), Text('Pago 100% seguro con Mercado Pago', style: TextStyle(color: Colors.grey, fontSize: 12))])),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
      ),
      bottomNavigationBar: BarraNavegacionInferior(
        indiceActual: 2, viewModel: widget.viewModel,
        alTocar: (indice) { if (indice == 0) Navigator.popUntil(context, (route) => route.isFirst); },
      ),
    );
  }

  Widget _construirArticuloCarrito(ArticuloCarrito articuloCarrito) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12), color: Colors.white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.settings_suggest, color: Colors.grey)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(articuloCarrito.producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(articuloCarrito.producto.modeloAuto, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('\$ ${articuloCarrito.producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () => widget.viewModel.actualizarCantidad(articuloCarrito.producto.id, -1), constraints: const BoxConstraints(minWidth: 32, minHeight: 32), padding: EdgeInsets.zero),
                            Text('${articuloCarrito.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(icon: const Icon(Icons.add, size: 16), onPressed: () => widget.viewModel.actualizarCantidad(articuloCarrito.producto.id, 1), constraints: const BoxConstraints(minWidth: 32, minHeight: 32), padding: EdgeInsets.zero),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.grey), onPressed: () => widget.viewModel.eliminarDelCarrito(articuloCarrito.producto.id))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}