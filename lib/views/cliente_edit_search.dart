import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/clientes_controller.dart';
import 'package:os_sistema/models/cliente_model.dart';

class ClienteEditSearch extends SearchDelegate<String>{

  final cc = Get.put(ClientesController());
  static List<ClienteModel> result;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
        IconButton(icon: Icon(Icons.clear), onPressed: (){
          query = '';
        })
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){close(context, '');});
    }

    selecionaClientes(){
      print(cc.clientes.length);
      result = cc.clientes.where((element) => element.nome.toLowerCase().contains(query.toLowerCase())).toList();
    }

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
            Text('Endereço: ${c..rua}, ${c.bairro} - ${c.cidade}}'),
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
                  labelText: 'Rua'
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
                keyboardType: TextInputType.text,
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
                  cc.novoCliente(ClienteModel(
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
    Widget buildResults(BuildContext context) {
      selecionaClientes();
      print(result.length);
      return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Nome: ${result[index].nome}\nEndereço: ${result[index].rua}, ${result[index].bairro} - ${result[index].cidade}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text('Id: ${result[index].id == null ? "ERRO ID" : result[index].id}   Plano: ${result[index].plano}'),
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    print(result[index].id);
                    showDialog(
                      context: context,
                      builder: (dialogContext){
                        return _diaologCadastroEdicaoClientes(cliente: result[index], id: result[index].id);
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
                        return _confirmarExclusao(result[index]);
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
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
      // selecionaClientes();
      // print(result.length);
      return Container();
  }

}