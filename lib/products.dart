import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final File image;

  Product({@required this.id, @required this.title, @required this.description,
    @required this.price,
    @required this.image,
  });
}

class Products with ChangeNotifier {
  List<Product> productsList = [];
  File image;

  void add({String title, String description, double price}) {
    final String url="https://fire1-bc229-default-rtdb.firebaseio.com/product.json";
    http.post(url,body:json.encode({
      'title':title,
      'description':description,
      'price':price,
    }));
    productsList.add(Product(
        id: 1,
        title: title,
        description: description,
        price: price,
        image: image));
    notifyListeners();
  }

  void delete(String description) {
    productsList.removeWhere((element) => element.description == description);
    notifyListeners();
  }

  void deleteImage() {
    image = null;
  }

  Future getImage(ImageSource src) async {
    final pickedFile = await ImagePicker().getImage(source: src);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
      print('Image selected.');
    } else {
      print('No image selected.');
    }
  }
}
