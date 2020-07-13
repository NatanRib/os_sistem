
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/os_controller.dart';
import 'package:os_sistema/models/os_model.dart';
import 'package:os_sistema/views/cliente_edit_search.dart';
import 'package:os_sistema/views/custom_widgets.dart';
import 'package:os_sistema/views/lista_os_finalizadas.dart';
import 'formulario_os_view.dart';
import 'lista_clientes.dart';

class AtendentesView extends StatelessWidget{

  final oc = Get.put(OsController());

  _detalhesOs(OsModel os){
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(os.motivo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${os.descricao}'),
            Text('Cliente: ${os.cliente}'),
            Text('Endereço: ${os.endereco}'),
            Text('Status: ${os.status}',
              style: TextStyle(
                color: os.status == 'pendente' ? Colors.yellow[800] : Colors.green
              ),
            ),
            Text('Tecnico: ${os.tecnico}'),
            Text('Quem abriu: ${os.atendente}'),
            Text('Id: ${os.id}'),
            Text('Ultima alteração: ${os.data}')
          ],
        ),
        actions: [
           RaisedButton(
            onPressed: (){Get.back();},
            child: Text('Voltar',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            color: Colors.yellow[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
           RaisedButton(
            onPressed: () {
              Get.back();
              Get.dialog(_confirmarBaixa(os));
            },
            child: Text('Dar baixa'),
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        ],
      ),
    );
  }

  _confirmarBaixa(OsModel os){

    oc.descricao.text = '';

    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Deseja Baixar essa OS ${os.id}?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Motivo: ${os.motivo}'),
            Text('Descrição: ${os.descricao}'),
            TextField(
              controller: oc.descricao,
              decoration: InputDecoration(
                labelText: "Solução:",
                hintText: 'Digite a solução ou motivo da baixa da OS '
              ),
            )
          ],
        ),
        actions: [
           RaisedButton(
            onPressed: () => Get.back(),
            color: Colors.yellow,
            child: Text('Não',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
          ),
          RaisedButton(
            onPressed: () {
              print(oc.descricao.text);
              if(oc.descricao.text != ''){
                oc.finalizaOs(os, true, oc.descricao.text);
              }else{
                 CustomWidgets.showSnackBar('Você precisa digitar a solução para a OS', '', Colors.red, 3);
              }
            },
            color: Colors.red,
            child: Text('Sim',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Os'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.format_list_numbered,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text('Oss',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                      ),
                    ),
                  ],
                ),
              ) 
            ),
            ListTile(
              title: Text('Clientes'),
              subtitle: Text('Consulta, adição e edição de clientes'),
              onTap: () => Get.to(ListaClientes()),
            ),
            ListTile(
              title: Text('Oss finalizadas'),
              subtitle: Text('Consulta e remocão de oss ja finalizadas'),
              onTap: () => Get.to(ListaOsFinalizadas()),
            ),
          ],
        ),
      ),
      body: GetBuilder<OsController>(
        init: OsController(),
        //initState: (_) => oc.recuperaOss(),
        builder: (_){
          return ListView.builder(
            itemCount: _.oss.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange[400],
                  child: ListTile(
                    title: Text('${_.oss[index].motivo}  Data: ${_.oss[index].data}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text('${_.oss[index].endereco}',
                      style: TextStyle(
                        color: Colors.grey[300],
                      ),
                    ),
                    trailing: Text('${_.oss[index].status}',
                      style: TextStyle(
                        color: _.oss[index].status == 'Pendente' ? Colors.red : Colors.green[800],
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onLongPress: (){
                      Get.dialog(_detalhesOs(_.oss[index]));
                    },
                  ),
                ),
              );
            }
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //abri formulario de criacao de os
          Get.to(FormularioOsView());
        },
        child: Icon(Icons.assignment),
      ),
    );
  } 
}