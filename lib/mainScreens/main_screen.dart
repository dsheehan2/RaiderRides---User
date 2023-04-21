import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/assistants/geofire_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/mainScreens/rate_driver_screen.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:users_app/models/active_nearby_available_drivers.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:users_app/widgets/pay_fare_amount_dialog.dart';
import 'package:users_app/widgets/progress_dialog.dart';


class MainScreen extends StatefulWidget
{
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;
  double topPaddingOfMap = 0;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "Your Name";
  String userEmail = "Your TTU Email";


  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  List <ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Driver is coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userRideRequestStatus = "";
  bool requestPositionInfo = true;




  blackThemeGoogleMap()
  {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicalCoOrdinates(userCurrentPosition!, context);
    print("this is your address = $humanReadableAddress");

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();

    AssistantMethods.readTripHistoryInformation(context);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation()
  {
    // save the RideRequest Information
    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push(); // Generates IDs for Ride Requesting

    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap =
    {
      "latitude" : originLocation!.locationLatitude.toString(),
      "longitude" : originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap =
    {
      "latitude" : destinationLocation!.locationLatitude.toString(),
      "longitude" : destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap =
    {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId" : "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap) async
    {
      if(eventSnap.snapshot.value == null)
      {
        return;
      }

      if((eventSnap.snapshot.value as Map)["car_details"] != null)
      {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["driverPhone"] != null)
      {
        setState(() {
          driverPhone = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["driverName"] != null)
      {
        setState(() {
          driverName = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["status"] != null)
      {
        userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if((eventSnap.snapshot.value as Map)["driverLocation"] != null)
      {
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        // accepted
        if(userRideRequestStatus == "accepted")
        {
          updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng);
        }

        // arrived
        if(userRideRequestStatus == "arrived")
        {
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }

        // on trip
        if(userRideRequestStatus == "on trip")
        {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        // ended
        if(userRideRequestStatus == "on trip")
        {
          if((eventSnap.snapshot.value as Map)["fareAmount"] != null)
          {
            double fareAmount = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());

            var response = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext c) => PayFareAmountDialog(
                    fareAmount: fareAmount,
                ),
            );

            if(response == "cashPayed")
            {
              // User can rate driver now
              if((eventSnap.snapshot.value as Map)["driverId"] != null)
              {
                String assignedDriverId = (eventSnap.snapshot.value as Map)["driverId"].toString();

                Navigator.push(context, MaterialPageRoute(builder: (c) => RateDriverScreen(
                  assignedDriverId: assignedDriverId,
                )));

                referenceRideRequest!.onDisconnect();

                tripRideRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }
    });

    onlineNearByAvailableDriversList = GeofireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;
      LatLng userPickUpPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
          driverCurrentPositionLatLng, userPickUpPosition,
      );

      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Driver is Coming :: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDropOffPosition = LatLng(dropOffLocation!.locationLatitude!, dropOffLocation!.locationLongitude!);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDropOffPosition,
      );

      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Driver reaching Destination :: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async
  {
    // No active driver available
    if(onlineNearByAvailableDriversList.isEmpty)
      {
        // Cancel / Remove the Ride Request Information
        referenceRideRequest!.remove();

        // cancel the RideRequest Information
        setState(() {
          polyLineSet.clear();
          markerSet.clear();
          circleSet.clear();
          pLineCoordinatesList.clear();
        });

        Fluttertoast.showToast(msg: "No online Nearest Driver Available. Restarting...");
        referenceRideRequest!.remove(); // for security

        Future.delayed(const Duration(milliseconds: 4000), () {
          SystemNavigator.pop();
        });

        return;
      }

    // Active driver available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    // ignore: use_build_context_synchronously
    var response = await Navigator.push(context, MaterialPageRoute(builder: (c) => SelectNearestActiveDriversScreen(referenceRideRequest: referenceRideRequest)));

    if (response == "driverChoosed"){
      FirebaseDatabase.instance.ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null){
          // send notification to that specific driver
          sendNotificationToDriverNow(chosenDriverId!);

          // Display Waiting Response from Driver
          showWaitingResponseFromDriverUI();

          // Wait for Driver Response
          FirebaseDatabase.instance.ref()
              .child("drivers")
              .child(chosenDriverId!)
              .child("newRideStatus")
              .onValue.listen((eventSnapshot)
          {
            // 1. Driver has canceled the rideRequest Notification
            // (newRideStatus == idle)
            if(eventSnapshot.snapshot.value == "idle")
            {
              Fluttertoast.showToast(msg: "The driver has cancelled your request. Please choose another driver.");

              Future.delayed(const Duration(milliseconds: 3000), ()
              {
                Fluttertoast.showToast(msg: "Please Restart App Now.");

                SystemNavigator.pop();
              });
            }

            // 2. Driver has accepted the rideRequest Notification
            // (newRideStatus == accepted)
            if(eventSnapshot.snapshot.value == "accepted")
            {
              // display UI for assigned driver info
              showUIForAssignedDriverInfo();
            }
          });


        }
        else{
          Fluttertoast.showToast(msg: "This driver does not exist. Try again.");
        }
      });
    }
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 240;
    });
  }

  showWaitingResponseFromDriverUI()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId)
  {
    // assign rideRequestId to newRideStatus in Drivers Parent node for that
    // specific chosen driver
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId!)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);


