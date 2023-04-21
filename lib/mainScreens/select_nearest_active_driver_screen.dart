import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';


class SelectNearestActiveDriversScreen extends StatefulWidget
{
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriversScreen> createState() => _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen>
{
  // THIS IS OPTIONAL, TTU DOES NOT NEED SPECIFIC INDEX DRIVERS (X, Go, Bike)
  String fareAmount = "";
  getFareAmountAccordingToVehicleType(int index)
  {
    if(tripDirectionDetailsInfo != null)
      {
        if(dList[index]["car_details"]["type"].toString() == "bike")
          {
            fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) / 2).toStringAsFixed(2);
          }
        if(dList[index]["car_details"]["type"].toString() == "uber-x") // executive type of car
        {
          fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2).toStringAsFixed(2);
        }
        if(dList[index]["car_details"]["type"].toString() == "uber-go") // regular type of car
        {
          fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toString();
        }
      }

    return fareAmount;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Nearest Online TTU Drivers",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black54,
          ),
          onPressed: ()
          {
            // DELETE/REMOVE THE RIDE REQUEST FROM DATABASE
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg: "You have cancelled the ride request.");

            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
          itemCount: dList.length,
          itemBuilder: (BuildContext context, int index)
          {
            return GestureDetector(
              onTap: ()
              {
                setState(() {
                  chosenDriverId = dList[index]["id"].toString();
                });
                Navigator.pop(context, "driverChoosed");
              },
              child: Card(
                color: Colors.red,
                elevation: 3,
                shadowColor: Colors.red,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Image.asset(
                      // ignore: prefer_interpolation_to_compose_strings
                      "images/" + dList[index]["car_details"]["type"].toString() + ".png",
                      width: 70,
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dList[index]["name"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dList[index]["car_details"]["car_model"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      SmoothStarRating(
                        rating: 3.5,
                        color: Colors.black,
                        borderColor: Colors.black,
                        allowHalfRating: true,
                        starCount: 5,
                        size: 15,
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$" + getFareAmountAccordingToVehicleType(index),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.distance_text! : "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
      ),
    );
  }
}
