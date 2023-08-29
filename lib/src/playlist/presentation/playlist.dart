


import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/src/music_player/presentation/music_player.dart';
import 'package:musicplayer/src/playlist/domain/getMusic_services.dart';
import 'package:musicplayer/src/playlist/provider/music_crud_state.dart';

import '../../music_player/domain/music_state_provider.dart';
import '../../upload_music/presentation/upload.dart';

class PlayList extends ConsumerStatefulWidget {
  final int i;
  PlayList({required this.i});

  @override
  ConsumerState<PlayList> createState() => _PlayListState();
}

class _PlayListState extends ConsumerState<PlayList> {


  final player = AudioPlayer();

  late int i;

  bool isPlaying = false;

  void initState(){
    super.initState();
    i = widget.i;
    ref.refresh(musicStream);
  }


  @override
  Widget build(BuildContext context) {
    final musicList = ref.watch(musicStream);
    final audioPlayerManager = ref.watch(audioPlayerProvider.notifier);
    audioPlayerManager.player.playerStateStream.listen((state) {
      if (state.playing){
        setState(() {
          isPlaying = true;
        });
      }else{
        setState(() {
          isPlaying = false;
        });
      }
    });
    return musicList.when(
        data: (data){
          if(data.isEmpty){
            return Scaffold(
              backgroundColor: Colors.white.withOpacity(0.8),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title:const Text('All Music',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
                backgroundColor: Colors.black,
                elevation: 1,
              ),
              body: const Center(
                child:Text('No Music',style: TextStyle(color: Colors.black),) ,),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: ()=>Get.to(()=>const UploadMusic()),
                child: Icon(Icons.add,color: Colors.white,),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              bottomNavigationBar: InkWell(
                onTap: ()=>Get.offAll(()=>MusicPlayer()),
                child: Container(
                  height: 75,
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('No Music'),
                      Row(
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.skip_previous)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.skip_next)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          else{
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
              backgroundColor: Colors.white.withOpacity(0.8),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title:const Text('All Music',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
                backgroundColor: Colors.black,
                elevation: 1,
              ),
              body: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: ListTile(
                          tileColor: Colors.black.withOpacity(0.1),
                          leading: Icon(Icons.music_note_outlined,color: Colors.black,),
                          title: Text('${data[index].name}',style: TextStyle(color: Colors.black),),
                          trailing: IconButton(
                            onPressed: (){
                              print('${data[index].id},${data[index].name}');
                              _showDialog(data[index].id,data[index].name);
                            },
                            icon: Icon(Icons.more_vert,color: Colors.black,),
                          )

                      ),
                    );
                  }
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: ()=>Get.to(()=>const UploadMusic()),
                child: Icon(Icons.add,color: Colors.white,),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              bottomNavigationBar: InkWell(
                onTap: ()=>Get.offAll(()=>MusicPlayer()),
                child: Container(
                  height: 75,
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${data[i].name}'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                if (i>0){
                                  setState(() {
                                    i=i-1;
                                  });
                                }
                                ref.read(audioPlayerProvider.notifier).previous();

                              }, icon: Icon(Icons.skip_previous)),
                          IconButton(
                              onPressed: () async {
                                if(!isPlaying){
                                  Fluttertoast.showToast(
                                      msg: 'Processing...',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );

                                  final response = await ref.read(audioPlayerProvider.notifier).playAudio(songs: songs);

                                  if(response.isLeft()){
                                    final left = response.fold(
                                            (l) => l,
                                            (r) => null
                                    );
                                    Fluttertoast.showToast(
                                        msg: '$left',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  } else{
                                    final right = response.fold((l) => null, (r) => r);

                                    Fluttertoast.showToast(
                                        msg: '$right',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }



                                }else{
                                  ref.read(audioPlayerProvider.notifier).pause();
                                }

                              }, icon: isPlaying
                              ? Icon(Icons.pause)
                              :Icon(Icons.play_arrow)),
                          IconButton(
                              onPressed: (){
                                ref.read(audioPlayerProvider.notifier).skip();
                              }, icon: Icon(Icons.skip_next)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

        },
        error: (error,stack) => Scaffold(
          backgroundColor: Colors.white.withOpacity(0.8),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title:const Text('All Music',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
            backgroundColor: Colors.black,
            elevation: 1,
          ),
          body: const Center(
            child:Text('No Music',style: TextStyle(color: Colors.black),) ,),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: ()=>Get.to(()=>const UploadMusic()),
            child: Icon(Icons.add,color: Colors.white,),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: InkWell(
            onTap: ()=>Get.offAll(()=>MusicPlayer()),
            child: Container(
              height: 75,
              color: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('No Music'),
                  Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.skip_previous)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.skip_next)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ,
        loading: ()=>Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator(),))
    );
  }

  void _showDialog(String id, String name) async {
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('Delete the song ?'),
            actions: [
              TextButton(
                  onPressed: (){
                    ref.read(crudProvider.notifier).delMusic(id: id, name: name);
                    ref.refresh(musicStream);
                    Navigator.pop(context);
                  },
                  child:const Text('Yes')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:const Text('No')
              ),
            ],
          );
        }
    );
  }


}
