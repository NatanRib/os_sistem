import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/os_finalizadas_controller.dart';
import 'package:os_sistema/models/os_model.dart';

class ListaOsFinalizadas extends StatelessWidget {

  final ofc = Get.put(OsFinalizadasController());

  _detalhesOs(OsModel os){
    return AlertDialog(
      title: Text('OS ${os.id}'),
      content: ListView(
        children: [
          Text('Motivo da Os: ${os.motivo}'),
          Text('Endereço: ${os.endereco}'),
          Text('Descrição: ${os.descricao}'),
          Text('Data: ${os.data}'),
          Text('Quem abriu: ${os.atendente}'),
          Text('Cliente: ${os.cliente}'),
          Text('Solução: ${os.solucao}'),
          Text('Id: ${os.id}'),
        ],
      ),
      actions: [
        RaisedButton(
          onPressed: () => Get.back(),
          color: Colors.yellow,
          child: Text('Cancelar',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        ),
        RaisedButton(
          onPressed: () => Get.dialog(_confirmarExclusao(os)),
          color: Colors.red,
          child: Text('Excluir',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        )
      ],
    );
  }

  _confirmarExclusao(OsModel os){
    return AlertDialog(
      title: Text('Deseja mesmo excluir essa OS ${os.id}?'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Motivo: ${os.motivo}'),
          Text('Id: ${os.descricao}'),
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
            Get.back();
            ofc.apagaOs(os);
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
    );
  }

  _confirmarExclusaoTodas(){
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Deseja mesmo excluir todas as OS do registro'),
        content: Text('Essa ação não pode ser desfeita!'),
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
            onPressed: () => ofc.apagarTodasOs(),
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
        title: Text('Oss finalizadas'),
        actions: [
          IconButton(icon: Icon(Icons.delete_sweep),
            onPressed: () => Get.dialog(_confirmarExclusaoTodas())
          )
        ],
      ),
      body: GetBuilder<OsFinalizadasController>(
        init: OsFinalizadasController(),
        builder: (_) => ListView.builder(
          itemCount: _.osFinalizadas.length,
          itemBuilder: (context, index){
            return  Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: _.osFinalizadas[index].status == 'Finalizada' ? Colors.green[800] : Colors.yellow[800],
                  child: ListTile(
                    title: Text('${_.osFinalizadas[index].motivo}\nBaixada: ${_.osFinalizadas[index].data}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text('${_.osFinalizadas[index].endereco}\nBaixada como: ${_.osFinalizadas[index].status}',
                      style: TextStyle(
                        color: Colors.grey[300],
                      ),
                    ),
                    trailing: IconButton(icon: Icon(Icons.content_paste,
                        color: Colors.white,                   
                      ),
                      onPressed: () => Get.dialog(_detalhesOs(_.osFinalizadas[index]))
                    ),
                  ),
                ),
              );
          }
        ),
      )
    );
  }
}