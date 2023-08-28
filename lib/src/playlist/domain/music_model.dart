


class MusicModel{

  final String name;
  final String songUrl;

  MusicModel({
    required this.songUrl,
    required this.name
});


  factory MusicModel.fromJson(Map<String, dynamic> json){
    return  MusicModel(
        name:  json['comment'],
        songUrl: json['songUrl'],
    );
  }



}