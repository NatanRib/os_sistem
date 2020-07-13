import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/clientes_controller.dart';
import 'package:os_sistema/models/cliente_model.dart';

class ClienteSearch extends SearchDelegate<String>{

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
  
    @override
    Widget buildResults(BuildContext context) {
      selecionaClientes();
      print(result.length);
      return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index){
          return ListTile(
            onTap: (){
              cc.sCliente = result[index];
              close(context, query);
            },
            title: Text("${result[index].nome}\nEndereço: ${result[index].rua}, ${result[index].bairro} - ${result[index].cidade}"),
            subtitle: Text('Plano: ${result[index].plano}    Id: ${result[index].id}'),
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