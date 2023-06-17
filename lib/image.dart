import 'dart:convert';
import 'package:fininfocom/response/imageresp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class Images extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Images> {
  late List data;
  late Future<ImageData> imageData;
  List imagesUrl = [];

  @override
  void initState() {
    super.initState();
    imageData = fetchImages();
  }

  Future<ImageData> fetchImages() async {
    final response = await http
        .get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      return ImageData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Images'),
        centerTitle: true,
      ),
      body:Column(
        children: [
          SizedBox(width: 24,height: 30,),
          FutureBuilder<ImageData>(
            future: imageData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.network(
                  snapshot.data!.message,
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return Center(child: const CircularProgressIndicator());
            },
          ),
          SizedBox(width: 24,height: 30,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              elevation: 5,

              padding: const EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              setState(() {
                imageData = fetchImages();
              });

            },
            child: Text(
              "Refresh",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

    );
  }
}