import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:qr_bar_code_flutter/src/models/login_model.dart';
import 'package:qr_bar_code_flutter/src/models/response_model.dart';
import 'package:qr_bar_code_flutter/src/models/rol_model.dart';
import 'package:qr_bar_code_flutter/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_flutter/src/http/http_provider.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Para agilizar snackbar y loading
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _prov = new SessionProvider();

  bool _saving = false; // Para estatus loading
  late LoginRequestModel requestModel;
  Future<LoginResponseModel>? responseModel;
  final httpProv = new HttpProvider();

  // Form controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  // API
  TextEditingController _apiController = new TextEditingController();
  void onValueChange() {
    setState(() {
      _apiController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiController.text = _prov.apiUri!;
    _apiController.addListener(onValueChange);
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      //floatingActionButton: _configAPI(),
      children: <Widget>[
        _background(),
        _loginForm(),
      ],
    );
  }

  // API
  Widget _configAPI() {
    return FloatingActionButton(
      child: Icon(
        _prov.connected ? Icons.cloud_done : Icons.cloud_off,
        color: Colors.white70,
        size: 30.0,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: _apiDialog,
    );
  }

  void _apiDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DAInputDialog(
            title: 'Configurar app',
            subtitle: 'Ingrese Uri de API First',
            okText: 'Conectar',
            input: DAInput(
              padding: 0.0,
              tipo: 'url',
              controller: _apiController,
              onSaved: (value) {
                _prov.apiUri = _apiController.text;
              },
            ),
            onPressed: _validaAPI,
          );
        });
  }

  Future<void> _validaAPI() async {
    try {
      Navigator.of(context).pop();
      setState(() {
        _prov.connected = false;
        _prov.apiUri = _apiController.text;
        _saving = true;
      }); // Loading start

      final httpProv = new HttpProvider();
      var res = await httpProv.test();
      _prov.connected = (res.statusCode == 200);

      String msg = (res.statusCode == 200)
          ? 'Conexión Exitosa'
          : 'Error de servidor: ${res.reasonPhrase.toString()}';
      DAToast(_scaffoldKey, msg);

      setState(() => _saving = false); // L
    } catch (e) {
      // ignore: unused_element
      setState(() {
        _saving = false; // Loading end
        _prov.connected = false;
        DAToast(_scaffoldKey, e.toString());
      });
    }
  }

  // Fondo
  Widget _background() {
    // Obtiene datos de main.dart, logo y nombre de app
    return DaBackground(
      label: appName,
      image: Image.asset(
        "assets/logoParas.png",
        height: 200,
        width: 270,
        fit: BoxFit.fill,
      ),
    );
  }

  // Login
  Widget _loginForm() {
    return DaFloatingForm(
      title: 'Ingresa con tu cuenta',
      formKey: _formKey,
      children: <Widget>[
        DAInput(
          tipo: 'email',
          label: 'Usuario',
          controller: _emailController,
          onSaved: (value) {
            requestModel.username = value;
          },
        ),
        SizedBox(height: 20.0),
        DAInput(
          tipo: 'password',
          label: 'Contraseña',
          controller: _passController,
          onSaved: (value) {
            requestModel.password = value;
          },
        ),
        SizedBox(height: 40.0),
        // Login Button
        DAButton(
          label: 'Ingresar',
          // onPressed: () async => await _login(),
          onPressed: () => _login(),
        ),
      ],
    );
  }

  _login() async {
    final form = _formKey.currentState!;
    form.save();
    setState(() {
      _saving = true;
    });
    try {
      final httpProv = new HttpProvider();
      var res = await httpProv.login(requestModel);
      setState(() => _saving = false); // Loading end
      if (res.statusCode == 200) {
        //almacenar refresh token y access token
        var jwt = res.body;
        setState(() => _saving = false);
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        LoginResponseModel responseModel = loginResponseFromJson(jwt);
        _prov.authToken = responseModel.authToken!;
        _prov.usuario = requestModel.username!;

        print("TOKEN");
        _validarUsuario(requestModel);

      } else {
        setState(() => _saving = false);
        DAToast(
            _scaffoldKey, "Las credenciales proporcionadas no son válidas.");
      }
    } catch (e) {
      setState(() => _saving = false); // Loading end
      DAToast(_scaffoldKey, e.toString());
    }
  }

  _setToken(String? user, String? token) async {
    if (token == null) {
      token = "";
      setState(() => _saving = true);
      // _alertTokenError(context);
    }

    int cerrar = 0;

    List<Response> lista = await httpProv.spAppUpdateToken(user, token, cerrar);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lista.isNotEmpty) {
      _getRole(requestModel.username);
      print(requestModel.username);
      /*Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));*/
    } else {
      prefs.clear();
    }
  }

  _closeSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //await preferences.clear();
    preferences.remove('AuthToken');
    preferences.remove('Usuario');
    _comprobarClose();
  }

  _comprobarClose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('Usuario'));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    );
  }

  _openSnackBarWithoutAction(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: Duration(seconds: 5),
    );
    // Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> _validarUsuario(LoginRequestModel requestModel) async {
    setState(() {
      _saving = true;
    });
    // try {
    final httpProv = new HttpProvider();
    var res = await httpProv.spAppUsuarioValidar(requestModel, _scaffoldKey);
    setState(() => _saving = false); // Loading end
    log("spAppUsuarioValidar");
    log(res.toString());
    if (res.isNotEmpty) {
      _getRole(requestModel.username);
    } else {
      setState(() => _saving = false);
      DAToast(_scaffoldKey, "Error con el Rol");
    }
    /*  } catch (e) {
      setState(() => _saving = false); // Loading end
      DAToast(_scaffoldKey, e.toString());
    }*/
  }

  Future<void> _getRole(String? username) async {
    setState(() {
      _saving = true;
    });
    // try {
    final httpProv = new HttpProvider();
    var res = await httpProv.spWebRolApp(username, _scaffoldKey);
    setState(() => _saving = false); // Loading end
    if (res[0].usuario != null) {
      //almacenar refresh token y access token
      _prov.rol = res[0];

      //Rol rol = _prov.rol;

      // print(rol.usuario);

      //Rol rol = _prov.rol;

      // print(rol.usuario);
      print("Hello");

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      setState(() => _saving = false);
      DAToast(_scaffoldKey, "Error con el Rol");
    }
    /*  } catch (e) {
      setState(() => _saving = false); // Loading end
      DAToast(_scaffoldKey, e.toString());
    }*/
  }
}
