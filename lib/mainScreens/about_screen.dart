import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget
{

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              const Text(
                "Developed By: ",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              SizedBox(height: 10,),

              // Roy
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child:
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(child: Image.asset("images/roy.jpeg"),),
                      ),
                    ),

                    const SizedBox(width: 52,),

                    Column(
                      children:[
                        const Text(
                          "Arnob Roy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: "Mynerve",
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(height: 6,),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  text: "github.com/drroyjr44",
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    var url = "https://github.com/drroyjr44";
                                    if(await canLaunch(url)) {
                                      await launch(url);
                                    }
                                    else {
                                      throw "Cannot load Url";
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arjun
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child:
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ClipOval(child: Image.asset("images/arjun.jpeg"),),
                          ),
                        ),

                        const SizedBox(width: 28,),

                        Column(
                          children:[
                            const Text(
                              "Arjun Ramsinghani",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontFamily: "Mynerve",
                                color: Colors.red,
                              ),
                            ),

                            SizedBox(height: 6,),

                            RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: TextStyle(color: Colors.blue),
                                      text: "github.com/aramsing",
                                      recognizer: TapGestureRecognizer()..onTap = () async {
                                        var url = "https://github.com/aramsing";
                                        if(await canLaunch(url)) {
                                          await launch(url);
                                        }
                                        else {
                                          throw "Cannot load Url";
                                        }
                                      }
                                    ),
                                  ],
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ),

              // Dylan
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child:
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(child: Image.asset("images/dylan.jpeg"),),
                      ),
                    ),

                    const SizedBox(width: 48,),

                    Column(
                      children:[
                        const Text(
                          "Dylan Sheehan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: "Mynerve",
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(height: 6,),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  text: "github.com/dsheehan2",
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    var url = "https://github.com/dsheehan2";
                                    if(await canLaunch(url)) {
                                      await launch(url);
                                    }
                                    else {
                                      throw "Cannot load Url";
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Jacobie
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child:
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(child: Image.asset("images/jacobie.jpeg"),),
                      ),
                    ),

                    const SizedBox(width: 26,),

                    Column(
                      children:[
                        const Text(
                          "Jacobie Rowland",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: "Mynerve",
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(height: 6,),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  text: "linkedin.com/jacobie-rowland",
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    var url = "https://www.linkedin.com/in/jacobie-rowland-141a35138/";
                                    if(await canLaunch(url)) {
                                      await launch(url);
                                    }
                                    else {
                                      throw "Cannot load Url";
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Jerome
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child:
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(child: Image.asset("images/jerome.png"),),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    Column(
                      children:[
                        const Text(
                          "Jerome Cala",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: "Mynerve",
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(height: 6,),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  text: "github.com/jacala09",
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    var url = "https://github.com/jcala09";
                                    if(await canLaunch(url)) {
                                      await launch(url);
                                    }
                                    else {
                                      throw "Cannot load Url";
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Isman
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child:
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(child: Image.asset("images/isman.jpg"),),
                      ),
                    ),

                    const SizedBox(width: 36,),

                    Column(
                      children:[
                        const Text(
                          "Isman Daiyrov",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: "Mynerve",
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(height: 6,),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  text: "github.com/IsmanDaiyrov",
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    var url = "https://github.com/IsmanDaiyrov";
                                    if(await canLaunch(url)) {
                                      await launch(url);
                                    }
                                    else {
                                      throw "Cannot load Url";
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: ()
                {
                  SystemNavigator.pop();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ],
            ),
        ),
      ),
    );
  }
}
