


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/src/playlist/domain/music_model.dart';

import '../../common/firebase_instances.dart';


final musicStream  = StreamProvider((ref) => GetServices.getMusic());

class GetServices{

  static CollectionReference musicDb = FirebaseInstances.fireStore.collection('Music');


  static Stream<List<MusicModel>> getMusic(){
    return musicDb.snapshots().map((event) => getSome(event));
  }

  static List<MusicModel> getSome(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      final music = e.data() as Map<String, dynamic> ;
      return MusicModel(
        id: e.id,
          name: music['name'],
        songUrl: music['songUrl']
      );
    }).toList();
  }

  static Future<Either<String, bool>> delMusic({
    required String id,
    required String name,
  }) async {
    try {
      final ref = FirebaseInstances.firebaseStorage.ref().child(
          'musicStore/$name');
      await ref.delete();

      await musicDb.doc(id).delete();

      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }


}