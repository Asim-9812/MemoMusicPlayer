
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class FirebaseInstances{

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore fireStore= FirebaseFirestore.instance;


}