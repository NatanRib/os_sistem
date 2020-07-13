class FuncionarioModel{

  String nome;
  String id;
  String cargo;

  FuncionarioModel(this.nome, this.cargo);

  FuncionarioModel.fromJson(Map<String, dynamic> map){
    this.nome = map['nome'];
    this.id = map['id'];
    this.cargo = map['cargo'];
  }

  toJson(){
    Map<String, dynamic> map = {
      'nome' : this.nome,
      'cargo' : this.cargo
    };
    return map;
  }

}
