import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_flutter/src/models/articulo_model.dart';
import 'package:qr_bar_code_flutter/src/models/desembarque_model.dart';
import 'package:qr_bar_code_flutter/src/models/login_model.dart';
import 'package:qr_bar_code_flutter/src/models/response_model.dart';
import 'package:qr_bar_code_flutter/src/models/rol_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_bar_code_flutter/src/models/session_model.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'http_interceptor.dart';
import 'http_retry_policy.dart';
import 'package:http/http.dart' as https;
// import 'http_routes.dart';

class HttpProvider {
  //SessionProvider prefs = new SessionProvider();
  final prefs = new SessionProvider();
  //String _url = '3.92.119.99:8096';
  //String _url = 'b3903.online-server.cloud:8080';
  String _url = '192.168.0.184:8001';
  String _db = 'CPARRAS';
  //String _db = 'RTorres';

  bool _cargando = false;

  getHeaders(SessionProvider prefs) {
    return {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json; charset=utf-8',
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      'Authorization': 'Bearer ' + prefs.authToken!,
    };
  }

  getHeadersMultipart(SessionProvider prefs) {
    return {
      'Access-Control-Allow-Origin': '*',
      "Content-Type": "multipart/form-data",
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      'Authorization': 'Bearer ' + prefs.authToken!,
    };
  }

  final _client = HttpClientWithInterceptor.build(interceptors: [
    // Interceptor(),
  ]);

  String getEndPoinds(String sp) {
    switch (sp) {
      case 'spWebPlaneadorSugeridoArticulo':
        return 'api/' + _db + '/sp/spWebPlaneadorSugeridoArticulo';

      case 'spWebBodegaSugerirCompra':
        return 'api/' + _db + '/sp/spWebBodegaSugerirCompra';

      case 'spWebUsuarioRol':
        return 'api/' + _db + '/sp/spWebUsuarioRol';

      case 'spAppUpdateToken':
        return 'api/' + _db + '/sp/spAppUpdateToken';

      case 'spWebRolApp':
        return 'api/' + _db + '/sp/spWebRolApp';

      case 'spAppUsuarioValidar':
        return 'api/' + _db + '/sp/spAppUsuarioValidar';

      default:
        return '';
    }
  }

  final _clientInterceptor = HttpClientWithInterceptor.build(
    interceptors: [
      Interceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  Future test() async {
    var res;
    try {
      var apiUri = prefs.apiUri;
      final Uri loginUri = Uri.parse(apiUri! + "/Help");

      res = await _client.get(loginUri).timeout(Duration(seconds: 5));
    } catch (e) {
      throw "Uri Inválida.";
    }
    return res;
  }

  Future login(LoginRequestModel requestModel) async {
    var res;
    try {
      final Uri loginUri =
          Uri.parse("http://" + _url + "/api/" + _db + "/loginUsuario");
      //final String data = grantPassword(credenciales, licence);
      res = await _client
          .post(
            loginUri,
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json',
              "Access-Control-Allow-Headers": "Content-Type",
              "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: jsonEncode(<String, dynamic>{
              'Username': requestModel.username!.toUpperCase(),
              'Password': requestModel.password!.toUpperCase(),
              'Proveedor': 0
            }),
          )
          .timeout(Duration(seconds: 25));
      //return LoginResponseModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      print("Servidor no válido. $e");
    }

    print("ResponseLogin: " + res.body);
    return res;
  }

  Future refresh(SessionModel credenciales) async {
    var res;
    try {
      var apiUri = prefs.apiUri;
      final Uri loginUri = Uri.parse(apiUri! + "/Login");
      final String data = grantRefresh(credenciales);

      res = await _client.post(
        loginUri,
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      ).timeout(Duration(seconds: 25));
    } catch (e) {
      throw e;
    }
    return res;
  }

