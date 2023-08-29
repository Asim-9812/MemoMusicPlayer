


class MusicModel{

  final String id;
  final String name;
  final String songUrl;

  MusicModel({
    required this.id,
    required this.songUrl,
    required this.name
});


  factory MusicModel.fromJson(Map<String, dynamic> json){
    return  MusicModel(
      id: json['id'],
        name:  json['comment'],
        songUrl: json['songUrl'],
    );
  }



}