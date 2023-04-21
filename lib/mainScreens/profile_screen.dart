import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/widgets/info_design_ui.dart';

class ProfileScreen extends StatefulWidget
{
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(width: 5, color: Colors.white),
              ),
              elevation: 20,
              color: const Color(0xFFcc0000),
              margin: const EdgeInsets.fromLTRB(30, 175, 30, 0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20,),

                    Text(
                      userModelCurrentInfo!.name!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Mynerve",
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Icon(
                          Icons.phone_android,
                          size: 30,
                        ),

                        const SizedBox(width: 5,),

                        Text(
                          userModelCurrentInfo!.phone!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Icon(
                          Icons.email_sharp,
                          size: 30,
                        ),

                        const SizedBox(width: 5,),

                        Text(
                          userModelCurrentInfo!.email!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40,),

            Image.asset(
                "images/texastechlogo.jpeg",
              scale: 5,
            ),

            const SizedBox(height: 40,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFcc0000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(width: 3, color: Colors.white,),
                ),
              ),
              onPressed: ()
              {
                SystemNavigator.pop();
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
