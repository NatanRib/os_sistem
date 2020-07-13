import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/models/os_model.dart';
import 'package:os_sistema/views/custom_widgets.dart';

class OsFinalizadasController extends GetController{

  final osFinalizadas = List<OsModel>();
  String collect = 'osFinalizadas';

  void onInit(){
    recuperaOsFinalizadas();
    super.onInit();
  }

  recuperaOsFinalizadas(){
    Firestore.instance.collection(collect).snapshots().listen((event) {
      osFinalizadas.clear();
      for (var o in event.documents){
        osFinalizadas.add(OsModel.fromJson(o.data));
      }
      update();
    });
    print('os finalizadas: ' + osFinalizadas.toString());
  }

  apagaOs(OsModel os)async{
    try{
      await Firestore.instance.collection(collect).document(os.id).delete().then((value){
        Get.back();
        CustomWidgets.showSnackBar('Os ${os.id} deletada com sucesso', '', Colors.green, 3);
        update();
      });
    }catch(e){
      CustomWidgets.showSnackBar('Erro ao apagar OS', '${e.toString()}', Colors.red, 5);
      update();
    }
    
  }

  apagarTodasOs(){
    List<OsModel> oss = List();
    for(var o in osFinalizadas){
      oss.add(o);
    }
    try{
      for(var o in oss){
        Firestore.instance.collection(collect).document(o.id).delete();
      }
      Get.back();
      update();
      CustomWidgets.showSnackBar('Registro de OS limpo', '', Colors.green, 3);
      update();
    }catch(e){
      CustomWidgets.showSnackBar('Erro ao limpar o resgistro de OS', '${e.toString()}', Colors.red, 5);
      update();
    }
  }
}