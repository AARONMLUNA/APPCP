import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_bar_code_flutter/src/pages/close_session_page.dart';
import 'package:qr_bar_code_flutter/src/pages/home_page.dart';

class NavBarCustom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String title;
  final bool back;
  final bool home;
  NavBarCustom(this.title, this.back, this.home);

  @override
  Widget build(BuildContext context) {
    String imagenAppBar = "assets/logoRtorres.png";

    return AppBar(
      title: Container(
        child: Text(
          this.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal 
              /*overflow: TextOverflow.ellipsis*/),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      centerTitle: true,
      automaticallyImplyLeading: back,
      actions: <Widget>[
        home
            ? Padding(
                padding:
                  const EdgeInsets.only(right: 20.0, bottom: 10, top: 10),
                child: IconButton(
                  color: Colors.white,
                  icon: FaIcon(FontAwesomeIcons.addressCard,color: Colors.white, size: 20,), 
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CloseSession()));
                  },
                ),
              )
            : Center()
      ],
      flexibleSpace: Container(
          child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topRight: Radius.circular(0.0)),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: /*Image.asset(
              imagenAppBar,
              fit: BoxFit.contain,
            ),*/
                Center(),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xfff04521),
                Color(0xfff04521),

              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      )),
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
    );
  }
}
