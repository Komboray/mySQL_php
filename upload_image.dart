import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:php/all_product_data.dart';


class UpIMg extends StatefulWidget {
  const UpIMg({Key? key}) : super(key: key);

  @override
  State<UpIMg> createState() => _UpIMgState();
}

class _UpIMgState extends State<UpIMg> {
  TextEditingController name = TextEditingController();

  // File? file = File(XFile!.path);
  XFile? _image ;
  final picker = ImagePicker();


  chooseImg() async{
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = XFile(pickedImage?.path as String);
    });
  }

  // chooseImg() {
  //   ImagePicker imagePicker = ImagePicker();
  //   setState(() async {
  //    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery) ;
  //    if (file==null) return;
  //    print('${file?.path}');
  //   });
  //
  // }
  Future startUpload() async{
    final uri = Uri.parse("http://192.168.0.102/image_upload_mysql/upload.php");
    var request = http.MultipartRequest('POST', uri);
      request.fields['name'] = name.text;
      var pic = await http.MultipartFile.fromPath("image", _image?.path as String);
      request.files.add(pic);
      var response = await request.send();

      if(response.statusCode == 200){
        print('Image Uploaded');

      }else if(response.statusCode == 400){
        print("Image not uploaded");
      }
      else{
        return const Center(
            child: CircularProgressIndicator());

      }
    }

  
  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(labelText: 'Name',
              ),
              ),
            ),
            IconButton(onPressed: (){
              chooseImg();
            },
                icon: Icon(Icons.camera),
            ),
            Container(
              child: _image == null ?
              const Text('No image Selected')
                  : Image.file(File(_image!.path)),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (){
                startUpload();
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=>AllProducts()));
              },
              child: const Text("Upload an image"),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=>AllProducts()));
              },
              child: const Text("View gallery"),
            ),
          ],
        ),

      ),

    );
  }
}
