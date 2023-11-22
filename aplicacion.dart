import 'package:dam_u3_practica2_coleccionfirestore/agregarStreamer.dart';
import 'package:dam_u3_practica2_coleccionfirestore/baseRemota.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppFirestore extends StatefulWidget {
  const AppFirestore({super.key});

  @override
  State<AppFirestore> createState() => _AppFirestoreState();
}

class _AppFirestoreState extends State<AppFirestore> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async{
    var temp = await DB.mostrarTodos();
    setState((){
      datos = temp;
    });
  }

  String titulo = "Streamers";
  List datos = [];

  final nombre = TextEditingController();
  final seudonimo = TextEditingController();
  final nacionalidad = TextEditingController();
  final edad = TextEditingController();
  bool casado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),),
        ),
        body: dinamico(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) => AgrStr(),)).then((value) {
              cargarDatos();
            });
          },
          child: Icon(Icons.add),
        ),
    );
  }

  Widget dinamico(){
    return pagina1();
  }
  
  Widget pagina1(){
    if(datos.isNotEmpty){
      return ListView.builder(
        itemCount: datos.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Theme.of(context).colorScheme.primary,
            elevation: 5,
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: ListTile(
                    title: Text(datos[index]["seudonimo"], style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    subtitle: Text(datos[index]["nombre"], style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.center),
                    leading: CircleAvatar(child: Text("${datos[index]["edad"]}"),),
                    trailing: IconButton(

                        onPressed: (){
                          actualizar(datos[index]);
                        },
                        icon: Icon(Icons.edit, color: Colors.white)
                    ),
                  ),
                ),
                ListTile(
                  title: Container(
                    child: Row(
                      children: [
                        const Text("Nacionalidad: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(datos[index]["nacionalidad"])
                      ],
                    ),
                  ),
                  subtitle: Container(
                    child: Row(
                      children: [
                        const Text("Estado Civil: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(datos[index]["casado"] ? "Casado" : "Soltero")
                      ],
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: (){
                        String id = datos[index]["id"];
                        showDialog(
                            context: context,
                            builder: (builder){
                              return AlertDialog(
                                title: Text("Eliminar Streamer"),
                                content: Text("Estas seguro de eliminar a ${datos[index]["seudonimo"]}"),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancelar")
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            DB.eliminar(id).then((value) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Streamer eliminado")));
                                              Navigator.pop(context);
                                              setState(() {
                                                cargarDatos();
                                              });
                                            });
                                          },
                                          child: const Text("Aceptar")
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.delete_outline)
                  ),
                )
              ],
            ),
          );
        },
      );
    }
    return Center(child: CircularProgressIndicator(),);
  }

  void actualizar(Map<String, dynamic> dato){
    String id = dato["id"];
    seudonimo.text = dato["seudonimo"];
    nombre.text = dato["nombre"];
    edad.text = dato["edad"].toString();
    nacionalidad.text = dato["nacionalidad"];
    casado = dato["casado"];

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, state){
              return Container(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: MediaQuery.of(context).viewInsets.bottom+50, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextField(
                              controller: seudonimo,
                              decoration: InputDecoration(
                                  labelText: "Seudonimo:"
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              controller: nombre,
                              decoration: InputDecoration(
                                  labelText: "Nombre:"
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              controller: edad,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Edad:"
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              controller: nacionalidad,
                              decoration: InputDecoration(
                                  labelText: "Nacionalidad:"
                              ),
                            ),
                            SizedBox(height: 20,),
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
                                            state(() {
                                              casado = valor!;
                                            });
                                          }
                                      ),
                                      Text("Casado")
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
                                            state(() {
                                              casado = valor!;
                                            });
                                          }
                                      ),
                                      Text("Soltero")
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FilledButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancelar")
                                ),
                                FilledButton(
                                    onPressed: (){
                                      var streamer = {
                                        "id": id,
                                        "nombre": nombre.text,
                                        "seudonimo": seudonimo.text,
                                        "edad": int.parse(edad.text),
                                        "nacionalidad": nacionalidad.text,
                                        "casado": casado,
                                      };
                                      DB.actualizar(streamer).then((value) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Streamer actualizado")));
                                        setState(() {
                                          cargarDatos();
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text("Actualizar")
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          );
        },
    );
  }

}
