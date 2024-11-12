import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:poseshot/src/model/app_photo.dart';

import '../../../../model/album_metadata.dart';
import '../../../../model/person.dart';
part 'camera_screen_state.freezed.dart';

@freezed
class CameraScreenState with _$CameraScreenState {
  factory CameraScreenState({
    required int selectedCameraIndex,
    required int timerSeconds,
    required double guideLineOpacity,
    required double guidePhotoOpacity,
    required AlbumMetadata selectedAlbum,
    required AppPhoto? guidePhoto,
    required int resolutionNumber,
    // required List<Person> guidePersons,
    // required bool isGuidePoseSame,
    // required bool isGuidePhotoVisible,
    // required bool isGuideLineVisible,
  }) = _CameraScreenState;
}

//이하 셀렉티드 앨범 메타데이터에 대한 설명
    //  required String uid,
    // required String title,
    // required String numOfPhotos,
    // required String createdAtISO8601,
    // required String updatedAtISO8601,
    // required AlbumSettings settings,
    //   required bool isForeSamePose,
    //   required String guidePhotoUid,
    // 줌인 줌아웃은 그냥 하면 됨. 변수로 저장할 필요 없음