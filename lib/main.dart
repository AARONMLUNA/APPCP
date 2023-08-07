import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_bar_code_flutter/src/config_app/login_page.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';
import 'package:qr_bar_code_flutter/src/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = new SessionProvider();
  await session.initPrefs();
  WidgetsFlutterBinding.ensureInitialized();
 
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> messagerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  final SessionProvider prov = new SessionProvider();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey[900],
      statusBarIconBrightness: Brightness.light,
      //statusBarBrightness: Brightness.dark,
      //systemNavigationBarDividerColor: Colors.pink,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    final _prov = new SessionProvider();

    print(_prov.initialPage);

    String _initial = (_prov.authToken != "") ? _prov.initialPage! : 'login';
    ;

    Color? _primaryColor = Color(0xfff04521);
    // (_prov.authToken  != "") ? 'tabs' : 'login';
    //String _initial = (false) ? 'home' : 'login';

    return

    CupertinoApp(
        title: 'MAS ERP',
        navigatorKey: navigatorKey,
        //scaffoldMessengerKey: messagerKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          // AppLocalizations.delegate, // remove the comment for this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('es', 'ES')],
        theme: CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xfff04521),
          primaryContrastingColor: Color(0xfff04521),
          barBackgroundColor: CupertinoColors.black,
          scaffoldBackgroundColor: CupertinoColors.black,
          textTheme: new CupertinoTextThemeData(
            primaryColor: Color(0xfff04521),

            textStyle: TextStyle(color: CupertinoColors.white),
            // ... here I actually utilised all possible parameters in the constructor
            // as you can see in the link underneath
          ),
        ),
        home: LoginPage(),
        initialRoute: _initial,
        //  initialRoute: 'recepcion',
        routes: getApplicationRoutes(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => LoginPage());
        },
      );

  }

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