  Future logOut() async {
    var res;
    try {
      var apiUri = prefs.apiUri;
      final Uri logOut = Uri.parse(apiUri! + "/LogOut");
      res = await _clientInterceptor.post(logOut,
          body: json.encode({"Estacion": prefs.session.estacion}),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(Duration(seconds: 5));
    } catch (e) {
      return false;
    }
    return (res.statusCode == 200) ? true : false;
  }

  Future<List<Response>> spAppUpdateToken(
      String? usuarioWeb, String token, int cerrar) async {
    //await prefs.validaRefresh();

    final url = Uri.http(_url, getEndPoinds('spAppUpdateToken'));

    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": usuarioWeb,
            "Token": token,
            //"Cerrar": cerrar
          }),
        )
        .timeout(Duration(seconds: 25));

    print(usuarioWeb);
    print(token);
    print(resp.body);

    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return [];
    }
  }

  Future<List<dynamic>?> httpGet(String uri, BuildContext context) async {
    var res;

    try {
      var apiUri = prefs.apiUri;
      final Uri uriInter = Uri.parse(apiUri! + uri);

      res = await _clientInterceptor.get(uriInter, headers: {
        "Content-Type": "application/json"
      }).timeout(Duration(seconds: 30));

      if (res.statusCode == 401) {
        prefs.reset();
        Navigator.pushReplacementNamed(context, 'login');
        throw "SESSION INVALIDA";
      }
    } catch (e) {
      throw e;
    }

    return jsonDecode(res.body);
  }

  //  MASERP

  Future<List<Articulo>> spWebPlaneadorSugeridoArticulo(
    String id,
    GlobalKey<ScaffoldState> _scaffoldKey,
  ) async {
    final url = Uri.http(_url, getEndPoinds('spWebPlaneadorSugeridoArticulo'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic?>{
            "Usuario": prefs.usuario,
            "CodigoBarras": id,
          }),
        )
        .timeout(Duration(seconds: 25));
    log("soy response");
    log(resp.body);

    if (resp.statusCode == 200) {
      return articuloFromJson(resp.body);
    } else {
      _showToast(resp.body, _scaffoldKey);
      return [];
    }
  }

  Future<List<Response>> spWebBodegaSugerirCompra(
      String articulo,
      String sugeridoPlaneador,
      String cantidad,
      String proveedor,
      String almacen,
      String unidad,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    log("articulo: " + articulo.toString());
    log("sugeridoPlaneador: " + sugeridoPlaneador.toString());
    log("cantidad: " + cantidad.toString());
    log("proveedor:" + proveedor.toString());
    log("almacen: " + almacen.toString());
    log("unidad: " + unidad.toString());

    final url = Uri.http(_url, getEndPoinds('spWebBodegaSugerirCompra'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "Usuario": prefs.usuario,
            "Articulo": articulo,
            "SugeridoPlaneador": sugeridoPlaneador,
            "Cantidad": cantidad,
            "Proveedor": proveedor,
            "Almacen": almacen,
            "Unidad": unidad,
          }),
        )
        .timeout(Duration(seconds: 25));

    log(resp.body);

    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      _showToast(resp.body, _scaffoldKey);
      return [];
    }
  }

  Future<List<Response>> spAppUsuarioValidar(LoginRequestModel requestModel,
      GlobalKey<ScaffoldState> _scaffoldKe) async {
    //await prefs.validaRefresh();

    final url = Uri.http(_url, getEndPoinds('spAppUsuarioValidar'));

    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "Usuario": requestModel.username,
            "Contrasena": requestModel.password,
            "Proveedor": 0
          }),
        )
        .timeout(Duration(seconds: 25));
    log("resp.body");
    print(resp.body);

    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return [];
    }
  }

  Future<List<Rol>> spWebRolApp(
      String? webUsuario, GlobalKey<ScaffoldState> _scaffoldKey) async {
    final url = Uri.http(_url, getEndPoinds('spWebRolApp'));
    log("aqui si entro");
    log(url.toString());
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic?>{"WebUsuario": webUsuario}),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return rolFromJson(resp.body);
    } else {
      _showToast(resp.body, _scaffoldKey);
      return [];
    }
  }

  _showToast(dynamic resp, GlobalKey<ScaffoldState> _scaffoldKey) {
    try {
      Response res = responseFromJsonOne(resp);
      String mensaje = res.mensaje!.replaceAll('<BR>', "\n");
      DAToast(_scaffoldKey, mensaje);
    } catch (e) {
      DAToast(_scaffoldKey, "Error al hacer la consulta");
    }
  }
}
