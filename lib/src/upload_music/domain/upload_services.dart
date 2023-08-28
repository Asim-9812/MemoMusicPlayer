




import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/firebase_instances.dart';


final uploadProvider = StateProvider((ref) => UploadService());

class UploadService{

  static CollectionReference musicDb = FirebaseInstances.fireStore.collection('Music');

  Future<Either<String, bool>> uploadSong({
    required String name,
    required File song
  }) async {
    try{

      final ref = FirebaseInstances.firebaseStorage.ref().child('musicStore/$name');
      await ref.putFile(File(song.path));
      final songUrl = await ref.getDownloadURL();
      await musicDb.add({
        'songUrl' : songUrl,
        'name' : name
      });
      return Right(true);
    }on FirebaseException catch(err){
      return Left(err.message!);
    }
  }


}