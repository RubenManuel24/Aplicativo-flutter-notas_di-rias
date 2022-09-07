import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AnotaHelperTest {
  var _db;

  static final AnotaHelperTest _anotaHelperTest = AnotaHelperTest.internal();
  
  factory AnotaHelperTest(){
    return _anotaHelperTest;
  }
  
  AnotaHelperTest.internal(){
  }

  get db{
    if(_db != null){
      return _db;
    }
    else{

    }
  }
   
  _ocreate(Database db, int version) async {
       
    String sql = "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, decricao TEXT, dat DATETIME)";
    db.execute(sql);
  }

  _inicialBaseDados() async {
    
    final caminho = await getDatabasesPath();
    final localbase = p.join(caminho, "base.db");
    
    var db = openDatabase(
      localbase,
      version: 1,
      onCreate: _ocreate,
    );

    return db;
  }

}
