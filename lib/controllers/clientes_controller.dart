
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/models/cliente_model.dart';
import 'package:os_sistema/views/custom_widgets.dart';

class ClientesController extends GetController{

  var clientes = List<ClienteModel>();
  ClienteModel searchCliente;

  onInit(){
    recuperaClientes();
    super.onInit();
  }

  recuperaClientes(){
    //testar se ha internet
    Firestore.instance.collection('clientes').snapshots().listen((event) {
      clientes.clear();
      for (var c in event.documents){
        clientes.add(ClienteModel.fromJson(c.data));
      }
      clientes.sort((a,b) => a.nome.compareTo(b.nome));
      update();
    });
    print(clientes.toString());
  }

  set sCliente(ClienteModel c) {
    searchCliente = c;
    update();
  }

  validaCliente(ClienteModel c){
     if(c.nome == null || c.nome.trim() == ""){
      CustomWidgets.showSnackBar("Campo 'nome' vazio, preencha o campo 'nome'", '', Colors.yellow[800],2);
      update();
    }else if(c.rua == null || c.rua.trim() == ""){
      CustomWidgets.showSnackBar("Campo 'rua' vazio, preencha o campo 'rua'", '', Colors.yellow[800],2);
      update();
    }else if(c.bairro == null || c.bairro.trim() == ''){
      CustomWidgets.showSnackBar("Campo 'bairro' vazio, preencha o campo 'bairro'", '', Colors.yellow[800],2);
      update();
    }else if(c.cidade == null || c.cidade.trim() == ""){
      CustomWidgets.showSnackBar("Campo 'cidade' vazio, preencha o campo 'cidade'", '', Colors.yellow[800],2);
      update();
    }else if(c.plano == null || c.plano.trim()== ""){
      CustomWidgets.showSnackBar("Campo 'plano' vazio, preencha o campo 'plano'", '', Colors.yellow[800],2);
      update();
    }else{
      novoCliente(c);
      CustomWidgets.showSnackBar('Cadastrando...', '', Colors.yellow[800],2);
      update();
    }
  }

  novoCliente(ClienteModel cliente)async{

    cliente.plano = cliente.plano + ' mb';
    //testar se a internet;
    try{ 
      await Firestore.instance.collection('clientes').add(cliente.toJson())
        .then((_) => _.updateData({'id' : _.documentID})).then((_) {
          Get.back();
          Get.back();
          update();
          CustomWidgets.showSnackBar('Cliente ${cliente.nome} cadastrado(a)', '', Colors.green, 3);
          update();
        });
    }catch(e){
      CustomWidgets.showSnackBar("Erro ao cadastrar cliente", '${e.toString()}', Colors.red, 3);
      update();
    }
  }

  editaCliente(String id, ClienteModel cliente)async{
    //testar se ha internet
    try{
      await Firestore.instance.collection('clientes').document(id).updateData(cliente.toJson()).then((_) {
        CustomWidgets.showSnackBar('Cliente ${cliente.nome} editado(a) com sucesso', '', Colors.green, 3);
        update();
        Get.back();
      });
    }catch(e){
      CustomWidgets.showSnackBar('Erro ao atualizar cliente ${cliente.nome}', '${e.toString()}', Colors.red, 5);
      update();
    }
  }

  removeCliente(ClienteModel c)async{
    //testar se ha internet
    try{
      await Firestore.instance.collection('clientes').document(c.id).delete().then((_) {
        CustomWidgets.showSnackBar('Cliente ${c.nome} deletado(a)', '', Colors.green, 3);
        update();
        Get.back();
      });
    }catch(e){
      CustomWidgets.showSnackBar('Erro ao apagar Cliente', '${e.toString()}', Colors.red, 5);
      update();
    }
  }


}