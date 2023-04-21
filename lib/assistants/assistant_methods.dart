import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/trips_history_model.dart';
import 'package:users_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class AssistantMethods
{
  static Future<String> searchAddressForGeographicalCoOrdinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occurred, Failed. No response")
    {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAddress(userPickupAddress);
    }
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        //print("name = ${userModelCurrentInfo!.name}");
        //print("email = ${userModelCurrentInfo!.email}");
      }
    });
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionAPI = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionAPI == "Error Occurred, Failed. No response")
    {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionAPI["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionAPI["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionAPI["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionAPI["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionAPI["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  // CHANGE THIS TO CALCULATE THE FARE FOR TTU
  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFarePerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFarePerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.1;
    double totalFareAmount = timeTraveledFarePerMinute + distanceTraveledFarePerKilometer;
    
    return double.parse(totalFareAmount.toStringAsFixed(2));
  }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map<String, String> bodyNotification =
    {
      "body": "Destination Address: \n$destinationAddress.",
      "title": "Raider Ride Request"
    };

    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken
    };

    var responseNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat)
    );
  }

  // Trip key = ride request key. Retrieve the trips key for online user
  static void readTripKeyForOnlineUser(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("userName")
        .equalTo(userModelCurrentInfo!.name)
        .once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        Map keyTripId = snap.snapshot.value as Map;

        // Count number of trips share with Provider
        int tripCounter = keyTripId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverallTripCounter(tripCounter);

        // share trip key with Provider
        List<String> tripKeyList = [];
        keyTripId.forEach((key, value)
        {
          tripKeyList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverallTripKey(tripKeyList);

        // trip key data
        readTripHistoryInformation(context);
      }
    });
  }

  static void readTripHistoryInformation(context)
  {
    var tripAllKey = Provider.of<AppInfo>(context, listen: false).historyTripKey;

    for(String eachKey in tripAllKey)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap)
      {
        var eachTripHistory = TripHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended")
          {
            // add each history to OverallTrip History Data List
            Provider.of<AppInfo>(context, listen: false).updateOverallTripHistoryInfo(eachTripHistory);
          }
      });
    }
  }
}