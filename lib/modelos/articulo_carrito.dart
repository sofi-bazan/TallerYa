import 'producto.dart';

class ArticuloCarrito {
  final Producto producto;
  int cantidad;

  ArticuloCarrito({required this.producto, this.cantidad = 1});
}