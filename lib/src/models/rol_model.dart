// To parse this JSON data, do
//
//     final rol = rolFromJson(jsonString);

import 'dart:convert';

List<Rol> rolFromJson(String str) =>
    List<Rol>.from(json.decode(str).map((x) => Rol.fromJson(x)));

String rolToJson(List<Rol> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String rolModelToJsonString(Rol data) => json.encode(data.toJson());

Rol rolModelFromJsonString(String str) => Rol.fromJson(json.decode(str));

class Rol {
  Rol(
      {this.usuario,
      this.appEmbarqueAsignarPosicion,
      this.appEmbarqueSurtir,
      this.appEmbarqueAuditar,
      this.appEmbarqueEmbarcar,
      this.appEmbarqueEntregar,
      this.appEmbarqueDesembarcar,
      this.appCargarRecoleccion,
      this.appEmbacarRecoleccion,
      this.appTecnicos,
      this.rol,
      this.appAutCompra});

  String? usuario;
  String? rol;
  bool? appEmbarqueAsignarPosicion;
  bool? appEmbarqueSurtir;
  bool? appEmbarqueAuditar;
  bool? appEmbarqueEmbarcar;
  bool? appEmbarqueEntregar;
  bool? appEmbarqueDesembarcar;
  bool? appCargarRecoleccion;
  bool? appEmbacarRecoleccion;
  bool? appTecnicos;
  bool? appAutCompra;

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        usuario: json["Usuario"] == null ? "" : json["Usuario"],
        rol: json["Rol"] == null ? "" : json["Rol"],
        appEmbarqueAsignarPosicion: json["AppEmbarqueAsignarPosicion"] == null
            ? false
            : json["AppEmbarqueAsignarPosicion"],
        appEmbarqueSurtir: json["AppEmbarqueSurtir"] == null
            ? false
            : json["AppEmbarqueSurtir"],
        appEmbarqueAuditar: json["AppEmbarqueAuditar"] == null
            ? false
            : json["AppEmbarqueAuditar"],
        appEmbarqueEmbarcar: json["AppEmbarqueEmbarcar"] == null
            ? false
            : json["AppEmbarqueEmbarcar"],
        appEmbarqueEntregar: json["AppEmbarqueEntregar"] == null
            ? false
            : json["AppEmbarqueEntregar"],
        appEmbarqueDesembarcar: json["AppEmbarqueDesembarcar"] == null
            ? false
            : json["AppEmbarqueDesembarcar"],
        appCargarRecoleccion: json["AppCargarRecoleccion"] == null
            ? false
            : json["AppCargarRecoleccion"],
        appEmbacarRecoleccion: json["AppEmbacarRecoleccion"] == null
            ? false
            : json["AppEmbacarRecoleccion"],
        appTecnicos: json["AppTecnicos"] == null ? false : json["AppTecnicos"],
        appAutCompra: json["AppAutCompra"] == null ? false : json["AppAutCompra"],
      );

  Map<String, dynamic> toJson() => {
        "Usuario": usuario == null ? null : usuario,
        "Rol": rol == null ? "" : rol,
        "AppEmbarqueAsignarPosicion": appEmbarqueAsignarPosicion == null
            ? null
            : appEmbarqueAsignarPosicion,
        "AppEmbarqueSurtir":
            appEmbarqueSurtir == null ? null : appEmbarqueSurtir,
        "AppEmbarqueAuditar":
            appEmbarqueAuditar == null ? null : appEmbarqueAuditar,
        "AppEmbarqueEmbarcar":
            appEmbarqueEmbarcar == null ? null : appEmbarqueEmbarcar,
        "AppEmbarqueEntregar":
            appEmbarqueEntregar == null ? null : appEmbarqueEntregar,
        "AppEmbarqueDesembarcar":
            appEmbarqueDesembarcar == null ? null : appEmbarqueDesembarcar,
        "AppCargarRecoleccion":
            appCargarRecoleccion == null ? null : appCargarRecoleccion,
        "AppEmbacarRecoleccion":
            appEmbacarRecoleccion == null ? null : appEmbacarRecoleccion,
        "AppTecnicos": appTecnicos == null ? null : appTecnicos,
        
        "AppAutCompra": appAutCompra == null ? null : appAutCompra,
      };
}
