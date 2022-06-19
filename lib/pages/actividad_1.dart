// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movil2/styles/colors/colores.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum() async {
  var url = 'http://desarrollovan-tis.dedyn.io:4030/GetImagesCarousel';

  Map data = {'idChannel': '1'};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, body: body);

  var units = (json.decode(response.body) as Map<String, dynamic>);

  if (response.statusCode == 200) {
    return Album.fromJson(units);
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final List<dynamic> pilaImagen;

  const Album({required this.pilaImagen});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      pilaImagen: json['dtoImageCarousels'],
    );
  }
}

class Imagen {
  final String url;
  final String accion;
  final String nombre;

  Imagen({
    required this.url,
    required this.accion,
    required this.nombre,
  });

  factory Imagen.fromJson(Map<String, dynamic> json) {
    return Imagen(
      url: json['url'],
      nombre: json['nombre'],
      accion: json['accion'],
    );
  }
}

class MyApp_Actividad1 extends StatefulWidget {
  const MyApp_Actividad1({Key? key}) : super(key: key);

  @override
  _Actividad_1 createState() {
    return _Actividad_1();
  }
}

class _Actividad_1 extends State<MyApp_Actividad1> {
  Future<Album>? _futureAlbum;
  late PageController _pageController;

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    _futureAlbum = createAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ],
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum();
            });
          },
          child: const Text('Reintentar'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    List<String> images = [];
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var pila = snapshot.data!.pilaImagen;
          for (var i = 0; i < pila.length; i++) {
            Imagen nuevaImagen = Imagen.fromJson(
              pila[i] as Map<String, dynamic>,
            );
            images.insert(0, nuevaImagen.url);
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 5,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: PageView.builder(
                    itemCount: images.length,
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(
                        () {
                          activePage = page;
                        },
                      );
                    },
                    itemBuilder: (context, pagePosition) {
                      bool active = pagePosition == activePage;
                      return slider(images, pagePosition, active);
                    },
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

AnimatedContainer slider(images, pagePosition, active) {
  double margin = active ? 5 : 10;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
    margin: EdgeInsets.all(
      margin,
    ),
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.contain,
        image: NetworkImage(
          images[pagePosition],
        ),
      ),
    ),
  );
}
