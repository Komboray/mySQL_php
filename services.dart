import 'dart:convert';
import 'products.dart';
import 'package:http/http.dart' as http;


//here all the crud operations are set out, this page allows for linking with the sql tables and all the actions are performed
class Services{
  static const ROOT = "http://192.168.102/Kejazetudb/products.php";

  // http://localhost/phpmyadmin/index.php?route=/database/structure&db=kejazetu
  // "http://localhost//
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const  _GET_ALL_ACTION= 'GET_TABLE';
  static const _ADD_EMP_ACTION = 'ADD_TABLE';
  static const _UPDATE_EMP_ACTION = 'UPDATE_TABLE';
  static const _DELETE_EMP_ACTION = 'DELETE_TABLE';


  //METHOD TO GET THE PRODUCTS

static Future<String> createTable()async {
  try {
    var map = Map<String, dynamic>();
    map['action'] = _CREATE_TABLE_ACTION;
    final response = await http.post(ROOT as Uri, body: map);
    print('Create table response: ${response.body}');
    if (200 == response.statusCode) {
      return response.body;
    } else {
      return "error";
    }
  } catch (e) {
    return "error";
  }
}

  static Future<List<Products>> getProducts() async{
    try{
      var map =Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT as Uri, body: map);
      print('Create table response: ${response.body}');

      if(200 == response.statusCode){
        List<Products> list = parseResponse(response.body);
        return list;
      }else{
        return <Products>[];
      }
    }catch(e){
      return <Products>[];  //return an empty list on exception
    }

  }

  static List<Products> parseResponse(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Products>((json) => Products.fromJson(json)).toList();

  }
  //method to add product to database
  static Future<String> addProducts(String name, String script, var price, var quantity ) async{
     try{
       var map = <String, dynamic>{};
       map['name'] = _ADD_EMP_ACTION;
       map['script'] = script;
       map['price'] = price;
       map['quantity'] = quantity;
       final response = await http.post(ROOT as Uri, body: map);
       print('addProducts Response: ${response.body}');
       if(200 == response.statusCode) {
         return response.body;
       }else{
         return "error";
       }

     }catch(error){
       return "error";
     }
  }

  //METHOD TO UPDATE A PRODUCT
static Future<String> updateProducts(
    int id,String name, String script, int price, int quantity ) async {
  try {
    var map = <String, dynamic>{};
    map['name'] = _UPDATE_EMP_ACTION;
    map['id'] = id;
    map['script'] = script;
    map['price'] = price;
    map['quantity'] = quantity;
    final response = await http.post(ROOT as Uri, body: map);
    print('updateProducts Response: ${response.body}');
    if (200 == response.statusCode) {
      return response.body;
    } else {
      return "error";
    }
  } catch (error) {
    return "error";
  }
}


  static Future<String> deleteProducts(int id,) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _DELETE_EMP_ACTION;
      map['id'] = id;

      final response = await http.post(ROOT as Uri, body: map);
      print('deleteProducts Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (error) {
      return "error";
    }
  }
}
