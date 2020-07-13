import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/clientes_controller.dart';
import 'package:os_sistema/controllers/os_controller.dart';
import 'package:os_sistema/views/cliente_search.dart';
import 'package:os_sistema/views/custom_widgets.dart';

class FormularioOsView extends StatelessWidget {

  final oc = Get.put(OsController());
  final cc = Get.put(ClientesController()); 

  camposTexto(String label, String hint, TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label
        ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Formulario de criação Os"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        children: <Widget>[
          camposTexto('Motivo Os', 'Digite aqui o defeito ou erro informado', oc.motivo),
          camposTexto('Descricao Os', 'Digite aqui as informações passadas', oc.descricao),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5.0, bottom: 5.0),
            child: Text('Cliente: ',
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),
          GetBuilder<ClientesController>(
            builder: (_){
              return _.searchCliente == null ? Container() : ListTile(
                title: Text('${_.searchCliente.nome}\nEndereço: ${_.searchCliente.rua}, ${_.searchCliente.bairro} - ${_.searchCliente.cidade}'),
                subtitle: Text('plano: ${_.searchCliente.plano}   id: ${_.searchCliente.id}'),
              );
            },
          ),
          RaisedButton(
            child: Text('Pesquisar pelo Cliente',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            color: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            onPressed: (){
              showSearch(
                context: context,
                delegate: ClienteSearch()
              );
            }
          ),
          RaisedButton(
            child: Text('Limpar campos',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            color: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            onPressed: (){
              cc.sCliente = null;
              oc.sMotivo = '';
              oc.sDescricao = '';
            }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          oc.validaOs(cc.searchCliente);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}