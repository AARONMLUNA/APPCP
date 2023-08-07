import 'package:flutter/cupertino.dart';
import 'package:qr_bar_code_flutter/src/config_app/login_page.dart';
import 'package:qr_bar_code_flutter/src/pages/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    //'/'     : (BuildContext context) => HomePage(),
    'login': (BuildContext context) => LoginPage(),
    'home': (BuildContext context) => HomePage(),

    //'recepcion': (BuildContext context) => RecepcionPage(),
  };
}
