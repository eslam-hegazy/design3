import 'dart:convert';

import 'package:firebase/products.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_products.dart';
import 'package:http/http.dart'as http;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final String url="https://fire1-bc229-default-rtdb.firebaseio.com/product.json";
  http.post(url,body:json.encode({
    'id':1,
    'title':"eslam",
    'description':"we are welcome"
  }));
  //
  // DatabaseReference _ref=FirebaseDatabase.instance.reference();
  // _ref.child("product").set(12);
  //
  //

  runApp(
    ChangeNotifierProvider<Products>(
      create: (_) => Products(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange,
          canvasColor: Color.fromRGBO(255, 238, 219, 1)),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> prodList =
        Provider.of<Products>(context, listen: true).productsList;

    Widget buildText(title, desc, double price) {
      var description =
          desc.length >= 20 ? desc.replaceRange(20, desc.length, '...') : desc;
      return Positioned(
        bottom: 10,
        right: 10,
        child: Container(
          width: 180,
          color: Colors.black54,
          margin: EdgeInsets.only(left: 100, top: 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Text(
            "$title\n$description\n\$$price",
            style: TextStyle(fontSize: 26, color: Colors.white),
            softWrap: true,
            overflow: TextOverflow.fade,
            maxLines: 4,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('My Products')),
      body: prodList.isEmpty
          ? Center(
              child: Text('No Products Added.', style: TextStyle(fontSize: 22)))
          : GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                maxCrossAxisExtent:  500,
                childAspectRatio: 2,
              ),
              children: prodList
                  .map(
                    (item) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 6,
                      margin: EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.file(item.image, fit: BoxFit.cover),
                          ),
                          buildText(item.title, item.description, item.price),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: FloatingActionButton(
                              heroTag: item.description,
                              backgroundColor: Theme.of(context).primaryColor,
                              onPressed: () =>
                                  Provider.of<Products>(context, listen: false)
                                      .delete(item.description),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
      floatingActionButton: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).primaryColor,
        ),
        child: FlatButton.icon(
          label: Text("Add Product",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          icon: Icon(Icons.add),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => AddProduct())),
        ),
      ),
    );
  }
}
