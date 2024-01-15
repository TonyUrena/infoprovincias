import 'dart:convert';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  
  String baseUrl = 'https://node-comarques-rest-server-production.up.railway.app/api/comarques/';
  var comarcaObject;
  if(args.length > 0){

    if(args[0] == "comarcas"){
      var provincia = args[1].toString();
      var url = baseUrl + '$provincia';
      getComarca(url, args[0]);
    }

    if(args[0] == "infocomarca"){
      var comarca = args[1].toString();
      var url = baseUrl + 'infocomarca/$comarca';
      getComarca(url, args[0]);
    }
  }
}

void getComarca(String url, String option){
  var response = http.get(Uri.parse(url));
  response.then((data){
    if (data.statusCode == 200) {
      String body = utf8.decode(data.bodyBytes);
      if(option == "comarcas"){
        
        var listaComarcas = jsonDecode(body) as List;
        List<Comarca> listaComarcasObjetos = [];

        listaComarcas.forEach((comarca) {
          listaComarcasObjetos.add(Comarca(comarca));
        });

        listaComarcasObjetos.forEach((comarca){
          print(comarca.comarca);
        });

      } else if(option == "infocomarca"){
        Comarca comarca = new Comarca.fromJSON(body);
        print(comarca.toString());
      }
    }
  });
}

class Comarca{
  String? comarca, capital, poblacion, img, desc;
  double? latitud, longitud;

  Comarca(
    this.comarca,
    [
      this.capital,
      this.poblacion,
      this.img,
      this.desc,
      this.latitud,
      this.longitud
    ]);
    
  Comarca.fromJSON(String json){
    var bodyDecode = jsonDecode(json) as Map;

          this.comarca = bodyDecode["comarca"];
          this.capital = bodyDecode["capital"];
          this.poblacion = bodyDecode["poblacio"];
          this.img = bodyDecode["img"];
          this.desc = bodyDecode["desc"];
          this.latitud = bodyDecode["latitud"];
          this.longitud = bodyDecode["longitud"];

  }

  String toString(){
    String comarcaString =
      "\n-------------------------------------------------------------\n" + 
      "Nombre: " + this.comarca.toString() + "\n\n" +
      "Capital: " + this.capital.toString() + "\n\n" +
      "Població: " + this.poblacion.toString() + "\n\n" +
      "Imagen: " + this.img.toString() + "\n\n" +
      "Descripció: " + this.desc.toString() + "\n\n" +
      "Coordenades: (" + this.latitud.toString() + ", " + this.longitud.toString() + ")\n" +
      "-------------------------------------------------------------\n";
    return comarcaString;
  }
}