class ArticuloData {
  final String articulo;
  final String descripcion1;
  final double cantidad;
  final double cantidadPendiente;
  final String mov;
  final String movID;
  final String ubicacion;
  final String almacen;
  final String usuario;

  ArticuloData(
      {required this.articulo,
      required this.descripcion1,
      required this.cantidad,
      required this.cantidadPendiente,
      required this.mov,
      required this.movID,
      required this.ubicacion,
      required this.almacen,
      required this.usuario});

  copyWith(
          {String? articulo,
          String? descripcion1,
          double? cantidad,
          double? cantidadPendiente,
          String? mov,
          String? movID,
          String? ubicacion,
          String? almacen,
          String? usuario}) =>
      ArticuloData(
          articulo: articulo ?? this.articulo,
          descripcion1: descripcion1 ?? this.descripcion1,
          cantidad: cantidad ?? this.cantidad,
          cantidadPendiente: cantidadPendiente ?? this.cantidadPendiente,
          mov: mov ?? this.mov,
          movID: movID ?? this.movID,
          ubicacion: ubicacion ?? this.ubicacion,
          almacen: almacen ?? this.almacen,
          usuario: usuario ?? this.usuario);
}
