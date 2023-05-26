import 'package:flutter/material.dart';
import 'products.dart';
import 'services.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  final String title = 'Data Table';

  @override
  State<Home> createState() => _HomeState();
}

//the below controllers allow the user to enter the name description, quantity and price of the product/image being added
class _HomeState extends State<Home> {
  late List<Products> _products;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController name = TextEditingController();
  late TextEditingController quantity = TextEditingController();
  late TextEditingController script = TextEditingController();
  late TextEditingController price = TextEditingController();
  late Products _selectedProducts;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState(){
    super.initState();
    _products = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    name =TextEditingController();
    quantity =TextEditingController();
    script =TextEditingController();
    price =TextEditingController();
    _getProducts();
  }
  //method to update title in the appbar
  _showProgress(String message){
    setState(() {
      _titleProgress = message;
    });
  }
//method to show the process of the submition of the document/file
  _showSnackBar(context, message){
    ScaffoldMessenger
        .of(context)
        .showSnackBar(
        SnackBar(content: Text(message),
        ),
    );
  }
//this method is used to ceate the table into the database
  _createTable(){
    _showProgress("Creating table");
    Services.createTable().then((value) {
      if('success' == value){
        _showSnackBar(context, value);
        _showProgress(widget.title);
      }
    });
  }
  
  //checks and ensures that the user actually inputs fields into the textfields, if no item or text is enetered,the process will not be able to work
  _addProducts(){
    if(name.text.isEmpty || quantity.text.isEmpty ||script.text.isEmpty||price.text.isEmpty){
      print('Empty Field');
      return;
    }
    _showProgress('Adding Product');
    Services.addProducts(name.text, script.text, price.text, quantity.text).then((value) {
      if('succcess' == value){
        _getProducts();
        _clearValue();
      }

    });
  }
  //this method receives the products from the database and displays them into the application 
  _getProducts(){
    _showProgress('Loading Product...');
    Services.getProducts().then((products) {
      setState(() {
        _products = products;
      });
      _showProgress(widget as String);
      print("Length ${products.length}");
    });
  }
  
  //the products have been updated
  _updateProducts(Products products){
    _showProgress("Updating progress");
    Services.updateProducts(products.id, name.text, script.text, price.value as int, quantity.value as int).then((value) {
      if('succcess' == value){
        setState(() {
          _isUpdating = false;
        });
        _clearValue();
      }
    });
  }
  _deleteProducts(Products products){
    _showProgress('Deleting Products');
    Services.deleteProducts(products.id).then((value) {
      if('succcess' == value){

      }
    });
  }

  //clear textfield values
  _clearValue(){
    name.text = '';
    quantity.text = '';
    script.text = '';
    price.text = '';
  }

  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      //Both vertcal and horizontal
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID'),
            ),
            DataColumn(label: Text('NAME'),
            ),
            DataColumn(label: Text('SCRIPT'),
            ),
            DataColumn(label: Text('PRICE'),
            ),
            DataColumn(label: Text('QUANTITY'),
            ),
          ],
          rows: _products.map((products) => DataRow(
              cells: [
                DataCell(
                  Text(products.id.toString()),
                ),
                DataCell(
                  Text(products.name.toUpperCase()),
                ),
                DataCell(
                  Text(products.script.toString()),
                ),
                DataCell(
                  Text(products.price.toString()),
                ),
                DataCell(
                  Text(products.qunatity.toString()),
                ),
              ]
          ),
          ).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: [
          IconButton(
              onPressed: (){
                _createTable();
              },
              icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: (){
              _getProducts();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: name,
              decoration: const InputDecoration.collapsed(
                  hintText: "Name",
              ),
            ),
            ),
            Padding(padding: const EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: quantity,
                decoration: const InputDecoration.collapsed(
                  hintText: "quantity",
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: script,
                decoration: const InputDecoration.collapsed(
                  hintText: "description",
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: price,
                decoration: const InputDecoration.collapsed(
                  hintText: "price",
                ),
              ),
            ),
            //add an update button and a cancel button
            //shgow these buttons only when updating an employee
            _isUpdating
            ?Row(
              children: [
                OutlinedButton(
                    onPressed: (){
                      // _updateProducts();
                    },
                    child: const Text('UPDATE'),
                ),
                OutlinedButton(
                  onPressed: (){
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValue();
                  },
                  child: const Text('CANCEL'),
                ),

              ],
            ): Container(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addProducts();
        },
        child: Icon(Icons.add),

      ),
    );
  }
}

