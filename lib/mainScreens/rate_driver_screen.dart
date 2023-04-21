import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:users_app/global/global.dart';

class RateDriverScreen extends StatefulWidget
{
  String? assignedDriverId;

  RateDriverScreen({this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white60,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 22,),
              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                ),
              ),

              const SizedBox(height: 22,),

              const Divider(
                height: 4.0,
                thickness: 4.0,
              ),

              const SizedBox(height: 22,),

              SmoothStarRating(
                rating: countRatingStar,
                allowHalfRating: true,
                starCount: 5,
                size: 46,
                onRatingChanged: (valueOfStarsChoosed)
                {
                  countRatingStar = valueOfStarsChoosed;

                  if(countRatingStar == 1)
                  {
                    setState(() {
                      titleStarRating = "Very Bad";
                    });
                  }

                  if(countRatingStar == 2)
                  {
                    setState(() {
                      titleStarRating = "Bad";
                    });
                  }

                  if(countRatingStar == 3)
                  {
                    setState(() {
                      titleStarRating = "Normal";
                    });
                  }

                  if(countRatingStar == 4)
                  {
                    setState(() {
                      titleStarRating = "Good";
                    });
                  }

                  if(countRatingStar == 5)
                  {
                    setState(() {
                      titleStarRating = "Very Good";
                    });
                  }
                },
              ),

              const SizedBox(height: 12,),

              Text(
                titleStarRating,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 18,),

              ElevatedButton(
                  onPressed: ()
                  {
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref()
                        .child("drivers")
                        .child(widget.assignedDriverId!)
                        .child("ratings");

                    rateDriverRef.once().then((snap)
                    {
                      if(snap.snapshot.value == null)
                      {
                        rateDriverRef.set(countRatingStar.toString());
                        Fluttertoast.showToast(msg: "Please restart App Now");
                        SystemNavigator.pop();
                      }
                      else
                      {
                        double pastRatings = double.parse(snap.snapshot.value.toString());
                        double newRating = (pastRatings + countRatingStar) / 2;
                        rateDriverRef.set(newRating.toString());
                      }
                    });


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 74),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ),

              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
