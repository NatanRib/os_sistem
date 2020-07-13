import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/funcionario_controller.dart';
import 'package:os_sistema/controllers/min_os_controller.dart';
import 'package:os_sistema/controllers/os_controller.dart';
import 'package:os_sistema/models/os_model.dart';
import 'package:os_sistema/views/custom_widgets.dart';

class ListaOs extends StatelessWidget {

  final oc = Get.put(OsController());
  final moc = Get.put(MinhasOsController());

  _confirmacaoBaixaOs(OsModel os){

    oc.descricao.text = '';

    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Desajar baixar essa Os:'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Motivo: ${os.motivo}  Data: ${os.data}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text('Endereço: ${os.endereco}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            Text('Cliente: ${os.cliente}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            Text('Descrição: ${os.descricao}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            Text('Status: ${os.status}',
              style: TextStyle(
                color: Colors.yellow[800]
              ),
            ),
            TextField(
              controller: oc.descricao,
              decoration: InputDecoration(
                labelText: 'Solucção:',
                hintText: 'escreva aqui a solução tomada' 
              ),
            )
          ],
        ),
        actions: [
           RaisedButton(
            onPressed: () => Get.back(),
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
              if(oc.descricao.text != ''){
                oc.finalizaOs(os, false, oc.descricao.text);
              }else{
                CustomWidgets.showSnackBar('Você precisa digitar a solução para a OS', '', Colors.red, 3);
              }
            },
            child: Text('Baixar'),
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oss de ${FuncionarioController.selecionado.nome}'),
      ),
      body: GetBuilder<MinhasOsController>(
        init: MinhasOsController(),
        builder: (_){
          return  ListView.builder(
            itemCount: _.minhasOss.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text('Motivo: ${_.minhasOss[index].motivo}  Data: ${_.minhasOss[index].data}',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Text('${_.minhasOss[index].endereco}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                trailing: Text('${_.minhasOss[index].status}',
                  style: TextStyle(
                    color: Colors.yellow[800]
                  ),
                ),
                onLongPress: () {
                  Get.dialog(_confirmacaoBaixaOs(_.minhasOss[index]));
                },
              );
            }
          );
        },
      )
    );
  }
}