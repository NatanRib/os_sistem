class OsModel {

  String motivo;
  String data;
  String cliente;
  String endereco;
  String descricao;
  String id;
  String atendente;
  String status;
  String tecnico;
  String solucao;

  OsModel(
    this.motivo, 
    this.data, 
    this.cliente, 
    this.endereco, 
    this.descricao, 
    this.status, 
    this.tecnico,
    this.atendente
  );

  OsModel.fromJson(Map<String, dynamic> map){
    this.motivo = map['motivo'];
    this.data = map['data'];
    this.cliente = map['cliente'];
    this.endereco = map['endereco'];
    this.descricao = map['descricao'];
    this.id = map['id'];
    this.status = map['status'];
    this.tecnico = map['tecnico'];
    this.atendente = map['atendente'];
    this.solucao = map['solucao'];
  }

  toJson({String id}){
    Map<String, dynamic> map = {
      'motivo' : this.motivo,
      'data' : this.data,
      'cliente' : this.cliente,
      'endereco' : this.endereco,
      'descricao' : this.descricao,
      'status' : this.status,
      'tecnico' : this.tecnico,
      'atendente' : this.atendente,
      'solucao' : this.solucao,
      'id' : id
    };

    return map;
  }

}