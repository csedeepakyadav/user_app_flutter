import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

String userUid = auth.currentUser!.uid.toString();
