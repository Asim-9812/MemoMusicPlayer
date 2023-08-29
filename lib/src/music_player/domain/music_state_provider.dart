import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';


class AudioPlayerState extends StateNotifier<bool> {
  AudioPlayerState() : super(false);

  bool get isPlaying => state;
  void toggle() {
    state = !state;
  }
}

class AudioPlayerManager extends StateNotifier<AudioPlayerState>{

  final player = AudioPlayer();

  AudioPlayerManager() : super(AudioPlayerState());


  Future<bool> isStreaming() async {
    final state = await player.playerStateStream.first;
    return state.playing;
  }


  Future<Either<String,String>> playAudio({required List<AudioSource> songs}) async {
    // Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: songs,
    );
    await player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);
    // Catching errors at load time
    try {
      await player.play();
      return const Right('Successful');

    } on PlayerException catch (e) {
      return Left("Error code: ${e.code} \n message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      return Left("Connection aborted: ${e.message}");
    } catch (e) {
      return Left('An error occured: $e');
    }


  }




  void shuffle(bool value) async{
    await player.setShuffleModeEnabled(value);
  }

  void repeat(int i) async{
    List<LoopMode> loop = [LoopMode.off,LoopMode.one,LoopMode.all];
    await player.setLoopMode(loop[i]);

  }

  void pause() async{
    player.pause();
  }

  void skip()async{
    player.seekToNext();
  }

  void previous()async{
    player.seekToPrevious();
  }

  void stop() {
    player.stop();
    state.toggle();
  }
}


final audioPlayerProvider = StateNotifierProvider<AudioPlayerManager, AudioPlayerState>((ref) {
  return AudioPlayerManager();
});