    // automate the push notification
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId!)
        .child("token")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
        {
          String deviceRegistrationToken = snap.snapshot.value.toString();

          // send notification NOW
          AssistantMethods.sendNotificationToDriverNow(
              deviceRegistrationToken,
              referenceRideRequest!.key.toString(),
              context
          );

          Fluttertoast.showToast(msg: "Notification sent Successfully");
        }
      else
        {
          Fluttertoast.showToast(msg: "Driver not registered, choose another driver");
          return;
        }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for(int i = 0; i < onlineNearestDriversList.length; i++)
      {
        await ref.child(onlineNearestDriversList[i].driverId.toString())
            .once()
            .then((dataSnapshot) {
              var driverKeyInfo = dataSnapshot.snapshot.value;
              dList.add(driverKeyInfo);
        });
      }
  }

  @override
  Widget build(BuildContext context)
  {
    createActiveNearbyDriverIconMarker();
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 300,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
              name: userName,
              email: userEmail,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [

          GoogleMap(
            // light mode
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap, top: topPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markerSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              // dark mode
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 230;
                topPaddingOfMap = 25;
              });

              locateUserPosition();
            },
          ),

          //custom hamburger button for drawer
          Positioned(
            top: 36,
            left: 22,
            child: GestureDetector(
              onTap: ()
              {
                if(openNavigationDrawer){
                  sKey.currentState!.openDrawer();
                }
                else{
                  // Restart-refresh-minimize app programmatically
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      //from
                      Row(
                        children: [
                          const Icon(MdiIcons.car, color: Colors.red),
                          const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style: TextStyle(color: Colors.red, fontSize: 14),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickUpLocation != null
                                    ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
                                    : "your current location",
                                style: const TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 16),

                      //to
                      GestureDetector(
                        onTap: () async
                        {
                          //search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropoff")
                            {
                              setState(() {
                                openNavigationDrawer = false;
                              });

                              //draw routes - draw polyline
                              await drawPolyLineFromOriginToDestination();
                            }
                        },
                        child: Row(
                          children: [
                            const Icon(MdiIcons.mapMarkerStar, color: Colors.red),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To",
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                   ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "Where to go",
                                  style: const TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: ()
                        {
                          if(Provider.of<AppInfo>(context, listen: false).userPickUpLocation != null)
                            {
                              saveRideRequestInformation();
                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "Please select destination location");
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text(
                            "Request Ride",
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          // UI for waiting response from driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Waiting for Response\nfrom Driver',
                        duration: const Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      ScaleAnimatedText(
                        'Please wait...',
                        duration: const Duration(seconds: 10),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(fontSize: 32.0, color: Colors.white, fontFamily: 'Canterbury'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // UI for displaying assigned driver info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(height: 20,),

                    // driver name
                    Text(
                      driverName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 2,),

                    // driver vehicle details
                    Text(
                      driverCarDetails,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 20,),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(height: 20,),

                    // call driver button
                    Center(
                      child: ElevatedButton.icon(
                          onPressed: ()
                          {

                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                          icon: const Icon(
                            Icons.phone_android,
                            color: Colors.black54,
                            size: 22,
                          ),
                          label: const Text(
                            "Call Driver",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async
  {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait..."),
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    //print("These are points = ");
    //print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoordinatesList.clear();

    if(decodedPolylinePointsResultList.isNotEmpty)
    {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng)
      {
        pLineCoordinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }

    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }

    else if(originLatLng.latitude > destinationLatLng.latitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId:  const CircleId("originID"),
      fillColor: Colors.cyan,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId:  const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

  initializeGeoFireListener()
  {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {

          // whenever any driver is online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeofireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUserMap();
            }
            break;

          // whenever any driver is not offline
          case Geofire.onKeyExited:
            GeofireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUserMap();
            break;

          // whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeofireAssistant.updateActiveNearbyAvailableDriverLocation(activeNearbyAvailableDriver);
            displayActiveDriversOnUserMap();
            break;

          // display online drivers
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUserMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUserMap()
  {
    setState(() {
      markerSet.clear();
      circleSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for(ActiveNearbyAvailableDrivers eachDriver in GeofireAssistant.activeNearbyAvailableDriversList)
      {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markerSet = driversMarkerSet;
      });
    });
  }

  createActiveNearbyDriverIconMarker()
  {
    if(activeNearbyIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value)
      {
        activeNearbyIcon = value;
      });
    }
  }
}
