import 'package:flutter/material.dart';
import 'package:notas_diarias/helper/anotacao_helper.dart';
import 'package:notas_diarias/model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var anotacaoHelper = AnotacaoHelper();
  TextEditingController _titulocontroler = TextEditingController();
  TextEditingController _descricaocontroler = TextEditingController();
  List<AnotacaoDado> _anotacaoDado =[];
  
  //essa tela será usada tanto para salvar e editar as nossas anotações
  _exibirTelaSalvarAtualizarCadastro({AnotacaoDado? anotacaoD}){
    String salvarAtualizar = "";
   if(anotacaoD == null){
    //Salvar anotacao
     salvarAtualizar = "Salvar";
     _titulocontroler.text = "";
     _descricaocontroler.text = "";
   }
   else{
    //Atualizar anotacao
     salvarAtualizar = "Atualizar";
     _titulocontroler.text = anotacaoD.titulo;
     _descricaocontroler.text = anotacaoD.descricao;
   }

     showDialog(
      context: context, 
      builder: (context){
        return  AlertDialog(
           title: Text("$salvarAtualizar Anotação"),
           content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titulocontroler,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Digite título"
                ),
                autofocus: true,
                autocorrect: true,
              ),
               TextField(
                controller: _descricaocontroler,
                decoration: InputDecoration(
                labelText: "Descrição",
                  hintText: "Digite descrição"
                ),
                autocorrect: true,
              ),
            ],
           ),
           actions: [
             TextButton(
              onPressed: (){

                 _titulocontroler.clear();
                 _descricaocontroler.clear();
                Navigator.pop(context);
              },
              child: Text("Cancelar")),
              TextButton(
              onPressed:(){

               //salvar e atualizar
               _salvarAtualizarAnotacao(anotacaoDado: anotacaoD);
               return Navigator.pop(context);
              }, 
              child: Text("$salvarAtualizar"))
           ],
        );
      });
  }

//  Formatacao de data no App
  _formatacaoData(String data){
      initializeDateFormatting("pt_AO");
   
   // year -> y, month -> M, Day -> D
   // Hour -> H, minute -> m, secound -> s
   //DateFormat dataFormatada = DateFormat("d/MM/y");
   //DateFormat dataFormatada = DateFormat.yMMMMd("pt_AO");
   //DateFormat dataFormatada = DateFormat.yMMMMEEEEd("pt_AO");
   //DateFormat dataFormatada = DateFormat.yQQQ("pt_AO");
   DateFormat dataFormatada = DateFormat("d/MM/y");
   
   DateTime dataConvertida = DateTime.parse(data);
   String dataAtual =  dataFormatada.format(dataConvertida);
   
   return dataAtual;
  }

_salvarAtualizarAnotacao({AnotacaoDado? anotacaoDado}) async {
   String titulo = _titulocontroler.text;
   String descricao = _descricaocontroler.text;
  

   if(anotacaoDado == null){
     //print("Data atual: " +DateTime.now().toString() );
    AnotacaoDado anotacao = AnotacaoDado(titulo, descricao, DateTime.now().toString());
    int resultado = await anotacaoHelper.salvarAnotacao(anotacao);
    //print("Id do dado salvo: "+resultado.toString());
   }
   else{
      anotacaoDado.titulo = titulo;
      anotacaoDado.descricao = descricao;
      anotacaoDado.dat = DateTime.now().toString();
      int dadoId = await anotacaoHelper.atualizarAnotacao(anotacaoDado);
      
   }
     _titulocontroler.clear();
     _descricaocontroler.clear();
     
     _recuperarAnotacao();
  }


  _remove(int id) async {

   int idDelete = await anotacaoHelper.remove(id);
   _recuperarAnotacao();


  }

// Formatacao de data no flutter para o nosso app
  _recuperarAnotacao() async {
    var anotacaoDado = await anotacaoHelper.recuperarAnotacao();
    _anotacaoDado.clear();
    for(var item in anotacaoDado ){
      AnotacaoDado anotacao = AnotacaoDado.fromMap(item);
      setState(() {
          _anotacaoDado.add(anotacao);
      });
      
    }
  }

  @override
  void initState() {
    super.initState();
     _recuperarAnotacao();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 253, 210, 79),
        title: Text("Minhas Anotações",),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _exibirTelaSalvarAtualizarCadastro();
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _anotacaoDado.length,
                itemBuilder:(context, index){
                    var anotacao = _anotacaoDado[index];
                  return Card(
                    color: Color.fromARGB(255, 245, 233, 199),
                    elevation: 10,
                    child: ListTile(
                      title:Text(anotacao.titulo),
                      subtitle: Text("${_formatacaoData(anotacao.dat)}  -  ${anotacao.descricao}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(padding: EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: (){
                                _exibirTelaSalvarAtualizarCadastro(anotacaoD: anotacao);
                              },
                              child: Icon(Icons.edit, color: Colors.green),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 0),
                            child: GestureDetector(
                              onTap: (){
                                 _remove(anotacao.id);
                              },
                              child: Icon(Icons.remove_circle, color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }))
          ]),
    );
  }
}