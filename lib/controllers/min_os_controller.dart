import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:os_sistema/models/os_model.dart';
import 'package:os_sistema/views/custom_widgets.dart';

import 'funcionario_controller.dart';

class MinhasOsController extends GetController{

  List<OsModel> minhasOss = List();
  String erro;

  onInit(){
    recuperaOss();
    super.onInit();
  }

  recuperaOss(){
    Firestore.instance.collection('os').snapshots().listen((event) { 
      minhasOss.clear();
      for (var a in event.documents){
        if(FuncionarioController.selecionado != null){
          if(a.data['tecnico'] == FuncionarioController.selecionado.nome){
            minhasOss.add(OsModel.fromJson(a.data));
          }
        }
      }
      update();
    });
  }
}