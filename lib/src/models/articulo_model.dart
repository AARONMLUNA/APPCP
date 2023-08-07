// To parse this JSON data, do
//
//     final articulo = articuloFromJson(jsonString);

import 'dart:convert';

List<Articulo> articuloFromJson(String str) =>
    List<Articulo>.from(json.decode(str).map((x) => Articulo.fromJson(x)));

String articuloToJson(List<Articulo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Articulo {
  Articulo(
      {this.articulo,
      this.descripcion,
      this.cantidad,
      this.cantidadPendiente,
      this.mov,
      this.movID,
      this.ubicacion,
      this.almacen,
      this.usuario,
      this.sugeridoPlaneador,
      this.proveedor,
      this.unidad,
      this.decimales,
      this.precio,
      this.claveCompuCaja
      
      });

  String? articulo;
  String? descripcion;
  double? cantidad;
  double? cantidadPendiente;
  String? mov;
  String? movID;
  String? ubicacion;
  String? almacen;
  String? usuario;
  double? sugeridoPlaneador;
  String? proveedor;
  String? unidad;
  double? precio;
  int? decimales;
  String? claveCompuCaja;

  factory Articulo.fromJson(Map<String, dynamic> json) => Articulo(
        articulo: json["Articulo"] == null ? null : json["Articulo"],
        descripcion: json["Descripcion"] == null ? null : json["Descripcion"],
        cantidad: json["Cantidad"] == null ? 0 : json["Cantidad"],
        cantidadPendiente:
            json["CantidadPendiente"] == null ? 0 : json["CantidadPendiente"],
        mov: json["Mov"] == null ? "" : json["Mov"],
        movID: json["MovID"] == null ? "" : json["MovID"],
        ubicacion: json["Ubicacion"] == null ? "" : json["Ubicacion"],
        almacen: json["Almacen"] == null ? "" : json["Almacen"],
        usuario: json["Usuario"] == null ? "" : json["Usuario"],
        proveedor: json["Proveedor"] == null ? "" : json["Proveedor"],
        sugeridoPlaneador:
            json["SugeridoPlaneador"] == null ? 0 : json["SugeridoPlaneador"],
        unidad: json["Unidad"] == null ? "" : json["Unidad"],
        decimales: json["Decimales"] == null ? 0 : json["Decimales"],
        precio:
            json["Precio"] == null ? 0 : json["Precio"],
               claveCompuCaja:
            json["ClaveCompuCaja"] == null ? 0 : json["ClaveCompuCaja"],
      );

  Map<String, dynamic> toJson() => {
        "Articulo": articulo == null ? null : articulo,
        "Descripcion1": descripcion == null ? null : descripcion,
        "Cantidad": cantidad == null ? null : cantidad,
        "CantidadPendiente":
            cantidadPendiente == null ? null : cantidadPendiente,
        "Mov": mov == null ? null : mov,
        "MovID": movID == null ? null : movID,
        "Ubicacion": ubicacion == null ? null : ubicacion,
        "Almacen": almacen == null ? null : almacen,
        "Usuario": usuario == null ? null : usuario,
        "SugeridoPlaneador":
            sugeridoPlaneador == null ? null : sugeridoPlaneador,
        "Proveedor": proveedor == null ? null : proveedor,
        "Unidad": unidad == null ? null : unidad,
        "Decimales": decimales == null ? null : decimales,
        "Precio": precio == null ? null : precio,
        "ClaveCompuCaja": claveCompuCaja == null ? null : claveCompuCaja,
        
        
      };
}
