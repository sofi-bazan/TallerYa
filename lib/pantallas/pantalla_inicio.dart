import 'package:flutter/material.dart';
import '../viewmodels/tienda_viewmodel.dart';
import '../modelos/producto.dart';
import 'pantalla_resultados_busqueda.dart';
import 'pantalla_detalle_producto.dart';

class PantallaInicio extends StatefulWidget {
  final TiendaViewModel viewModel;
  const PantallaInicio({super.key, required this.viewModel});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  late ScrollController _controladorScroll;

  @override
  void initState() {
    super.initState();
    _controladorScroll = ScrollController();
  }

  @override
  void dispose() {
    _controladorScroll.dispose();
    super.dispose();
  }

  void _manejarBusqueda() async {
    await widget.viewModel.buscarProductos();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PantallaResultadosBusqueda(viewModel: widget.viewModel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              const TextSpan(text: 'Repuesto'),
              TextSpan(text: 'Ya', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        controller: _controladorScroll,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('Repuestos usados y reacondicionados', style: TextStyle(color: Colors.grey, fontSize: 12))),
            const SizedBox(height: 24),
            const Text('¿Qué repuesto buscás?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Elegí tu auto para encontrar lo que necesitás', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            _construirFiltroDesplegable(Icons.directions_car, 'Marca', 'Seleccioná la marca'),
            const SizedBox(height: 12),
            _construirFiltroDesplegable(Icons.car_repair, 'Modelo', 'Seleccioná el modelo'),
            const SizedBox(height: 12),
            _construirFiltroDesplegable(Icons.calendar_today, 'Año', 'Seleccioná el año'),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity, height: 50,
              child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: widget.viewModel.cargando ? null : _manejarBusqueda,
                      child: widget.viewModel.cargando
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Buscar repuestos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    );
                  }
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Categorías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text('Ver todas', style: TextStyle(color: Theme.of(context).colorScheme.primary)))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _construirItemCategoria(Icons.settings, 'Motor'),
                _construirItemCategoria(Icons.miscellaneous_services, 'Transmisión'),
                _construirItemCategoria(Icons.car_crash, 'Frenos'),
                _construirItemCategoria(Icons.build, 'Suspensión'),
                _construirItemCategoria(Icons.directions_car, 'Carrocería'),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Repuestos destacados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.viewModel.productos.length,
                itemBuilder: (context, indice) => _construirProductoDestacado(widget.viewModel.productos[indice], context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirFiltroDesplegable(IconData icono, String titulo, String subtitulo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icono, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitulo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ])),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _construirItemCategoria(IconData icono, String etiqueta) {
    return Column(
      children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(icono, color: Colors.black54)),
        const SizedBox(height: 8),
        Text(etiqueta, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _construirProductoDestacado(Producto producto, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaDetalleProducto(viewModel: widget.viewModel, producto: producto))),
      child: Container(
        width: 160, margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
              width: double.infinity, child: const Icon(Icons.settings_suggest, size: 50, color: Colors.grey),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('\$ ${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(producto.condicion, style: TextStyle(color: producto.condicion == 'Usado' ? Colors.green : Colors.orange, fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}