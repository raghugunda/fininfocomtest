import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Profile extends StatelessWidget {

  Future<Map<String, dynamic>> fetchData() async {
    final url = 'https://randomuser.me/api/';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API');
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data!;
          debugPrint('response---: $data');
          final results = data['results'];
          final title = results[0]['name']['title'];
          final fname = results[0]['name']['first'];
          final lname = results[0]['name']['last'];
          final city = results[0]['location']['city'];
          final state = results[0]['location']['state'];
          final country = results[0]['location']['country'];
          final postcode = results[0]['location']['postcode'];
          final street = results[0]['location']['street']['name'];
          final email = results[0]['email'];
          final gender = results[0]['gender'];
          final dob = results[0]['dob']['date'];
          final age = results[0]['dob']['age'];
          final registeredDate = DateTime.parse(results[0]['registered']['date']);
          final daysPassed = DateTime.now().difference(DateTime.parse(results[0]['registered']['date'])).inDays;
          final imageUrl = results[0]['picture']['thumbnail'];

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex:5,
                      child:Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent,Colors.blue],
                          ),
                        ),
                        child: Column(
                            children: [
                              SizedBox(height: 110.0,),
                              CircleAvatar(
                                radius: 18,
                                child: ClipOval(
                                  child: Container(
                                    height: 60.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: Colors.red),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text('$title $fname $lname',
                                  style: TextStyle(
                                    color:Colors.white,
                                    fontSize: 18.0,
                                  )),
                              SizedBox(height: 10.0,),

                            ]
                        ),
                      ),
                    ),

                    Expanded(
                      flex:5,
                      child: Container(
                        color: Colors.grey[200],
                        child: Center(
                            child:Card(
                                margin: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 20.0),
                                child: Container(

                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Information",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w800,
                                            ),),
                                          Divider(color: Colors.grey[300],),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: Colors.blueAccent[400],
                                                size: 35,
                                              ),
                                              SizedBox(width: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Location",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),),
                                                  Text("$street,$city,\n$state,$country,$postcode",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),)
                                                ],
                                              )

                                            ],
                                          ),
                                          SizedBox(height: 20.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: Colors.blue[400],
                                                size: 35,
                                              ),
                                              SizedBox(width: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("DOB",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),),
                                                  Text("$dob",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),)
                                                ],
                                              )

                                            ],
                                          ),
                                          SizedBox(height: 20.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.mail,
                                                color: Colors.pinkAccent[400],
                                                size: 35,
                                              ),
                                              SizedBox(width: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Email",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),),
                                                  Text("$email",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),)
                                                ],
                                              )

                                            ],
                                          ),
                                          SizedBox(height: 20.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.people,
                                                color: Colors.lightGreen[400],
                                                size: 35,
                                              ),
                                              SizedBox(width: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Date Of Registered",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),),
                                                  Text("$registeredDate",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),)
                                                ],
                                              )

                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                )
                            )
                        ),
                      ),
                    ),

                  ],
                ),
                Positioned(
                    top:MediaQuery.of(context).size.height*0.45,
                    left: 20.0,
                    right: 20.0,
                    child: Card(
                        child: Padding(
                          padding:EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  child:Column(
                                    children: [
                                      Text('Gender',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0
                                        ),),
                                      SizedBox(height: 5.0,),
                                      Text("$gender",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),)
                                    ],
                                  )
                              ),

                              Container(
                                child: Column(
                                    children: [
                                      Text('No of days',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0
                                        ),),
                                      SizedBox(height: 5.0,),
                                      Text('$daysPassed',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),)
                                    ]),
                              ),

                              Container(
                                  child:Column(
                                    children: [
                                      Text('Age',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0
                                        ),),
                                      SizedBox(height: 5.0,),
                                      Text('$age',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),)
                                    ],
                                  )
                              ),
                            ],
                          ),
                        )
                    )
                )
              ],
        ),
          );
        }
      },
    );
  }
}