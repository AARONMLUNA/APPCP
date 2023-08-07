import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_flutter/src/models/articulo_model.dart';

class CardCarSwiper extends StatefulWidget {
  List<Articulo> articulos;
  int initial;
  CardCarSwiper({
    required this.articulos,
    required this.initial,
  });

  @override
  State<CardCarSwiper> createState() => _CardCarSwiperState(articulos, initial);
}

class _CardCarSwiperState extends State<CardCarSwiper> {
  _CardCarSwiperState(this.articulos, this.initial);
  final List<Articulo> articulos;
  late final int initial;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    print(initial.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topRight: Radius.circular(10.0)),
      ),
      child: Column(children: [
        Container(
            height: 130,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _getMultipleRenglon("Código de Barras",
                            ""),
                        _getMultipleRenglon("Planeador",
                            ""),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ]),
    );
  }

  Widget _getRenglon(String value1, String? value2) {
    if (value2 == null || value2 == "null") {
      return Text("");
    }
    return Container(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              value1,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value2,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(),
        ],
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
}
