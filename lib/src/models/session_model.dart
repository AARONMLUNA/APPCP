import 'dart:convert';

SessionModel sessionModelFromJsonString(String str) => SessionModel.fromJson(json.decode(str));
SessionModel sessionModelFromJson(Map<String, dynamic> json) =>
    SessionModel.fromJson(json);
SessionModel sessionModelFromLogin(Map<String, dynamic> json) =>
    SessionModel.fromJsonLogin(json);

Map<String, dynamic> sessionModelToJson(SessionModel data) => data.toJson();
String sessionModelToJsonString(SessionModel data) => json.encode(data.toJson());

String grantPassword(SessionModel data) =>
    "username=${data.username}&password=${data.password}&grant_type=password";
String grantRefresh(SessionModel data) =>
    "refresh_token=${data.refresh}&grant_type=refresh_token";

class SessionModel {
  SessionModel({
    this.username,
    this.password,
    this.access,
    this.refresh,
    this.expires,
    this.estacion,
  });

  String? username;
  String? password;
  String? access;
  String? refresh;
  DateTime? expires;
  String? estacion;

  factory SessionModel.fromJsonLogin(Map<String, dynamic> json) {
    dynamic source = json["expires_in"];
    DateTime now = new DateTime.now();
    DateTime after = now.add(new Duration(seconds: source));

    return SessionModel(
      username: json["eMail"],
      password: json["Contrasena"],
      access: json["access_token"],
      refresh: json["refresh_token"],
      expires: after,
      estacion: json["Estacion"],
    );
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    int timestamp = json["expires_in"];
    DateTime expires = new DateTime.fromMillisecondsSinceEpoch(timestamp);

    return SessionModel(
      username: json["eMail"],
      password: json["Contrasena"],
      access: json["access_token"],
      refresh: json["refresh_token"],
      expires: expires,
      estacion: json["Estacion"],
    );
  }

  Map<String, dynamic> toJson() {
    DateTime fecha = (expires) ?? new DateTime.now();
    int timestamp = fecha.millisecondsSinceEpoch;

    Map<String, dynamic> json = {
      "eMail": username,
      "Contrasena": password,
      "access_token": access,
      "refresh_token": refresh,
      "expires_in": timestamp,
      "Estacion": estacion,
    };

    return json;
  }
}
