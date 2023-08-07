import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_bar_code_flutter/src/config_app/login_page.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';
import 'package:qr_bar_code_flutter/src/widgets/navbar.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';

class CloseSession extends StatefulWidget {
  CloseSession({Key? key}) : super(key: key);

  @override
  _CloseSessionState createState() => _CloseSessionState();
}

class _CloseSessionState extends State<CloseSession> {
  bool _saving = false;
  final _prov = new SessionProvider();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(isLoading: _saving, keyLoading: _scaffoldKey,
        // backgroundColor:  Color.fromRGBO(255, 255, 240, 1),
        children: [_getBody()]);
  }

  Widget _getBody() {
    return Stack(
      children: [
        /* Image.asset(
              "assets/backgroundRtorres.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              ),*/
        Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          //backgroundColor: Colors.transparent,

          appBar: NavBarCustom("Perfil de Usuario", true,false),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          getIconProfile(),
                          Divider(
                              height: 20,
                              color: CupertinoTheme.of(context)
                                  .primaryContrastingColor),
                          Text(_prov.usuario.toString(),
                              style: new TextStyle(
                                  color: Colors.blue[600], fontSize: 18),
                              textAlign: TextAlign.center),
                          Divider(
                              height: 20,
                              color: CupertinoTheme.of(context)
                                  .primaryContrastingColor),
                        ],
                      ),
                    ),
                  ),
                ),
                _botonBaja()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _botonBaja() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 7.0),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 8,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              highlightColor: Colors.transparent,
              onTap: () {
              _prov.reset();
              //Navigator.pop(context);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
             
              },
              child: Center(
                child: Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }

  Widget getIconProfile(){
     switch ("Usuario") {
      case "Usuario":
       return Icon(Icons.account_circle,size: 100,);
        //return Icon(Icons.handyman ,size: 100,);
      case "Jefe Mantenimiento":
        return Icon(Icons.handyman,size: 100,);

      case "Tecnico Mantenimiento":
        return Icon(Icons.hardware ,size: 100,);

      case "Gerente Mantenimiento":
        return Icon(Icons.check_circle ,size: 100,);
      default:
        return Icon(Icons.account_circle,size: 100,);
    }
  }
}
