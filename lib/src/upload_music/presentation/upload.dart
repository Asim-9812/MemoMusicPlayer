


import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../domain/upload_services.dart';

class UploadMusic extends ConsumerStatefulWidget {
  const UploadMusic({super.key});

  @override
  ConsumerState<UploadMusic> createState() => _UploadMusicState();
}

class _UploadMusicState extends ConsumerState<UploadMusic> {

  TextEditingController _nameController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();

  File? song;

  bool isPostingData = false;

  void _selectSong() async {

   FilePickerResult? result = await FilePicker.platform.pickFiles();

   if (result != null) {
     File file = File(result.files.single.path!);

     setState(() {
       song = file;
     });

     _uploadSong(file);

   } else {
     Fluttertoast.showToast(
         msg: "Unsuccessful",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.red,
         textColor: Colors.white,
         fontSize: 16.0
     );
   }

  }

  void _uploadSong(File song) async {
    
    final response = await ref.read(uploadProvider).uploadSong(name: _nameController.text.trim(), song: song);

    if(response.isLeft()){
      final left = response.fold(
              (l) => l,
              (r) => null
      );

      Fluttertoast.showToast(
          msg: "$left",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
    else{
      Fluttertoast.showToast(
          msg: "Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        isPostingData = false;
      });
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.black.withOpacity(0.1),
                elevation: 0,
                shape:const CircleBorder(),
                child:const Padding(
                  padding: EdgeInsets.all(38.0),
                  child: Center(
                    child: Icon(Icons.music_note,color: Colors.black,size: 40,),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: 'Add a name',
                    hintStyle: const TextStyle(color: Colors.black)
                  ),
                  style:const TextStyle(color: Colors.black),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        isPostingData = true;
                      });

                      _selectSong();
                    }
                  },
                  child: isPostingData?const CircularProgressIndicator(color: Colors.white,):const Text('Select a file')
              )

            ],
          ),
        ),
      ),
    );
  }
}
