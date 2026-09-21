import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // NUEVO
import '../modelos/producto.dart';
import '../modelos/articulo_carrito.dart';

class TiendaViewModel extends ChangeNotifier {
  // 1. Instancia de la base de datos Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 2. La lista arranca vacía, ya no hay datos "falsos"
  List<Producto> _productos = [];
  final List<ArticuloCarrito> _carrito = [];
  bool _cargando = false;

  List<Producto> get productos => _productos;
  List<ArticuloCarrito> get carrito => _carrito;
  bool get cargando => _cargando;

  // ... (Tus otros getters como totalArticulosCarrito, subtotal, etc. quedan EXACTAMENTE IGUAL)
  int get totalArticulosCarrito {
    int suma = 0;
    for (var articulo in _carrito) {
      suma = suma + articulo.cantidad;
    }
    return suma;
  }

  double get subtotal {
    double suma = 0.0;
    for (var articulo in _carrito) {
      suma = suma + (articulo.producto.precio * articulo.cantidad);
    }
    return suma;
  }

  double get costoEnvio => 3500.0;
  double get total => subtotal + costoEnvio;

  // 3. NUEVA LÓGICA: Traer de Firebase
  Future<void> buscarProductos() async {
    _cargando = true;
    notifyListeners(); // Avisa a la UI que muestre la ruedita de carga

    try {
      // Va a Firebase, busca la colección 'repuestos' y trae todo
      QuerySnapshot snapshot = await _db.collection('repuestos').get();

      // Convierte los documentos de Firebase en una lista de Productos de Dart
      _productos = snapshot.docs.map((doc) => Producto.desdeFirestore(doc)).toList();

    } catch (error) {
      print("Hubo un error al traer datos de Firebase: $error");
    } finally {
      _cargando = false;
      notifyListeners(); // Avisa a la UI que ya terminó de cargar
    }
  }

  // ... (Tus funciones de agregarAlCarrito, actualizarCantidad y eliminarDelCarrito quedan EXACTAMENTE IGUAL)
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