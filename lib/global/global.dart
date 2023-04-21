import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_details_info.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance; //remembers last known user logged in, "app instance"
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; // Online or Active driverKeys Info List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String cloudMessagingServerToken = "key=AAAAneVoTjo:APA91bEJqQQloV-qcJfEXGTMBMhIdTxLjxaHZmc6EFL1s3dij9pz0COwgIWpsUT93UVBJSxVjLV7yleR1-dlENZBf0WRzXY2zSzRmZRZ-P-jZ8o3ay83e3TQbr_7_4z0L8CEBLiMQZ9L";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverPhone = "";
String driverName = "";
double countRatingStar = 0.0;
String titleStarRating = "";