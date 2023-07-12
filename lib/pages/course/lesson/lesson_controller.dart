import 'package:course_app/common/apis/lesson_api.dart';
import 'package:course_app/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'bloc/lesson_blocs.dart';
import 'bloc/lesson_events.dart';

class LessonControler{
  final BuildContext context;
  VideoPlayerController? videoPlayerController;

  LessonControler({required this.context});

  void init() async{
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    context.read<LessonBlocs>().add(TriggerPlay(false));
    asyncLoadLessonData(args["id"]);
  }

  Future<void> asyncLoadLessonData(int? id) async {
    LessonRequestEntity lessonRequestEntity = LessonRequestEntity();
    lessonRequestEntity.id = id;
    var result = await LessonAPI.lessonDetail(params: lessonRequestEntity);
    if(result.code == 200){
      if(context.mounted){
        context.read<LessonBlocs>().add(TriggerLessonVideo(result.data!));
        if(result.data!.isNotEmpty){
          var url = result.data!.elementAt(0).url;
          videoPlayerController = VideoPlayerController.network(url!);
          var initPlayer = videoPlayerController?.initialize();
          context.read<LessonBlocs>().add(TriggerUrlItem(initPlayer));
        }
      }
    }
  }

}