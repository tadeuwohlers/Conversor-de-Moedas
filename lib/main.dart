import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=cc18dd74";

void main() {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var realController = TextEditingController();
  var dolarController = TextEditingController();
  var euroController = TextEditingController();
  
  double dolar, euro;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar)/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro)/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.blue,
        centerTitle: true
        ),
      body: FutureBuilder<Map>(
        future: getData(),

        builder: (context, snapshot) {

          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                  style: TextStyle(
                    fontSize: 25
                  ),
                ),
              );

            default:
              if(snapshot.hasError) {
                return Center(
                  child: Text("Ocorreu um erro :(",
                    style: TextStyle(
                      fontSize: 25
                    ),
                  ),
                );
              }
              else {

                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150, color: Colors.blue),
                      TextField(
                        controller: realController,
                        onChanged: _realChanged,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          prefixText: "R\$ "
                        ),
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        onChanged: _dolarChanged,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Dólares",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          prefixText: "US\$ "
                        ),
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        onChanged: _euroChanged,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          prefixText: "€ "
                        ),
                      )
                    ],
                  )
                );
              }
          }
        }),    
    );
  }
}

