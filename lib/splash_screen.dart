import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:os_sistema/controllers/clientes_controller.dart';
import 'package:os_sistema/controllers/os_controller.dart';
import 'package:os_sistema/controllers/os_finalizadas_controller.dart';
import 'package:os_sistema/views/atendentes_view.dart';
import 'package:os_sistema/views/custom_widgets.dart';
import 'package:os_sistema/views/tecnicos_view.dart';
import 'controllers/funcionario_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final cc = Get.put(ClientesController());
  final oc = Get.put(OsController());
  final fc = Get.put(FuncionarioController());
  final ofc = Get.put(OsFinalizadasController());
  
  String value;

  @override
  void initState() { 
    fc.onInit();
    cc.onInit();
    oc.onInit();
    ofc.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple
        ),
        child: SingleChildScrollView(
          child: Container(
            height: Get.mediaQuery.size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.format_list_numbered,
                    color: Colors.white,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Oss',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50
                      ),
                    ),
                  ),
                  GetBuilder<FuncionarioController>(
                    init: FuncionarioController(),
                    builder: (_){
                      return Column(
                        children: [
                          Material(
                            borderRadius: _.selecionarFuncionarioStatus ?
                              BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)) 
                              : BorderRadius.circular(12),
                            color: Colors.red,
                            child: SizedBox(
                              width: 160,
                              child: ListTile(
                                trailing: Icon(Icons.arrow_drop_down_circle,
                                  color: Colors.white,
                                ),
                                title: FuncionarioController.selecionado == null ?
                                 Text('Quem é voce?',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                 ) : 
                                 Text(FuncionarioController.selecionado.nome,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                 ),
                                onTap: () => _.abreSelecao(),
                              ),
                            ),
                          ),
                          _.selecionarFuncionarioStatus ?
                          Material(
                            color: Colors.red,
                            child: SizedBox(
                              height: 200,
                              width: 160,
                              child: ListView.builder(
                                itemCount: _.funcionarios.length,
                                itemBuilder: (context, index){
                                  return Material(
                                    color: Colors.grey[400],
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 2.0),
                                      color: Colors.red,
                                      child: ListTile(
                                        title: Text(_.funcionarios[index].nome,
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                        onTap: () { 
                                          _.selecionaFuncionario(_.funcionarios[index]);
                                          _.abreSelecao();
                                        }
                                      )
                                    ),
                                  );
                                } 
                              ),
                            ),
                          ) :
                          Container()
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 160,
                      height: 50,
                      child: RaisedButton(
                        onPressed: (){
                          fc.verificaFunc('tecnico') == null ?
                            Get.offAll(TecnicosView()) : 
                            CustomWidgets.showSnackBar(fc.verificaFunc('tecnico'),'', Colors.yellow[800],3);
                           
                        },
                        child: Text('Tecnico',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: 160,
                      height: 50,
                      child: RaisedButton(
                        onPressed: (){
                          fc.verificaFunc('atendente') == null ?
                            Get.offAll(AtendentesView()) :
                            CustomWidgets.showSnackBar(fc.verificaFunc('atendente'),'', Colors.yellow[800],3);  
                        },
                        child: Text('Atendente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}