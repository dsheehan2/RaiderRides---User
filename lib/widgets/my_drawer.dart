import 'package:flutter/material.dart';
import 'package:users_app/mainScreens/about_screen.dart';
import 'package:users_app/mainScreens/profile_screen.dart';
import 'package:users_app/mainScreens/trips_history_screen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:users_app/global/global.dart';

class MyDrawer extends StatefulWidget
{
  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 165,
            color: Colors.red,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  const Icon(
                    MdiIcons.accountCowboyHat,
                    size: 80,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 16,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                          widget.email.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12,),

          //drawer body
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.white54,),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white54
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(MdiIcons.accountCowboyHat, color: Colors.white54,),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                    color: Colors.white54
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c) => AboutScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.white54,),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.white54
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.white54,),
              title: Text(
                "Sign Out",
                style: TextStyle(
                    color: Colors.white54
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
