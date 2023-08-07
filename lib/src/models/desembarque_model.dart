// To parse this JSON data, do
//
//     final desembarque = desembarqueFromJson(jsonString);

import 'dart:convert';

List<Desembarque> desembarqueFromJson(String str) => List<Desembarque>.from(json.decode(str).map((x) => Desembarque.fromJson(x)));

String desembarqueToJson(List<Desembarque> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Desembarque {
    Desembarque({
        this.modulo,
        this.moduloId,
        this.referencia,
        this.chofer,
        this.choferNombre,
        this.vehiculo,
        this.descripcion1,
        this.placas,
        this.atencion,
        this.observaciones,
        this.desembarqueTotal,
        this.movReferencia,
    });

    String? modulo;
    int? moduloId;
    String? referencia;
    String? chofer;
    String? choferNombre;
    String? vehiculo;
    String? descripcion1;
    String? placas;
    String? atencion;
    String? observaciones;
    int? desembarqueTotal;
    String? movReferencia;

    factory Desembarque.fromJson(Map<String, dynamic> json) => Desembarque(
        modulo: json["Modulo"] == null ? "" : json["Modulo"],
        moduloId: json["ModuloID"] == null ? "" : json["ModuloID"],
        referencia: json["Referencia"] == null ? "" : json["Referencia"],
        chofer: json["Chofer"] == null ? "" : json["Chofer"],
        choferNombre: json["ChoferNombre"] == null ? "" : json["ChoferNombre"],
        vehiculo: json["Vehiculo"] == null ? "" : json["Vehiculo"],
        descripcion1: json["Descripcion1"] == null ? "" : json["Descripcion1"],
        placas: json["Placas"] == null ? "" : json["Placas"],
        atencion: json["Atencion"] == null ? "" : json["Atencion"],
        observaciones: json["Observaciones"] == null ? "" : json["Observaciones"],
        desembarqueTotal: json["DesembarqueTotal"] == null ? "" : json["DesembarqueTotal"],
        movReferencia: json["MovReferencia"] == null ? "" : json["MovReferencia"],
        
    );

    Map<String, dynamic> toJson() => {
        "Modulo": modulo == null ? null : modulo,
        "ModuloID": moduloId == null ? null : moduloId,
        "Referencia": referencia == null ? null : referencia,
        "Chofer": chofer == null ? null : chofer,
        "ChoferNombre": choferNombre == null ? null : choferNombre,
        "Vehiculo": vehiculo == null ? null : vehiculo,
        "Descripcion1": descripcion1 == null ? null : descripcion1,
        "Placas": placas == null ? null : placas,
        "Atencion": atencion == null ? null : atencion,
        "Observaciones": observaciones == null ? null : observaciones,
        "DesembarqueTotal": desembarqueTotal == null ? null : desembarqueTotal,
    };
}
