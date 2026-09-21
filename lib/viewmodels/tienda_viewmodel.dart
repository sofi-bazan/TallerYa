import 'package:flutter/material.dart';
import '../modelos/producto.dart';
import '../modelos/articulo_carrito.dart';

class TiendaViewModel extends ChangeNotifier {
  final List<Producto> _productos = [
    Producto(
      id: '1', nombre: 'Alternador', modeloAuto: 'Volkswagen Gol Trend 2016',
      nombreVendedor: 'Taller Los Hermanos', calificacion: 4.7, opiniones: 128,
      precio: 85000, condicion: 'Usado', stock: 2,
    ),
    Producto(
      id: '2', nombre: 'Óptica delantera izquierda', modeloAuto: 'Volkswagen Gol Trend 2016',
      nombreVendedor: 'Repuestos San Martin', calificacion: 4.5, opiniones: 89,
      precio: 62000, condicion: 'Reacondicionado', stock: 1,
    ),
    Producto(
      id: '3', nombre: 'Espejo lateral derecho', modeloAuto: 'Volkswagen Gol Trend 2016',
      nombreVendedor: 'Taller Pista 1', calificacion: 4.2, opiniones: 64,
      precio: 28000, condicion: 'Usado', stock: 5,
    ),
  ];

  final List<ArticuloCarrito> _carrito = [];
  bool _cargando = false;

  List<Producto> get productos => _productos;
  List<ArticuloCarrito> get carrito => _carrito;
  bool get cargando => _cargando;

  int get totalArticulosCarrito => _carrito.fold(0, (suma, articulo) => suma + articulo.cantidad);
  double get subtotal => _carrito.fold(0, (suma, articulo) => suma + (articulo.producto.precio * articulo.cantidad));
  double get costoEnvio => 3500;
  double get total => subtotal + costoEnvio;

  Future<void> buscarProductos() async {
    _cargando = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _cargando = false;
    notifyListeners();
  }

  void agregarAlCarrito(Producto producto) {
    final indice = _carrito.indexWhere((articulo) => articulo.producto.id == producto.id);
    if (indice >= 0) {
      _carrito[indice].cantidad++;
    } else {
      _carrito.add(ArticuloCarrito(producto: producto));
    }
    notifyListeners();
  }

  void actualizarCantidad(String productoId, int cambio) {
    final indice = _carrito.indexWhere((articulo) => articulo.producto.id == productoId);
    if (indice >= 0) {
      _carrito[indice].cantidad += cambio;
      if (_carrito[indice].cantidad <= 0) _carrito.removeAt(indice);
      notifyListeners();
    }
  }

  void eliminarDelCarrito(String productoId) {
    _carrito.removeWhere((articulo) => articulo.producto.id == productoId);
    notifyListeners();
  }
}