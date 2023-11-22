import 'package:cloud_firestore/cloud_firestore.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{

  static Future insertar(Map<String, dynamic> streamer) async{
    return await  baseRemota.collection("streamer").add(streamer);
  }

  static Future<List> mostrarTodos() async{
    List temp= [];
    var datos = await baseRemota.collection("streamer").get();
    datos.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({"id": element.id});
      temp.add(dato);
    });
    return temp;
  }

  static Future actualizar(Map<String, dynamic> streamer){
    String id = streamer["id"];
    streamer.remove("id");
    return baseRemota.collection("streamer").doc(id).update(streamer);
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("streamer").doc(id).delete();
  }
}