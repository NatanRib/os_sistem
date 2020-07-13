import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/clientes_controller.dart';
import 'package:os_sistema/models/cliente_model.dart';
import 'package:os_sistema/views/custom_widgets.dart';
import 'cliente_edit_search.dart';

class ListaClientes extends StatelessWidget {

  final cc = Get.put(ClientesController());

  TextEditingController _nomeCliente = TextEditingController();
  TextEditingController _ruaCliente = TextEditingController();
  TextEditingController _bairroCliente = TextEditingController();
  TextEditingController _cidadeCliente = TextEditingController();
  TextEditingController _planoCliente = TextEditingController();

  _confirmarExclusao(ClienteModel c){
    return AlertDialog(
      title: Text('Deseja Mesmo apagar o cliente:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nome: ${c.nome}'),
          Text('Endereço: ${c.rua}, ${c.bairro} - ${c.cidade}'),
          Text('Plano: ${c.plano}'),
          Text('Id: ${c.id}')
        ],
      ),
      actions: [
        RaisedButton(
          onPressed: (){Get.back();},
          child: Text('Não'),
          color: Colors.yellow[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
        ),
        RaisedButton(
          onPressed: (){
            cc.removeCliente(c);
          },
          child: Text('Sim'),
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
        ),
      ],
    );
  }

  _diaologCadastroEdicaoClientes({ClienteModel cliente, String id}){

  if(cliente != null){
    _nomeCliente.text = cliente.nome; 
    _ruaCliente.text = cliente.rua;
    _bairroCliente.text = cliente.bairro;
    _cidadeCliente.text = cliente.cidade;
    _planoCliente.text = cliente.plano;
  }else{ 
    _nomeCliente.text = ''; 
    _ruaCliente.text = '';
    _bairroCliente.text = '';
    _cidadeCliente.text = '';
    _planoCliente.text = '';
  }

    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Novo cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeCliente,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nome do cliente'
              ), 
            ),
            TextField(
              controller: _ruaCliente,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Rua + Numero'
              ), 
            ),
            TextField(
              controller: _bairroCliente,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Bairro'
              ), 
            ),
            TextField(
              controller: _cidadeCliente,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Cidade'
              ), 
            ),
            TextField(
              controller: _planoCliente,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                labelText: 'Plano de internete'
              ), 
            ),
          ],
        ),
        actions: [
          RaisedButton(
            onPressed: (){Get.back();},
            child: Text('Sair'),
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
          RaisedButton(
            onPressed: (){
              if(cliente == null){
                cc.validaCliente(ClienteModel(
                  _nomeCliente.text,
                  _ruaCliente.text,
                  _bairroCliente.text,
                  _cidadeCliente.text,
                  _planoCliente.text
                ));
              }else{
                cliente.nome = _nomeCliente.text;
                cliente.rua = _ruaCliente.text;
                cliente.bairro = _bairroCliente.text;
                cliente.cidade = _cidadeCliente.text;
                cliente.plano =  _planoCliente.text;
                cc.editaCliente(id, cliente);
              }
            },
            child: Text('Salvar'),
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Lista clientes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () => showSearch(
              context: context, 
              delegate: ClienteEditSearch()
            )
          )
        ],
      ),
      body: GetBuilder<ClientesController>(
        init: ClientesController(),
        // initState: (state) => cc.recuperaClientes(), 
        builder: (_){
          print(_.clientes.length);
          return Builder(builder: (context) {
            return ListView.builder(
              itemCount: _.clientes.length,
              itemBuilder: (context , index){
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Nome: ${_.clientes[index].nome}\nEndereço: ${_.clientes[index].rua}, ${_.clientes[index].bairro} - ${_.clientes[index].cidade}',
                        style: TextStyle(
                          color: _.clientes[index].id == null ? Colors.red : Colors.black
                        ),
                      ),
                      subtitle: Text('Id: ${_.clientes[index].id == null ? "ERRO ID" : _.clientes[index].id}  Plano: ${_.clientes[index].plano}'),
                      leading: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          print(_.clientes[index].id);
                          showDialog(
                            context: context,
                            builder: (dialogContext){
                              return _diaologCadastroEdicaoClientes(cliente: _.clientes[index], id: _.clientes[index].id);
                            }
                          );
                        },
                        color: Colors.yellow[800],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (dialogContext){
                              return _confirmarExclusao(_.clientes[index]);
                            }
                          );
                        },
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }
            );
          });
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext){
              return _diaologCadastroEdicaoClientes();
            }
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}