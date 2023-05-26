import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {

  Future allProducts() async{
    final uri = Uri.parse("http://192.168.0.102/image_upload_mysql/view.php");
    // var url = "http://192.168.0.102/image_upload_mysql/view.php";

    var response = await http.get(uri);
    return json.decode(response.body);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
      ),
      body: FutureBuilder(
        future: allProducts(),
        builder: (context, snapshot){
          if(snapshot.hasError)print(snapshot.error);

        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data?.length,
            itemBuilder: (context, index){    List list = snapshot.data;
          return Card(
            child: ListTile(
              title: Container(
                width: 100,
                height: 100,
                child: Image.network("http://192.168.0.102/image_upload_mysql/uploads${list[index]['image']}"),
              ),
              subtitle: Text(list[index]['name']),
            ),
          );
        }): const Center(child: CircularProgressIndicator(),);
      },),
    );
  }
}
