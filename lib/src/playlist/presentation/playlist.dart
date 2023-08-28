


import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/src/playlist/domain/getMusic_services.dart';

class PlayList extends ConsumerStatefulWidget {
  const PlayList({super.key});

  @override
  ConsumerState<PlayList> createState() => _PlayListState();
}

class _PlayListState extends ConsumerState<PlayList> {


  final player = AudioPlayer();

  void initState(){
    super.initState();
    ref.refresh(musicStream);
  }


  @override
  Widget build(BuildContext context) {
    final musicList = ref.watch(musicStream);
    return musicList.when(
        data: (data){
          List<AudioSource> songs = [];
          data.forEach((element) {
            final audio= AudioSource.uri(Uri.parse(element.songUrl));
            songs.add(audio);
          });


          // Define the playlist
          final playlist = ConcatenatingAudioSource(
            // Start loading next item just before reaching it
            useLazyPreparation: true,
            // Customise the shuffle algorithm
            shuffleOrder: DefaultShuffleOrder(),
            // Specify the playlist items
            children: songs,
          );
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title:const Text('All music',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              backgroundColor: Colors.black.withOpacity(0.1),
              elevation: 1,
              centerTitle: true,
            ),
            body: Column(
              children: [
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: ListTile(
                          tileColor: Colors.black.withOpacity(0.1),
                          title: Text('${data[index].name}',style: TextStyle(color: Colors.black),),

                        ),
                      );
                    }
                ),
                Container(
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: ()async {


                              await player.seekToPrevious();

                            },
                            icon: Icon(Icons.skip_previous,color: Colors.black,)),
                        IconButton(
                            onPressed: ()async {



                              await player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);

                              player.play();


                            },
                            icon: Icon(Icons.play_arrow,color: Colors.black,)),
                        IconButton(
                            onPressed: ()async {



                              await player.seekToNext();

                            },
                            icon: Icon(Icons.skip_next,color: Colors.black,)),
                        IconButton(onPressed: ()async{
                          player.stop();
                        }, icon: Icon(Icons.stop,color: Colors.black,)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        error: (error,stack) => Container(
          color: Colors.white,
          child: Center(
            child: Text('$error',style:const TextStyle(color: Colors.black),),
          ),
        ) ,
        loading: ()=>Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator(),))
    );
  }
}
