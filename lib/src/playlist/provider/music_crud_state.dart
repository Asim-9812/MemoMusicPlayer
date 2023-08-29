
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/src/playlist/domain/getMusic_services.dart';

import 'music_state.dart';




final crudProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) => MusicNotifier(MusicState.empty()));

class MusicNotifier extends StateNotifier<MusicState> {
  MusicNotifier(super.state);


  Future<void> delMusic({
    required String id,
    required String name,
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await GetServices.delMusic(id: id, name: name);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }






}