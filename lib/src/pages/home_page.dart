import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:qr_bar_code_flutter/src/http/http_provider.dart';
import 'package:qr_bar_code_flutter/src/models/articulo_model.dart';
import 'package:qr_bar_code_flutter/src/models/desembarque_model.dart';
import 'package:qr_bar_code_flutter/src/pages/detail_page.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';
import 'package:qr_bar_code_flutter/src/utils/utils.dart';
import 'package:qr_bar_code_flutter/src/widgets/navbar.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:qr_bar_code_flutter/src/pages/scan_page_recepcion_mercancia.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagenAppBar = "assets/card3.jpg";
  String imagenAppBar2 = "assets/card4.jpg";
  String logo = "assets/logoParas.png";
  String? qrCodeResult;
  int camera = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  final codigoControllerArt = TextEditingController();
  final httpProv = new HttpProvider();
  Desembarque? embarque;

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      children: [_getBody()],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _getBody() {
    return Scaffold(
      appBar: NavBarCustom("Verificador de Precios", false, true),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Card(
                elevation: 10, // Define la elevación (altura) del Card
                shadowColor: Color(
                    0xFFF04521), // Hace la sombra más intensa y semi-transparente
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), // Define el color de la sombra
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Padding(
                    padding:
                        EdgeInsets.all(10.0), // Define el valor del relleno
                    child: Image.asset(
                      logo,
                      fit: BoxFit.scaleDown,
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Stack(
                children: <Widget>[
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
                      child: Row(
                        children: [
                          Expanded(flex: 8, child: _crearCodigoInput()),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              tooltip: 'Enviar',
                              onPressed: () {
                                setState(() {
                                  _buscarArt();
                                });
                              },
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: IconButton(
                                color: Colors.black,
                                icon: Icon(MaterialCommunityIcons.qrcode_scan),
                                onPressed: () async {
                                  ScanResult codeSanner =
                                      await BarcodeScanner.scan(
                                    options: ScanOptions(
                                      useCamera: camera,
                                    ),
                                  );
                                  //barcode scnner
                                  setState(() {
                                    qrCodeResult = codeSanner.rawContent;
                                    codigoControllerArt.text =
                                        codeSanner.rawContent;
                                    _buscarArt();
                                  });

                                  //_getDetalle(codeSanner.rawContent);
                                },
                              )),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 15,
                    margin: EdgeInsets.all(10),
                    shadowColor: Color(0xfff04521),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _crearBoton() {
    return FloatingActionButton(
        onPressed: () async => {_cerrarSesion(context)},
        child: Icon(Icons.close, color: Colors.black),
        elevation: 0,
        backgroundColor: Color.fromRGBO(250, 236, 228, 1));
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    final httpProv = new HttpProvider();
    await httpProv.logOut();
    SessionProvider prov = new SessionProvider();
    prov.reset();
    Navigator.pushReplacementNamed(context, 'login');
  }

  Widget _crearCodigoInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.text,
        controller: codigoControllerArt,
        onSubmitted: (String valor) {
          setState(() {
            codigoControllerArt.text = valor;
            _buscarArt();
          });
        },
        onChanged: (String valor) {
          setState(() {
            codigoControllerArt.text = valor;
            _buscarArt();
          });
        },
        decoration: InputDecoration(
          hintText: 'Escanear QR',
          labelText: 'Escanear QR',
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.brown),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.brown),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.brown),
          ),
        ),
      ),
    );
  }

  Future<void> _buscarArt() async {
    if (codigoControllerArt.text.isNotEmpty) {
      setState(() {
        _saving = true;
      });
      var res = await httpProv.spWebPlaneadorSugeridoArticulo(
          codigoControllerArt.text, _scaffoldKey);
      if (res.isNotEmpty && res.length > 0) {
        if (res[0].articulo != null) {
          String id = codigoControllerArt.text.toString();
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ScanPageRecepcionMercancia(res)));
          getDialog(res);
          setState(() {
            _saving = false;
            codigoControllerArt.text = "";
          });
        } else {
          DAToast(_scaffoldKey, "Sin Resultados");
          setState(() {
            _saving = false;
          });
          print("Error en la Consulta");
        }
      } else {
        DAToast(_scaffoldKey, "Sin Resultados");
        setState(() {
          _saving = false;
        });
      }
    } else {
      DAToast(_scaffoldKey, "Se necesita un campo con Información");
      return null;
    }
  }

  void getDialog(List<Articulo> articulo) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(0),
        isDense: true,
        dialogType: DialogType.INFO,
        customHeader: SizedBox(child: Lottie.asset("assets/money.json")),
        showCloseIcon: true,
        closeIcon: Transform(
          transform: Matrix4.translationValues(15.0, -0.0, 0.0),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
        ),
        title: "VERIFICADOR DE PRECIOS" + " \n\n ",
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 2),
              child: Text(
                "Verificador de Precios",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5, left: 30, right: 30),
                    child: Text(
                      formatCurrency(articulo[0].precio!),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.w800),
                    )),
                Divider(
                  color: Colors.grey,
                  height: 10,
                )
              ],
            ),
            _getListDetail(articulo),
          ],
        ),
        //btnOkOnPress: () {
        //  _spAutorizacionModuloAPP(movimiento);
        //},
        //btnOkText: "Autorizar",
        btnCancelOnPress: () {},
        //btnOkIcon: Icons.check_circle,
        btnCancelText: "Cerrar",
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        })
      ..show();
  }

  Widget _getListDetail(List<Articulo> detalleList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: detalleList.length,
            itemBuilder: (context, i) {
              return _getCardDetail(detalleList[i]);
            },
          ),
        ),
      ],
    );
  }

  Widget _getCardDetail(Articulo detalle) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(color: Colors.white),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: new EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: SelectableText(
                                detalle.descripcion!,
                                style: TextStyle(
                                    color: Colors.green, fontSize: 19),
                              )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  width: 110,
                                  child: SelectableText(
                                    formatCurrency(detalle.precio!),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      child: SelectableText(
                                detalle.claveCompuCaja.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        Divider(
          height: 1,
          color: Colors.green,
        )
      ],
    );
  }
}
