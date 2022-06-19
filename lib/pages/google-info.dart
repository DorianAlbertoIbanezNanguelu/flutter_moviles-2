// ignore_for_file: file_names, use_key_in_widget_constructors, camel_case_types, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movil2/styles/colors/colores.dart';

import '../utils/authentication.dart';
import 'package:http/http.dart' as http;
import '../widgets/image_row.dart';
import '../widgets/slider_widget.dart';
import 'actividad_1.dart';
import 'actividad_2.dart';
import 'prueba2-firebase.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User? user})
      : _user = user,
        super(key: key);

  final User? _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;
  int pageIndex = 0;
  int _selectedIndex = 0;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const prueba2_firebase(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user!;
    super.initState();
  }

  final List<Widget> _pages = <Widget>[
    Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Carousel(),
        ),
        Card(
          // Con esta propiedad modificamos la forma de nuestro card
          // Aqui utilizo RoundedRectangleBorder para proporcionarle esquinas circulares al Card
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

          // Con esta propiedad agregamos margen a nuestro Card
          // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
          margin: const EdgeInsets.all(25),

          // Con esta propiedad agregamos elevación a nuestro card
          // La sombra que tiene el Card aumentará
          elevation: 10,

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: circular_events(),
            ),
          ),
        ),
        const ImageRow(),
        const MyApp_Actividad1(),
        const MyApp_Actividad2(),
      ],
    ),
    Container(),
    Container(),
  ];

  int pages = 0;
  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color_Selector.c_purpura,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Bienvenido!"),
            Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.contain,
              height: 50,
              color: Color_Selector.c_blanco,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 8.0),
            _user.photoURL != null
                ? CircleAvatar(
                    minRadius: 60,
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      child: Image(
                        image: NetworkImage(
                          _user.photoURL!,
                          scale: 0.75,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      child: Image.asset('assets/images/firebase_logo.png'),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
            const SizedBox(height: 8.0),
            Text(
              _user.displayName!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xffFFCA28),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '( ${_user.email!} )',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xffF57C00),
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16.0),
            _isSigningOut
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color_Selector.c_amarillo),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color_Selector.c_purpura,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context)
                            .pushReplacement(_routeToSignInScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Cerrar Sesion',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 8.0),
            Carta_1(),
            Carta_1(),
            Carta_1(),
            Carta_1(),
            Carta_1(),
            const SizedBox(height: 8.0),
            Boton_CerrarVentana(),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: _pages.elementAt(_selectedIndex),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 70),
              painter: CurvePainter(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: IconButton(
                      icon: Image.asset(
                        'images/house_pet.png',
                        color: pages == 0
                            ? Color_Selector.c_purpura
                            : Color_Selector.c_blanco,
                      ),
                      onPressed: () {
                        setState(() {
                          pages = 0;
                        });
                      },
                      iconSize: 35,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  Container(width: MediaQuery.of(context).size.width * 0.20),
                  OutlinedButton(
                    onPressed: () {},
                    child: IconButton(
                      icon: Image.asset(
                        'images/order_list.png',
                        color: pages == 1
                            ? Color_Selector.c_purpura
                            : Color_Selector.c_blanco,
                      ),
                      onPressed: () {
                        setState(() {
                          pages = 1;
                        });
                      },
                      iconSize: 35,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  Container(width: MediaQuery.of(context).size.width * 0.20),
                  OutlinedButton(
                    onPressed: () {},
                    child: IconButton(
                      icon: Image.asset(
                        'images/pet_icon.png',
                        color: pages == 2
                            ? Color_Selector.c_purpura
                            : Color_Selector.c_blanco,
                      ),
                      onPressed: () {
                        setState(() {
                          pages = 2;
                        });
                      },
                      iconSize: 35,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Carta_1 extends Card {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: FlutterLogo(size: 56.0),
        title: Text('Comida No.1'),
        subtitle: Text('Opción1'),
        trailing: Icon(Icons.fastfood_rounded),
      ),
    );
  }
}

class Boton_CerrarVentana extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color_Selector.c_rojo,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            'Cerrar Ventana',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

List<Padding> circular_events() {
  List<Padding> circular_event = List<Padding>.generate(
    5,
    (index) => Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 80.0,
          height: 80.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/company.jpg'),
            ),
          ),
        ),
      ),
    ),
  );

  return circular_event;
}

List<Padding> image_events() {
  List<Padding> circular_event = List<Padding>.generate(
    3,
    (index) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 25),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 80,
          height: 100,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/firebase_logo.png',
              ),
            ),
          ),
        ),
      ),
    ),
  );

  return circular_event;
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color_Selector.c_verde
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height * 0.1128000);
    path.quadraticBezierTo(
      size.width * 0.0902041,
      size.height * -0.0123000,
      size.width * 0.1633929,
      size.height * 0.0103000,
    );
    path.cubicTo(
        size.width * 0.2879847,
        size.height * -0.0231000,
        size.width * 0.2751786,
        size.height * 0.2655000,
        size.width * 0.5131633,
        size.height * 0.2771000);
    path.cubicTo(
        size.width * 0.6660204,
        size.height * 0.2665000,
        size.width * 0.6857398,
        size.height * 0.2169000,
        size.width * 0.7969133,
        size.height * 0.0897000);
    path.quadraticBezierTo(
      size.width * 0.8737500,
      size.height * -0.0645000,
      size.width * 0.9985969,
      size.height * 0.0723000,
    );
    path.lineTo(size.width * 0.9985969, size.height * 1.0058000);
    path.lineTo(size.width * -0.0014031, size.height * 1.0058000);
    path.lineTo(0, size.height * 0.1128000);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
