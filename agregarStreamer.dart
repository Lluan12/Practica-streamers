import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'baseRemota.dart';

class AgrStr extends StatefulWidget {
  const AgrStr({super.key});

  @override
  State<AgrStr> createState() => _AgrStrState();
}

class _AgrStrState extends State<AgrStr> {


  DateTime selectedDate = DateTime.now();
  List paises = [
    { "bandera": "ad", "pais": "Andorra"},
    { "bandera": "ar", "pais": "Argentina"},
    { "bandera": "cl", "pais": "Chile"},
    { "bandera": "co", "pais": "Colombia"},
    { "bandera": "ci", "pais": "Costa Rica"},
    { "bandera": "sv", "pais": "El Salvador"},
    { "bandera": "us", "pais": "Estados Unidos"},
    { "bandera": "mx", "pais": "Mexico"},
    { "bandera": "pe", "pais": "Peru"},
    { "bandera": "uy", "pais": "Uruguay"},
    { "bandera": "null", "pais": "Otro"},
  ];

  final nombre = TextEditingController();
  final seudonimo = TextEditingController();
  String f_nac = "";
  final nacionalidad = TextEditingController();
  int edad = 0;
  bool casado = false;
  bool pais = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar datos", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                      labelText: "Nombre:",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: seudonimo,
                  decoration: InputDecoration(
                      labelText: "Seudonimo:",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                OutlinedButton(
                  onPressed: () {
                    // INSTALAR PAQUETE PARA MANEJAR FECHAS
                    // flutter pub add intl
                    showDatePicker(
                      context: context,
                      initialDate: selectedDate, // Fecha inicial
                      firstDate: DateTime(1900), // Fecha mínima seleccionable
                      lastDate: DateTime(2024), // Fecha máxima seleccionable
                    ).then((pickedDate) {
                      if (pickedDate != null && pickedDate != selectedDate) {
                        selectedDate = pickedDate;
                        edad = DateTime.now().year - selectedDate.year;
                        if (DateTime.now().month < selectedDate.month ||
                            (DateTime.now().month == selectedDate.month &&
                                DateTime.now().day < selectedDate.day)) {
                          edad--;
                        }
                        setState((){
                          f_nac = DateFormat('yyyy-MM-dd').format(selectedDate);
                        });
                      }
                    });
                  },
                  child: Text(f_nac == "" ? 'Fecha Nacimiento': f_nac, style: TextStyle(fontSize: 20)),
                ),
                SizedBox(height: 20,),
                // Instalar dependencia
                // flutter pub add country_icons
                DropdownMenu(
                  width: 300,
                  controller: nacionalidad,
                  onSelected: (value) {
                    if(value == "Otro"){
                      setState(() {
                        pais = true;
                      });
                    } else{
                      setState(() {
                        pais = false;
                      });
                    }
                  },
                  dropdownMenuEntries: paises.map((e) {
                    return DropdownMenuEntry(
                        value: "${e["pais"]}",
                        label: "${e["pais"]}",
                        leadingIcon: e["bandera"] != "null" ? Image.asset('icons/flags/png/${e["bandera"]}.png', package: 'country_icons', height: 15,): null
                    );
                  }).toList()
                ),
                pais ?
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: nacionalidad,
                      decoration: InputDecoration(
                        labelText: "Nacionalidad:"
                      ),
                    )
                  ): SizedBox(),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Radio(
                              value: true,
                              groupValue: casado,
                              onChanged: (valor){
                                setState(() {
                                  casado = valor!;
                                });
                              }
                          ),
                          Text("Casado", style: const TextStyle(fontSize: 18),)
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(
                              value: false,
                              groupValue: casado,
                              onChanged: (valor){
                                setState(() {
                                  casado = valor!;
                                });
                              }
                          ),
                          Text("Soltero", style: const TextStyle(fontSize: 18))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar", style: const TextStyle(fontSize: 18))
                    ),
                    FilledButton(
                        onPressed: (){
                          var streamer = {
                            "nombre": nombre.text,
                            "seudonimo": seudonimo.text,
                            "edad": edad,
                            "nacionalidad": nacionalidad.text,
                            "casado": casado,
                          };
                          DB.insertar(streamer).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Streamer agreago satisfactoriamente")));
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Agregar", style: const TextStyle(fontSize: 18))
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
