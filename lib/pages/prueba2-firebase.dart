// ignore_for_file: camel_case_types, deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter_movil2/pages/prueba-firebase.dart';
import 'package:flutter_movil2/styles/colors/colores.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../utils/authentication.dart';
import '../widgets/google-sign-in.dart';

class prueba2_firebase extends StatelessWidget {
  const prueba2_firebase({Key? key}) : super(key: key);

  static const String _title = 'Flutter Firebase';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _prueba2_firebase(),
      ),
    );
  }
}

class _prueba2_firebase extends StatefulWidget {
  const _prueba2_firebase({Key? key}) : super(key: key);

  @override
  State<_prueba2_firebase> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<_prueba2_firebase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color_Selector.c_purpura,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Iniciar sesión"),
            Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.contain,
              height: 50,
              color: Color_Selector.c_blanco,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/firebase_logo.png',
                        height: 160,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OAUTH2',
                      style: TextStyle(
                        color: Color_Selector.c_amarillo,
                        fontSize: 40,
                      ),
                    ),
                    const Text(
                      'Implementación de Flutter con Firebase',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color_Selector.c_naranja,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return const GoogleSignInButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color_Selector.c_morado),
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SizedBox(
                  height: 48.0,
                  width: 300,
                  child: SignInButtonBuilder(
                    icon: Icons.email,
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    iconColor: const Color(0xFF64686f),
                    text: "Registrarse con email",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const prueba_firebase(),
                        ),
                      );
                    },
                    backgroundColor: Color_Selector.c_blanco,
                    textColor: Color_Selector.c_negro,
                    splashColor: Color_Selector.c_grisTenue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
