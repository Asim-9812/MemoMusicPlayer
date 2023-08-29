



class MusicState{

  final String errorMessage;
  final bool isSuccess;
  final bool isLoad;

  MusicState({

    required this.errorMessage,
    required this.isSuccess,
    required this.isLoad

  });



  MusicState copyWith({bool? isLoad, String? errorMessage, bool? isSuccess }){
    return MusicState(
        errorMessage: errorMessage ?? this.errorMessage,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }

  factory MusicState.empty(){
    return MusicState(errorMessage: '', isLoad: false, isSuccess: false);
  }

}