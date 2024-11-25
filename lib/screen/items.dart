import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/data.dart';
import 'package:flutter_application_1/widget/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';


class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() {
    if (selectedImage != null &&
        nameController.text != "" &&
        codeController.text != "") {
      String addId = randomAlphaNumeric(16);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImg").child(addId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text(
            'Items',
            style: AppWidget.boldTextFieildStyle(),
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: AppWidget.boldTextFieildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Item name',
                    hintStyle: AppWidget.LightTextFieildStyle(),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Code",
                style: AppWidget.boldTextFieildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Item code',
                    hintStyle: AppWidget.LightTextFieildStyle(),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Upload Image",
                style: AppWidget.boldTextFieildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                    ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String id = randomAlphaNumeric(16);
                    Map<String, dynamic> itemInfoMap = {
                      "name": nameController.text,
                      "code": codeController.text,
                      "id": id
                    };
                    await DatabaseMethods()
                        .addItem(itemInfoMap, id);
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text("Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            )),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
