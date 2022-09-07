class AnotacaoDado{

  var id;
  var titulo;
  var descricao;
  var dat;

  AnotacaoDado(this.titulo, this.descricao, this.dat);

  dynamic toMap(){

    Map<String, dynamic> map = {
        "titulo":this.titulo,
        "descricao":this.descricao,
        "dat":this.dat,
      };

      if( this.id != null ){
         map["id"] = this.id;
      }
      
      return map;

  }

AnotacaoDado.fromMap(Map map){
   this.id = map["id"];
   this.titulo = map["titulo"];
   this.descricao = map["descricao"];
   this.dat = map["dat"];
}
  

}
