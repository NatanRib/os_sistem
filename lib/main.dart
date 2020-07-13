import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/splash_screen.dart';
//import 'package:os_sistema/views/atendentes_view.dart';
//import 'package:os_sistema/views/tecnicos_view.dart';

void main() {
  runApp(GetMaterialApp(
    defaultTransition: Transition.cupertino,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      accentColor: Colors.deepPurple[800],
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.grey[300]
    ),
    home: SplashScreen() //AtendentesView() //TecnicosView(),
  ));
}


