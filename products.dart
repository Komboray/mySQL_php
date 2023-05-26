
//this is a form of product schema that describes the details of the products in the database

class Products{
  late int id;
  late String name;
  late String script;
  late int qunatity;
  late int price;

 Products({required this.id, required this.name, required this.price, required this.qunatity, required this.script});

 factory Products.fromJson(Map<String, dynamic> json){


//this method returns the data inform of json which is coverted later to proper data in the database
   return Products(id: json['id'] as int,
       name: json['name'] as String,
       script: json['script'] as String,
       price: json['price'] as int,
       qunatity: json['qunatity'] as int,

   );
 }

}
