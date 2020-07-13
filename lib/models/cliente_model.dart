class ClienteModel{

  String nome;
  String id;
  String rua;
  String bairro;
  String cidade;
  String plano;

  ClienteModel(this.nome, this.rua, this.bairro, this.cidade, this.plano);

  ClienteModel.fromJson(Map<String, dynamic> map){
    this.nome = map['nome'];
    this.id = map['id'];
    this.rua = map['rua'];
    this.bairro = map['bairro'];
    this.cidade = map['cidade'];
    this.plano = map['plano'];
  }

  toJson(){
    Map<String, dynamic> map = {
      'nome' : this.nome,
      'rua' : this.rua,
      'bairro' : this.bairro,
      'cidade' : this.cidade,
      'plano' : this.plano
    };

    return map;
  }

}