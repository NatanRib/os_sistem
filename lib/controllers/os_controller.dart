import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/clientes_controller.dart';
import 'package:os_sistema/controllers/funcionario_controller.dart';
import 'package:os_sistema/models/os_model.dart';
import 'package:os_sistema/models/cliente_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:os_sistema/views/custom_widgets.dart';

class OsController extends GetController{

  final cc = Get.put(ClientesController());
  TextEditingController motivo = TextEditingController();
  TextEditingController descricao = TextEditingController();

  List<OsModel> oss = List();
  List<OsModel> ossRealizadas = List();
  String erro;
  var data;
  var hora;

  void onInit(){
    recuperaOss();
    initializeDateFormatting('pt-BR');
    super.onInit();
  }

  recuperaOss(){
    Firestore.instance.collection('os').snapshots().listen((event) { 
      oss.clear();
      for (var a in event.documents){
        oss.add(OsModel.fromJson(a.data));
      }
      update();
    });
  }

  validaOs(ClienteModel cliente){
    if(motivo == null || motivo.text == ""){
      CustomWidgets.showSnackBar("Campo 'motivo' vazio, preencha o campo 'motivo'", '', Colors.yellow[800],2);
      update();
    }else if(descricao == null || descricao.text == ""){
      CustomWidgets.showSnackBar("Campo 'descrição' vazio, preencha o campo 'descrição'", '', Colors.yellow[800],2);
      update();
    }else if(cliente == null){
      CustomWidgets.showSnackBar("Campo 'cliente' vazio, pesquise pelo cliente", '', Colors.yellow[800],2);
      update();
    }else if(cliente.rua == null || cliente.rua == ""){
      CustomWidgets.showSnackBar("Campo 'rua' vazio, preencha o endereço do cliente na aba cliente", '', Colors.yellow[800],2);
      update();
    }else if(cliente.bairro == null || cliente.bairro == ""){
      CustomWidgets.showSnackBar("Campo 'bairro' vazio, preencha o endereço do cliente na aba cliente", '', Colors.yellow[800],2);
      update();
    }else if(cliente.cidade == null || cliente.cidade == ""){
      CustomWidgets.showSnackBar("Campo 'cidade' vazio, preencha o endereço do cliente na aba cliente", '', Colors.yellow[800],2);
      update();
    }else{
      criaOs(motivo.text, descricao.text, cliente);
      CustomWidgets.showSnackBar('Cadastrando...', '', Colors.yellow[800],3);
      update();
    }
  }

  criaOs(String motivo, String descricao, ClienteModel cliente,)async {

    hora = DateFormat.Hm('pt-Br').format(DateTime.now());
    data = DateFormat.yMd('pt-Br').format(DateTime.now());

    OsModel os = OsModel(
      motivo, 
      data + ' ' + hora,
      cliente.nome, 
      cliente.rua + ', ' + cliente.bairro + ' - ' + cliente.cidade, 
      descricao, 
      'Pendente', 
      'Ninguem',
      FuncionarioController.selecionado.nome
    );

    await Firestore.instance.collection('os').add(os.toJson())
      .then((value) => value.updateData({'id' : value.documentID})).then((_){
        Get.back();
        Get.back();
        update();
        CustomWidgets.showSnackBar('Cadastrada', '', Colors.green,3);
        this.motivo.text = '';
        this.descricao.text = '';
        cc.sCliente = null;
        update();
      });
  }

  verificaJaAtendida(OsModel os){
    if(os.status == 'atendendo'){
      Get.back();
      CustomWidgets.showSnackBar('Essa os ja esta sendo atendida', '', Colors.yellow[800],3);
      update();
    }else{
      atendeOs(os);
    }
  }

  atendeOs(OsModel os)async{

    data = DateFormat.yMd('pt-Br').format(DateTime.now());  
    hora = DateFormat.Hm('pt-Br').format(DateTime.now());

    try{
      await Firestore.instance.collection('os').document(os.id).updateData(
        {
          'status' : 'Atendendo',
          'tecnico' : FuncionarioController.selecionado.nome,
          'data' : data + ' ' + hora
        }
      ).then((value) {
        Get.back();
        CustomWidgets.showSnackBar('Você esta atendendo essa Os', '', Colors.green,1);
        update();
       });
    }catch (e){
      CustomWidgets.showSnackBar('Erro ao tentar atender Os', e.toString(), Colors.red,5);
      update();
    }
  }

  finalizaOs(OsModel os, bool baixada, String solucao)async{

    data = DateFormat.yMd('pt-Br').format(DateTime.now());  
    hora = DateFormat.Hm('pt-Br').format(DateTime.now());

    os.data = data + " " + hora;
    os.solucao = solucao;

    if(baixada){
      os.status = 'Baixada';
    }else{
      os.status = 'Finalizada';
    }
    

    try{
      await Firestore.instance.collection('osFinalizadas').add(os.toJson(id: os.id)).then(
        (value) => value.updateData({'id' : value.documentID})).then((value){
          CustomWidgets.showSnackBar('Os marcada como realizada', '', Colors.green, 1);
          update();
        });
    }catch(e){
      CustomWidgets.showSnackBar('Erro ao finalizar Os', e.toString(), Colors.red, 5);
      update();
    }

    try{
      await Firestore.instance.collection('os').document(os.id).delete().then((value) {
        Get.back();
        CustomWidgets.showSnackBar('Os retirada da fila','', Colors.green,2);
        update();
      });
    }catch(e){
      //erro = e.toString();
      CustomWidgets.showSnackBar(e.toString(), '', Colors.red,5);
      update();
    }
    Get.back();
  }

  set sMotivo (String motivo){
    this.motivo.text = motivo;
    update();
  }
  set sDescricao (String descricao){
    this.descricao.text = descricao;
    update();
  }

}