import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_bar_code_flutter/src/models/articulo_model.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';
import 'package:qr_bar_code_flutter/src/widgets/navbar.dart';
import 'package:qr_bar_code_flutter/src/http/http_provider.dart';

class DetailPage extends StatefulWidget {
  final List<Articulo> articulos;
  final String myID;
  DetailPage(this.articulos, this.myID);

  @override
  _DetailPageState createState() => _DetailPageState(articulos, myID);
}

class _DetailPageState extends State<DetailPage> {
  List<Articulo> articulos;
  String myID = "";
  _DetailPageState(this.articulos, this.myID);
  final TextEditingController _controllerArt = TextEditingController();
  String _codigoDeBarras = "";
  String _planeador = "";
  bool _saving = false;
  

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controllerArt.text = '';
    _codigoDeBarras = articulos.first.articulo.toString();
    _planeador = articulos.first.sugeridoPlaneador.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarCustom("Sugerido Bodega", true, true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              child: SizedBox(
                height: 48.0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controllerArt,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Sugerido Bodega',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.0,
                      height: 48.0,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          _sendCantidad();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //_getMultipleRenglon( "Cantidad", index.cantidad.toString()),
                        // _getMultipleRenglon("Cantidad Pendiente", index.cantidadPendiente.toString()),

                        _getMultipleRenglon("Código de Barras",
                            _codigoDeBarras),
                        _getMultipleRenglon("Planeador",
                           _planeador),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMultipleRenglon(String value1, String? value2) {
    if (value2 == null || value2 == "null") {
      return Text("");
    }
    return Expanded(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Expanded(
                child: Text(
                  value1,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  value2,
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  _sendCantidad() async {
    setState(() {
      _saving = true;
    });

    HttpProvider httpProvider = HttpProvider();
    var res = await httpProvider.spWebBodegaSugerirCompra(
        articulos[0].articulo.toString(),
        articulos[0].sugeridoPlaneador.toString(),
        _controllerArt.text.toString(),
        articulos[0].proveedor.toString(),
        articulos[0].almacen.toString(),
        articulos[0].unidad.toString(),
        _scaffoldKey);
    log("soy el res:" + res[0].okRef.toString());
    try {
      if (res.isNotEmpty && res.length > 0) {
        if (res[0].okRef == null) {
          DAToast(_scaffoldKey, "Movimiento afectado exitosamente!");
          setState(() {
            _saving = false;
            Navigator.pop(context);
          });
        } else {
          String mensaje = res[0].okRef.replaceAll('<BR>', "\n");
          DAToast(_scaffoldKey, mensaje);
          setState(() {
            _saving = false;
          });
        }
      } else {
        DAToast(_scaffoldKey, "Sin Resultados");
        setState(() {
          _saving = false;
        });
      }
    } catch (e) {
      setState(() {
        _saving = false;
      });
    }
  }
}
