import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Innit extends StatefulWidget {
  const Innit({Key? key}) : super(key: key);

  @override
  State<Innit> createState() => _InnitState();
}

class _InnitState extends State<Innit> {
  static const ADD_CATEGORY_URL = "http://192.168.0.107/test/actions.php";

  TextEditingController nameT = TextEditingController();
  bool checkStatus = false;
  late int categoryStatus;
  late String bs4str;


  XFile? imageFile;
   late var imageData;
  final pick = ImagePicker();
  late File image;

   chooseImage() async{
    var pickedIm = await pick.pickImage(source: ImageSource.gallery);
    //the picked image from the gallery will return an xfile
    if(pickedIm != null) {
      setState(() {
        imageFile = XFile(pickedIm!.path);
        //added this one below
        image = File(imageData!.path);
      });
      // imageData = base64Encode(imageFile?.readAsBytes() as List<int>);
      Uint8List imgbytes = await image.readAsBytes();
       bs4str = base64.encode(imgbytes);
       // image = base64Encode(imageFile?.readAsBytes() as List<int>);
      // return imageData;
    // }
    // else{
    //   return null;
    }
    return bs4str;
  }

  Future addCategory() async{
    var data = {
      "name": nameT.text,
      "image":imageData,
      "status": categoryStatus.toString(),
    };
    var response = await http.post(ADD_CATEGORY_URL as Uri, body: data);
    if(response.statusCode == 200){
      print(response.body);
      const SnackBar(content: Text("SUCCESS"));
    }

  }
  Image showImage(String image){
    return Image.memory(base64Decode(image));
  }
  @override
  void initState(){
    imageData = "";
    File image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: TextField(
                controller: nameT,
                decoration: const InputDecoration(labelText: 'Name',
                ),
              ),
            ),
            SizedBox(height: 20,),
             Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 25),
                child: IconButton(
                    onPressed: (){
                      chooseImage();
                    },
                    icon: Icon(Icons.image)),
                ),
                
              ],
            ),
           image == null ? const Text("No image selected") :
           Container(
             child: image == null ?
             const Text('No image Selected')
                 : SizedBox(
                 height: 200,
                 child: Image.file(File(image!.path))),
           ),

            const SizedBox(height: 5,),
            Card(
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 25),
                    child: Text("ACTIVE",
                    style: TextStyle(fontWeight: FontWeight.bold),

                    ),
                  ),
                  Checkbox(value: checkStatus,
                      onChanged: (newVal){
                    setState(() {
                      checkStatus = newVal!;
                    });
                    if(checkStatus){
                      categoryStatus = 1;
                    }else{
                      categoryStatus = 0;
                    }
                    print(categoryStatus);
                      }
                  ),
                  SizedBox(width: 30,),
                  Padding(padding: EdgeInsets.only(left: 0),
                  child: MaterialButton(
                    color: Colors.purple,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: (){
                      addCategory();
                      }
                  ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 15),
                    child: MaterialButton(
                        color: Colors.red[300],
                        child: const Text(
                          'cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: (){}
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
