// To parse this JSON data, do
//
//     final facturacion = facturacionFromJson(jsonString);

import 'dart:convert';

List<Facturacion> facturacionFromJson(String str) => List<Facturacion>.from(
    json.decode(str).map((x) => Facturacion.fromJson(x)));

String facturacionToJson(List<Facturacion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Facturacion {
  Facturacion({
    this.cliente,
    this.razonSocial,
    this.rfc,
    this.responsable,
    this.eMail,
    this.claveUsoCfdi,
    this.usoCfdiDesc,
    this.infoFormaPago,
  });

  String? cliente;
  String? razonSocial;
  String? rfc;
  dynamic? responsable;
  String? eMail;
  dynamic? claveUsoCfdi;
  dynamic? usoCfdiDesc;
  dynamic? infoFormaPago;

  factory Facturacion.fromJson(Map<String, dynamic> json) => Facturacion(
        cliente: json["Cliente"] ?? "",
        razonSocial: json["RazonSocial"] ?? "",
        rfc: json["RFC"] ?? "",
        responsable: json["Responsable"] ?? "",
        eMail: json["eMail"] ?? "",
        claveUsoCfdi: json["ClaveUsoCFDI"] ?? "",
        usoCfdiDesc: json["UsoCFDIDesc"] ?? "",
        infoFormaPago: json["InfoFormaPago"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Cliente": cliente ?? "",
        "RazonSocial": razonSocial ?? "",
        "RFC": rfc ?? "",
        "Responsable": responsable ?? "",
        "eMail": eMail ?? "",
        "ClaveUsoCFDI": claveUsoCfdi ?? "",
        "UsoCFDIDesc": usoCfdiDesc ?? "",
        "InfoFormaPago": infoFormaPago ?? "",
      };
}
