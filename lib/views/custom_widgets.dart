import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWidgets{

  static showSnackBar(title, sub, cor, dur){
    Get.snackbar(title, sub,
      barBlur: 0,
      backgroundColor: cor,
      colorText: Colors.white,
      duration: Duration(seconds: dur)
    );
  }

}