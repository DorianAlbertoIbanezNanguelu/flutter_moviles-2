// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/PetInfo.dart';
import '../models/InfoProducto.dart';
import '../styles/colors/colores.dart';

class MyApp_Actividad2 extends StatelessWidget {
  Future<ProductsInfo> getProducts() async {
    var url = Uri.parse(
        'http://desarrollovan-tis.dedyn.io:4030/GetProductsByIdSeller');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"idSeller": '1'}),
    );
    if (resp.statusCode == 200) {
      return productsInfoFromJson(resp.body);
    } else {
      throw Exception('Failed to load.');
    }
  }

  Future<PetItemInfo> getPets() async {
    var url =
        Uri.parse('http://desarrollovan-tis.dedyn.io:4030/GetPetTaxonomia');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"idChannel": '1'}),
    );
    if (resp.statusCode == 200) {
      return petItemInfoFromJson(resp.body);
    } else {
      throw Exception('Failed to load.');
    }
  }

  const MyApp_Actividad2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 10),
              child: Text(
                'Productos cerca',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            FutureBuilder(
              future: getPets(),
              builder: (ctx, AsyncSnapshot<PetItemInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return ListButtons(
                      pets: snapshot.data!.PetTaxonomias,
                      primary: Color_Selector.c_verde);
                }
              },
            ),
          ],
        ),
        FutureBuilder(
          future: getProducts(),
          builder: (ctx, AsyncSnapshot<ProductsInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ContainerProducts(
                  snapshot.data!.getProducts.response.docs,
                  primary: Color_Selector.c_verde,
                ),
              );
            }
          },
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 10),
              child: Text(
                'Servicios cerca',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            FutureBuilder(
              future: getPets(),
              builder: (ctx, AsyncSnapshot<PetItemInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return ListButtons(
                    pets: snapshot.data!.PetTaxonomias,
                    primary: Color_Selector.c_purpura,
                  );
                }
              },
            ),
          ],
        ),
        FutureBuilder(
          future: getProducts(),
          builder: (ctx, AsyncSnapshot<ProductsInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ContainerProducts(
                  snapshot.data!.getProducts.response.docs,
                  primary: Color_Selector.c_purpura,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class ListButtons extends StatefulWidget {
  final List<PetTax> pets;
  final Color primary;
  const ListButtons({
    Key? key,
    required this.pets,
    required this.primary,
  }) : super(key: key);

  @override
  State<ListButtons> createState() => _ListButtonsState();
}

class _ListButtonsState extends State<ListButtons> {
  int pages = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.45,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.pets.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  pages = index;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: pages == index
                    ? widget.primary
                    : Colors.transparent, // no select
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: pages == index
                    ? null
                    : const BorderSide(color: Colors.transparent, width: 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              child: Text(
                widget.pets[index].pet[0].pet,
                style: TextStyle(
                  fontSize: 15,
                  color: pages == index
                      ? Color_Selector.c_blanco
                      : Color_Selector.c_gris,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContainerProducts extends StatelessWidget {
  final List<Doc> products;
  final Color primary;
  const ContainerProducts(this.products, {Key? key, required this.primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: products.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.network(
                  products[index].urlImage,
                  width: 175,
                  height: 150,
                ),
                Text(
                  products[index].name,
                  style: TextStyle(
                    // color: ColorSelect.btnBackgroundBo2,
                    color: primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
                SizedBox(
                    width: 175,
                    child: Text(products[index].description,
                        style: const TextStyle(
                          color: Color_Selector.c_grisTenue,
                          fontSize: 15,
                        ))),
                Text(
                  '\$${products[index].price}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
