import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:os_sistema/models/funcionario_model.dart';

class FuncionarioController extends GetController{

  final funcionarios = List<FuncionarioModel>();
  bool selecionarFuncionarioStatus = false;
  static FuncionarioModel selecionado;

  void onInit(){
    recuperaFuncionarios();
    print(funcionarios.toString());
    super.onInit();
  }

  recuperaFuncionarios(){
    Firestore.instance.collection('funcionarios').snapshots().listen((event) { 
      funcionarios.clear();
      for (var i in event.documents){
        funcionarios.add(FuncionarioModel.fromJson(i.data));
      } 
    });
    update();
  }

  abreSelecao(){
    selecionarFuncionarioStatus = !selecionarFuncionarioStatus;
    print(selecionarFuncionarioStatus.toString());
    update();
  }

  selecionaFuncionario(FuncionarioModel f){
    selecionado = f;
    update();
  }

  verificaFunc(String cargo){
    if(selecionado == null){
      return 'Nos diga quem você é!';
    }else if(selecionado.cargo != cargo){
      return 'Você selecionou o cargo errado!';
    }else{
      return null;
    }
  }

}