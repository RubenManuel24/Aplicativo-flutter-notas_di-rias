
import 'package:notas_diarias/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AnotacaoHelper {
var _db;
static final String nameTable = "anotacao";   
static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

factory AnotacaoHelper (){
  return _anotacaoHelper ;
}

AnotacaoHelper._internal(){
}

get db async{
    if( _db != null){
      return _db;
    }
    else{
     _db = inicializardb();
     return _db;
    }
  }

  oncreate(Database db, int version)async{
    
    /*
    id   titulo   descricao   data
    01   teste    teste***    04/10/2022
     */
    String sql = "CREATE TABLE $nameTable (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, dat DATETIME)";
    await db.execute(sql);
  }

   inicializardb() async {
       
      final  caminhoBancoDados = await getDatabasesPath();
      final localBancoDados = p.join(caminhoBancoDados, "banco.db");

      var db = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: oncreate
      );
      return db;
   }

  Future<int> salvarAnotacao(AnotacaoDado anotacaoDado) async {
     Database dadosAnotacao = await db;
     
    int resutId = await dadosAnotacao.insert(nameTable, 
     anotacaoDado.toMap());
   
    return resutId;
     
   }

  Future<List> recuperarAnotacao() async {
    Database dadosAnotacao = await db;
    
    String sql = "SELECT * FROM ${nameTable} ORDER BY dat DESC";
    List listaDados = await dadosAnotacao.rawQuery(sql);

    return listaDados;
     
   }

   Future<int> atualizarAnotacao(AnotacaoDado anotacao) async {
    Database dadosAnotacao = await db;
    return dadosAnotacao.update(
      nameTable, 
      anotacao.toMap(),
      where: "id = ?",
      whereArgs: [anotacao.id]
      );
   }

   Future<int> remove(int id) async {
      Database dadosAnotacao = await db;
      return  dadosAnotacao.delete(
        nameTable,
        where: "id = ?",
        whereArgs: [id]
        );


   }

}

/*
Exemplo de padrão singleton

class Normal{
  Normal(){}
  
}

class Singleton{
  
  static final Singleton _singleton =  Singleton._internal();
  
    factory Singleton(){ 
      print("Singleton");
      return _singleton;
    }
  
    Singleton._internal(){
    print("_internal");
  }
}

void main() {
  
  var i1 = Singleton();
  print("***");
  var i2 = Singleton();
  
  print(i1 == i2);
  
}


*/