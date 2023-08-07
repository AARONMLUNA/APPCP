import 'package:flutter/material.dart';
import 'package:qr_bar_code_flutter/src/http/http_provider.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';

final String appName = 'Contadero';
final String licence = 'App_PedidosMovil';

Widget loginLogo() {
  return SizedBox(
    child: SvgPicture.asset('assets/logo.svg'),
    height: 100.0,
    width: 200.0,
  );
}

Widget mainAppBar(String titulo) {
  return DaMainAppBar(
    title: appBarTitle(titulo),
    // actions: ['Otro 1', 'Otro 2'].toList(),
    onSelected: _menuClick,
    avatar: CircleAvatar(backgroundImage: AssetImage('assets/avatar.png')),
  );
}

String appBarTitle(String titulo) {
  return titulo.isEmpty ? appName : titulo;
}

Future<void> _menuClick(String value, BuildContext context) async {
  switch (value) {
    case 'Cerrar Sesión':
      final httpProv = new HttpProvider();
      await httpProv.logOut();

      SessionProvider prov = new SessionProvider();
      prov.reset();
      Navigator.pushReplacementNamed(context, 'login');
      break;
    default:
      print(value);
      break;
  }
}
