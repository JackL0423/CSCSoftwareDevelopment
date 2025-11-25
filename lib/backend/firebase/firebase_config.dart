import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC3nAhs25EwDMWiZsmB2voH56FbtQ3UvRY",
            authDomain: "csc-305-dev-project.firebaseapp.com",
            projectId: "csc-305-dev-project",
            storageBucket: "csc-305-dev-project.firebasestorage.app",
            messagingSenderId: "54503053415",
            appId: "1:54503053415:web:911a989a02517ab0b89cc2",
            measurementId: "G-ZMQ0TETVJK"));
  } else {
    await Firebase.initializeApp();
  }
}
