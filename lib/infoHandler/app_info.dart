import 'package:flutter/material.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/trips_history_model.dart';

class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripKey = [];
  List<TripHistoryModel> allTripHistoryInfoList = [];

  void updatePickupLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverallTripCounter(int tripCounter)
  {
    countTotalTrips = tripCounter;
    notifyListeners();
  }

  updateOverallTripKey(List<String> tripKeyList)
  {
    historyTripKey = tripKeyList;
    notifyListeners();
  }

  updateOverallTripHistoryInfo(TripHistoryModel eachTripHistory)
  {
    allTripHistoryInfoList.add(eachTripHistory);
    notifyListeners();
  }
}