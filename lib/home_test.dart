import 'package:flutter/material.dart';
class HomeTest extends StatefulWidget {
  HomeTest({Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  
  TextEditingController _titulocontroller = TextEditingController();
  TextEditingController _descriaocontroller = TextEditingController();

   _telaCriarAnotacao(){
     showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
           title: Text("Adicionar anotações"),
           content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                controller: _titulocontroller,
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Digite um título"
                ),
                ),
                TextField(
                controller:  _descriaocontroller,
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite um descrição"
                ),
                ),
              ],
           ),
           actions: [
            TextButton(
              onPressed: ()=> Navigator.pop(context), 
              child: Text("Cancelar")),
              TextButton(
              onPressed: (){
                //salvar
                Navigator.pop(context);
              }, 
              child: Text("Salvar"))
           ],
        );
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
       title: Text("Minhas anotações"),
       backgroundColor: Colors.brown
       ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => _telaCriarAnotacao(),
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 92, 45, 28),
        ),
        body: Container() ,

    );
  }
}