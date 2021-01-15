import 'dart:io';
import 'package:firebase/products.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'main.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var priceController = TextEditingController();

  Builder buildDialogItem(BuildContext context, String text, IconData icon, ImageSource src) {
    return Builder(
      builder: (innerContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(text),
          onTap: () {
            context.read<Products>().getImage(src);
            Navigator.of(innerContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    File _image = Provider.of<Products>(context, listen: true).image;

    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MyApp())),
      child: Scaffold(
        appBar: AppBar(
            title: Text('Add Product'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => MyApp())),
            )),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              TextField(
                decoration:
                    InputDecoration(labelText: "Title", hintText: "Add Title"),
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Description", hintText: "Add Description"),
                controller: descController,
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: "Price", hintText: "Add Price"),
                controller: priceController,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Choose Image"),
                  onPressed: () {
                    var ad = AlertDialog(
                      title: Text("Choose Picture from:"),
                      content: Container(
                        height: 150,
                        child: Column(
                          children: [
                            Divider(color: Colors.black),
                            buildDialogItem(context, "Camera", Icons.add_a_photo_outlined, ImageSource.camera),
                            SizedBox(height: 10),
                            buildDialogItem(context, "Gallery", Icons.image_outlined, ImageSource.gallery),
                          ],
                        ),
                      ),
                    );
                    showDialog(context: context, child: ad);
                  },
                ),
              ),
              SizedBox(height: 30),
              Consumer<Products>(
                builder: (ctx, value, _) => RaisedButton(
                  color: Colors.orangeAccent,
                  textColor: Colors.black,
                  child: Text("Add Product"),
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        descController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      Toast.show("Please enter all Fields", ctx,
                          duration: Toast.LENGTH_LONG);
                    } else if (_image == null) {
                      Toast.show("Please select an image", ctx,
                          duration: Toast.LENGTH_LONG);
                    } else {
                      try {
                        value.add(
                          title: titleController.text,
                          description: descController.text,
                          price: double.parse(priceController.text),
                        );
                        value.deleteImage();
                        await Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => MyApp()));
                      } catch (e) {
                        Toast.show("Please enter a valid price", ctx,
                            duration: Toast.LENGTH_LONG);
                        print(e);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
