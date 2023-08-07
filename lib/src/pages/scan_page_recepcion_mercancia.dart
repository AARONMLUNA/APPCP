import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:qr_bar_code_flutter/src/http/http_provider.dart';
import 'package:qr_bar_code_flutter/src/models/articulo_model.dart';
import 'package:qr_bar_code_flutter/src/models/response_model.dart';
import 'package:qr_bar_code_flutter/src/pages/home_page.dart';
import 'package:qr_bar_code_flutter/src/utils/DAWidgets.dart';
import 'package:qr_bar_code_flutter/src/widgets/card_swiper_car_widget.dart';
import 'package:qr_bar_code_flutter/src/widgets/navbar.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ScanPageRecepcionMercancia extends StatefulWidget {
  final List<Articulo> articulos;
  final String myID;
  ScanPageRecepcionMercancia(this.articulos, this.myID);

  @override
  _ScanPageRecepcionMercanciaState createState() =>
      _ScanPageRecepcionMercanciaState(articulos, myID);
}

class _ScanPageRecepcionMercanciaState
    extends State<ScanPageRecepcionMercancia> {
  List<Articulo> articulos;
  String myID = "";
  _ScanPageRecepcionMercanciaState(this.articulos, this.myID);

  late String qrCodeResult;
  int camera = -1;
  int _initialCard = 0;
  String _currentArt = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;

  bool backCamera = false;
  final httpProv = new HttpProvider();

  final TextEditingController _articuloController = TextEditingController();

  String imagenAppBar = "assets/card1.jpg";
  final folioController = TextEditingController();
  final nombreController = TextEditingController();
  final placaController = TextEditingController();
  final cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarCustom("Sugerido Bodega", true, true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Articulo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                  articulos[0].descripcion.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Código',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                articulos[0].claveCompuCaja.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  articulos[0].precio!.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Sugerido Bodega',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextField(
                                controller: _articuloController,
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                style: TextStyle(height: 1.3),
                                decoration: InputDecoration(
                                  hintText: '',
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  suffixIcon: IconButton(
                                    color: Color(0xfff04521),
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      setState(() {
                                        _sendCantidad();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cantidadController.text = '1';
  }

  _sendCantidad() async {
    setState(() {
      _saving = true;
    });

    var res = await httpProv.spWebBodegaSugerirCompra(
        articulos[0].articulo.toString(),
        articulos[0].sugeridoPlaneador.toString(),
        _articuloController.text,
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

  Future<void> _buscarCita() async {
    setState(() {
      _saving = true;
    });
    var res = await httpProv.spWebPlaneadorSugeridoArticulo(myID, _scaffoldKey);
    if (res.isNotEmpty && res.length > 0) {
      if (res[0] != null) {
        setState(() {
          articulos = res;
          _saving = false;
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
  }
}
