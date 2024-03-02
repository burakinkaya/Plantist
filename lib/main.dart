import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:plantist/screen/home.dart";
import "package:plantist/services/databaseService.dart";
import "firebase_options.dart";
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = auth.currentUser;
  String? userId = currentUser?.uid;

  if (userId != null) {
    Get.put(DatabaseService(userId));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
    );
  }
}
