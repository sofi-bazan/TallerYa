import 'package:cloud_firestore/cloud_firestore.dart'; // Importante importar esto

class Producto {
  final String id;
  final String nombre;
  final String modeloAuto;
  final String nombreVendedor;
  final double calificacion;
  final int opiniones;
  final double precio;
  final String condicion;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.modeloAuto,
    required this.nombreVendedor,
    required this.calificacion,
    required this.opiniones,
    required this.precio,
    required this.condicion,
    required this.stock,
  });

  // NUEVO: El "Traductor" de Firebase a Dart
  factory Producto.desdeFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Producto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      modeloAuto: data['modeloAuto'] ?? '',
      nombreVendedor: data['nombreVendedor'] ?? '',
      // Los que llevan decimales los aseguramos con .toDouble()
      calificacion: (data['calificacion'] ?? 0.0).toDouble(),
      precio: (data['precio'] ?? 0.0).toDouble(),

      // ¡LOS BLINDAMOS! Los forzamos a ser enteros con .toInt()
      opiniones: (data['opiniones'] ?? 0).toInt(),
      stock: (data['stock'] ?? 0).toInt(),

      condicion: data['condicion'] ?? 'Usado',
    );
  }
}