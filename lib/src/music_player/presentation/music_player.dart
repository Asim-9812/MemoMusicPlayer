


import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/src/playlist/domain/getMusic_services.dart';

import '../../playlist/presentation/playlist.dart';
import '../domain/music_state_provider.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({super.key});

  @override
  ConsumerState<MusicPlayer> createState() => _MusicDashBoardState();
}

class _MusicDashBoardState extends ConsumerState<MusicPlayer> {


  final player = AudioPlayer();

  bool isPlaying = false;

  late FontLoader fontLoader;

  bool isLoading = false;

  bool shuffle = false;

  int i =0 ;

  int currentValue = 0;





  void initState(){
    super.initState();
    ref.refresh(musicStream);
    fontLoader = FontLoader('Righteous'); // 'Righteous' is the family name
    fontLoader.addFont(rootBundle.load('assets/fonts/Righteous/Righteous-Regular.ttf'));
    // You can add more variants like bold, italic, etc. if available

    // Load the font
    fontLoader.load();
  }



  void updateValue() {
    setState(() {
      currentValue = (currentValue + 1) % 3;
    });
  }






  @override
  Widget build(BuildContext context) {
    final audioPlayerManager = ref.watch(audioPlayerProvider.notifier);
    final musicList = ref.watch(musicStream);
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
          if(data.isEmpty ){
            return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: ()=>Get.to(()=>PlayList(i: 0,)),
                    icon:const Icon(CupertinoIcons.back,color: Colors.white,),
                  ),
                  titleSpacing: 0,
                  title: const Text('Playlist'),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                        elevation: 10,
                        color: Colors.white,
                        shadowColor: Colors.white,
                        child: Container(
                          height: 300,
                          width: 300,
                          child: Center(child: Text('No Music',style:const TextStyle(color: Colors.black,fontFamily: 'Righteous',fontSize: 50),)),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  shuffle = !shuffle;
                                });
                              },
                              icon:shuffle
                                  ? const Icon(CupertinoIcons.shuffle_medium,color: Colors.green,)
                                  :const Icon(CupertinoIcons.shuffle_medium,color: Colors.white,)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      shadowColor: Colors.white,
                                      backgroundColor:Colors.white,
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.all(8)
                                  ),
                                  onPressed: ()async {
                                    Fluttertoast.showToast(
                                        msg: 'No music',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
                                  },
                                  child: Icon(Icons.skip_previous,color: Colors.black,)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    shadowColor: Colors.white,
                                    backgroundColor:isPlaying? Colors.black:Colors.white,
                                    shape: const CircleBorder(
                                        side: BorderSide(
                                            color: Colors.white
                                        )
                                    ),
                                    padding: EdgeInsets.all(18)
                                ),
                                onPressed: () async {

                                  Fluttertoast.showToast(
                                      msg: 'No music',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                                },
                                child:Icon( Icons.play_arrow,
                                  color: Colors.black,size: 40,
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      shadowColor: Colors.white,
                                      backgroundColor: Colors.white,
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.all(8)

                                  ),
                                  onPressed: ()async {
                                    Fluttertoast.showToast(
                                        msg: 'No music',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
                                  },
                                  child: Icon(Icons.skip_next,color: Colors.black,)),

                            ],
                          ),
                          IconButton(
                              onPressed: (){
                                updateValue();
                              },
                              icon:currentValue == 0
                                  ? Icon(CupertinoIcons.repeat,color: Colors.white,)
                                  : currentValue == 1
                                  ? Icon(CupertinoIcons.repeat_1,color: Colors.yellow,)
                                  :Icon(CupertinoIcons.repeat,color: Colors.green,)
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            );
          }
          else{
            List<AudioSource> songs = [];
            data.forEach((element) {
              final audio= AudioSource.uri(Uri.parse(element.songUrl));
              songs.add(audio);
            });





            return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: ()=>Get.to(()=>PlayList(i: i,)),
                    icon:const Icon(CupertinoIcons.back,color: Colors.white,),
                  ),
                  titleSpacing: 0,
                  title: const Text('Playlist'),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                        elevation: 10,
                        color: Colors.white,
                        shadowColor: Colors.white,
                        child: Container(
                          height: 300,
                          width: 300,
                          child: Center(child: Text(data[i].name,style:const TextStyle(color: Colors.black,fontFamily: 'Righteous',fontSize: 50),)),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  shuffle = !shuffle;
                                });
                                ref.read(audioPlayerProvider.notifier).shuffle(shuffle);
                              },
                              icon:shuffle
                                  ? const Icon(CupertinoIcons.shuffle_medium,color: Colors.green,)
                                  :const Icon(CupertinoIcons.shuffle_medium,color: Colors.white,)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      shadowColor: Colors.white,
                                      backgroundColor:Colors.white,
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.all(8)
                                  ),
                                  onPressed: ()async {
                                    if (i>0){
                                      setState(() {
                                        i=i-1;
                                      });
                                    }
                                    ref.read(audioPlayerProvider.notifier).previous();

                                  },
                                  child: Icon(Icons.skip_previous,color: Colors.black,)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    shadowColor: Colors.white,
                                    backgroundColor:isPlaying? Colors.black:Colors.white,
                                    shape: const CircleBorder(
                                        side: BorderSide(
                                            color: Colors.white
                                        )
                                    ),
                                    padding: EdgeInsets.all(18)
                                ),
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




                                },
                                child:isPlaying
                                    ?const Icon(
                                  Icons.pause,
                                  color: Colors.white,size: 40,
                                ):
                                const Icon( Icons.play_arrow,
                                  color: Colors.black,size: 40,
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      shadowColor: Colors.white,
                                      backgroundColor: Colors.white,
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.all(8)

                                  ),
                                  onPressed: ()async {


                                    if(i<songs.length-1){
                                      setState(() {
                                        i=i+1;
                                      });
                                    }


                                    ref.read(audioPlayerProvider.notifier).skip();

                                  },
                                  child: Icon(Icons.skip_next,color: Colors.black,)),

                            ],
                          ),
                          IconButton(
                              onPressed: (){
                                updateValue();
                                // print(currentValue);
                                ref.read(audioPlayerProvider.notifier).repeat(currentValue);
                              },
                              icon:currentValue == 0
                                  ? Icon(CupertinoIcons.repeat,color: Colors.white,)
                                  : currentValue == 1
                                  ? Icon(CupertinoIcons.repeat_1,color: Colors.yellow,)
                                  :Icon(CupertinoIcons.repeat,color: Colors.green,)
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            );
          }

        },
        error: (error,stack) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: ()=>Get.to(()=>PlayList(i: 0,)),
                icon:const Icon(CupertinoIcons.back,color: Colors.white,),
              ),
              titleSpacing: 0,
              title: const Text('Playlist'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                    elevation: 10,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 300,
                      width: 300,
                      child: Center(child: Text('No Music',style:const TextStyle(color: Colors.black,fontFamily: 'Righteous',fontSize: 50),)),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (){
                            setState(() {
                              shuffle = !shuffle;
                            });
                          },
                          icon:shuffle
                              ? const Icon(CupertinoIcons.shuffle_medium,color: Colors.green,)
                              :const Icon(CupertinoIcons.shuffle_medium,color: Colors.white,)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.white,
                                  backgroundColor:Colors.white,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(8)
                              ),
                              onPressed: ()async {
                                Fluttertoast.showToast(
                                    msg: 'No music',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                );
                              },
                              child: Icon(Icons.skip_previous,color: Colors.black,)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.white,
                                backgroundColor:isPlaying? Colors.black:Colors.white,
                                shape: const CircleBorder(
                                    side: BorderSide(
                                        color: Colors.white
                                    )
                                ),
                                padding: EdgeInsets.all(18)
                            ),
                            onPressed: () async {

                              Fluttertoast.showToast(
                                  msg: 'No music',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0
                              );
                            },
                            child:Icon( Icons.play_arrow,
                              color: Colors.black,size: 40,
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(8)

                              ),
                              onPressed: ()async {
                                Fluttertoast.showToast(
                                    msg: 'No music',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                );
                              },
                              child: Icon(Icons.skip_next,color: Colors.black,)),

                        ],
                      ),
                      IconButton(
                          onPressed: (){
                            updateValue();
                          },
                          icon:currentValue == 0
                              ? Icon(CupertinoIcons.repeat,color: Colors.white,)
                              : currentValue == 1
                              ? Icon(CupertinoIcons.repeat_1,color: Colors.yellow,)
                              :Icon(CupertinoIcons.repeat,color: Colors.green,)
                      ),
                    ],
                  ),
                ),
              ],
            )
        ) ,
        loading: ()=>Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: Colors.white,),))
    );
  }
}
