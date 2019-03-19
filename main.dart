import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=ae49b31f";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
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
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double real;
  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text("\$ Conversor  \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando Dados...",
                        style: TextStyle(
                          color: Colors.amber,
                        )),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao carregar Dados",
                          style: TextStyle(
                            color: Colors.amber,
                          )),
                    );
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 150.0,
                            color: Colors.amber,
                          ),
                          buildTextField(
                              "Reais", "R\$", realController, _realChanged),
                          /*TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amber, fontSize: 10.0 ),
                          border: OutlineInputBorder(),
                          prefixText: "R\$"
                        ),
                      ),*/
                          Divider(),
                          buildTextField(
                              "Euro", "&", euroController, _euroChanged),
                          /* TextField(
                      decoration: InputDecoration(
                          labelText: "Euro",
                          labelStyle: TextStyle(color: Colors.amber, fontSize: 10.0 ),
                          border: OutlineInputBorder(),
                          prefixText: "&"
                      ),
                    ),*/
                          Divider(),
                          buildTextField(
                              "Dólar", "US\$", dolarController, _dolarChanged),
                          /*TextField(
                      decoration: InputDecoration(
                          labelText: "Dólar",
                          labelStyle: TextStyle(color: Colors.amber, fontSize: 10.0 ),
                          border: OutlineInputBorder(),
                          prefixText: "U\$"
                      ),
                    )*/
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 10.0),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
