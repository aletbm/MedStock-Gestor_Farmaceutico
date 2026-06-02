class Product {
  int? id;
  String nombreComercial;
  String nombreGenerico;
  String concentracion;
  String formato;
  String presentacion;
  String laboratorio;
  String categoria;
  int stock;
  double precioVenta;
  String proveedor;

  Product({
    this.id, 
    required this.nombreComercial,
    required this.nombreGenerico,
    required this.concentracion,
    required this.formato,
    required this.presentacion,
    required this.laboratorio,
    required this.categoria,
    required this.stock,
    required this.precioVenta,
    required this.proveedor
  });
  
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nombreComercial': nombreComercial,
      'nombreGenerico': nombreGenerico,
      'concentracion': concentracion,
      'formato': formato,
      'presentacion': presentacion,
      'laboratorio': laboratorio,
      'categoria': categoria,
      'stock': stock,
      'precioVenta': precioVenta,
      'proveedor': proveedor
    };
  }

  factory Product.fromMap(Map<String, dynamic> map){
    return Product(
      id: map['id'],
      nombreComercial: map['nombreComercial'],
      nombreGenerico: map['nombreGenerico'],
      concentracion: map['concentracion'],
      formato: map['formato'],
      presentacion: map['presentacion'],
      laboratorio: map['laboratorio'],
      categoria: map['categoria'],
      stock: map['stock'],
      precioVenta: map['precioVenta'],
      proveedor: map['proveedor']
    );
  }

  Product copyWith({int? stock, double? precioVenta}) {
    return Product(
      id: id,
      nombreComercial: nombreComercial,
      nombreGenerico: nombreGenerico,
      concentracion: concentracion,
      formato: formato,
      presentacion: presentacion,
      laboratorio: laboratorio,
      categoria: categoria,
      stock: stock ?? this.stock,
      precioVenta: precioVenta ?? this.precioVenta,
      proveedor: proveedor,
    );
  }
}