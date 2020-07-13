import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/os_controller.dart';
import 'package:os_sistema/models/os_model.dart';
import 'package:os_sistema/views/listas_os.dart';

class TecnicosView extends StatelessWidget {

  final oc = Get.put(OsController());

  _detalhesOs(OsModel os){
    return AlertDialog(
      title: Text(os.motivo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descrição: ${os.descricao}'),
          Text('Endereço: ${os.endereco}',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          Text('Cliente: ${os.cliente}'),
          Text('Status: ${os.status}',
            style: TextStyle(
              color: os.status == 'Pendente' ? Colors.yellow[800] : Colors.green,
              fontWeight: FontWeight.bold
            ),
          ),
          Text('Tecnico: ${os.tecnico}'),
          Text('Id: ${os.id}'),
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
          onPressed: () => oc.verificaJaAtendida(os),
          child: Text('Atender'),
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Os'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.build,
              color: Colors.white
            ), 
            onPressed: () => Get.to(ListaOs()))
        ],
      ),
      body: GetBuilder<OsController>(
        init: OsController(),
        //initState: (_) => oc.recuperaOss(),
        builder: (_){
          return ListView.builder(
            itemCount: _.oss.length,
            itemBuilder: (context,index){
              return _.oss[index].status == 'Pendente' ? Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.yellow[800],
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
                        color: _.oss[index].status == 'Pendente' ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onLongPress: (){
                      Get.dialog( 
                        _detalhesOs(_.oss[index]),
                        barrierDismissible: false
                      );
                    },
                  ),
                ),
              ) : Container();
            }
          );
        },
      )
    );
  }
}