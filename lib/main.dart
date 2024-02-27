import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geo_fence_demo/homepage.dart';
import 'package:geo_fence_demo/notification_services.dart';

void main() {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geofencing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController latitudeController = TextEditingController();
//   TextEditingController longitudeController = TextEditingController();
//   TextEditingController radiusController = TextEditingController();
//   Geolocator geolocator = Geolocator();
//   StreamSubscription<GeofenceStatus>? geofenceStatusStream;
//   String geofenceStatus = '';
//   bool isReady = false;
//   Position? position;
//   Position? currentPosition;
//   String fancingStatus = "";

//   @override
//   void initState() {
//     super.initState();
//     getCurrentPosition();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Geofencing"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.my_location),
//             onPressed: () {
//               if (isReady) {
//                 setState(() {
//                   setLocation();
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: <Widget>[
//             latitudeTextField(),
//             longitudeTextField(),
//             radiusTextField(),
//             const SizedBox(
//               height: 60,
//             ),
//             startServices(),
//             const SizedBox(
//               height: 100,
//             ),
//             statusText(),
//           ],
//         ),
//       ),
//     );
//   }

//   getCurrentPosition() async {
//     var hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//     position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print("LOCATION => ${position!.toJson()}");
//     isReady = (position != null) ? true : false;
//   }

//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
//     if (!serviceEnabled) {
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return false;
//     }
//     return true;
//   }

//   Future<void> _getCurrentPosition() async {
//     final hasPermission = await _handleLocationPermission();

//     if (!hasPermission) return;
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//         .then((Position position) {
//       currentPosition = position;
//     }).catchError((e) {});
//   }

//   setLocation() async {
//     await getCurrentPosition();
//     latitudeController =
//         TextEditingController(text: position!.latitude.toString());
//     longitudeController =
//         TextEditingController(text: position!.longitude.toString());
//     setState(() {});
//   }

//   Widget latitudeTextField() {
//     return TextField(
//       controller: latitudeController,
//       decoration: const InputDecoration(
//           border: InputBorder.none, hintText: 'Enter pointed latitude'),
//     );
//   }

//   Widget longitudeTextField() {
//     return TextField(
//       controller: longitudeController,
//       decoration: const InputDecoration(
//           border: InputBorder.none, hintText: 'Enter pointed longitude'),
//     );
//   }

//   Widget radiusTextField() {
//     return TextField(
//       controller: radiusController,
//       decoration: const InputDecoration(
//           border: InputBorder.none, hintText: 'Enter radius in meter'),
//     );
//   }

//   Widget startServices() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           child: const Text("Start"),
//           onPressed: () {
//             print("starting geoFencing Service");
//             print(geofenceStatusStream);

//             NotificationService()
//                 .showNotifications("Starting", "starting geoFencing Service");

//             EasyGeofencing.startGeofenceService(
//                 pointedLatitude: latitudeController.text,
//                 pointedLongitude: longitudeController.text,
//                 radiusMeter: radiusController.text,
//                 eventPeriodInSeconds: 5);
//             geofenceStatusStream?.resume();

//             geofenceStatusStream = EasyGeofencing.getGeofenceStream()!
//                 .asBroadcastStream()
//                 .listen((GeofenceStatus status) {
//               print(status.toString());
//               setState(() {
//                 geofenceStatus = status.toString();
//                 geofenceStatus == "GeofenceStatus.enter" &&
//                         fancingStatus != "GeofenceStatus.enter"
//                     ? NotificationService().showNotifications(
//                         "Entered", "You have entered in campus area")
//                     : geofenceStatus == "GeofenceStatus.exit" &&
//                             fancingStatus != "GeofenceStatus.exit"
//                         ? NotificationService().showNotifications(
//                             "Exited", "You are out from campus area")
//                         : null;
//                 if (geofenceStatus == "GeofenceStatus.enter") {
//                   fancingStatus = geofenceStatus;
//                 } else if (geofenceStatus == "GeofenceStatus.exit") {
//                   fancingStatus = geofenceStatus;
//                 }
//               });
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget statusText() {
//     return Text(
//       "Geofence Status: \n\n\n$geofenceStatus",
//       textAlign: TextAlign.center,
//       style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//     );
//   }

//   @override
//   void dispose() {
//     latitudeController.dispose();
//     longitudeController.dispose();
//     radiusController.dispose();

//     super.dispose();
//   }
// }
