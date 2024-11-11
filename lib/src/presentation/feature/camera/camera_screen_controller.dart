import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poseshot/src/model/album_metadata.dart';
import 'package:poseshot/src/model/app_photo.dart';
import 'package:poseshot/src/presentation/feature/gallery/gallery_screen_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../../develop_only/talker.dart';
import '../../../application/gallery/gallery.dart';
import '../../../model/person.dart';
import 'state/camera_screen_state.dart';
part 'camera_screen_controller.g.dart';

@riverpod
class CameraScreenController extends _$CameraScreenController {
  @override
  FutureOr<CameraScreenState> build({String? albumUid}) async {
    // camerascreenstate를 반환
    final AlbumMetadata selectedAlbum =
        await getSelectedAlbumInfo(albumUid: albumUid);
    ref.read(galleryScreenControllerProvider.notifier).refresh();
    final AppPhoto? guidePhoto = selectedAlbum.settings.guidePhotoUid != null
        ? await _gallery
            .getPhotoFromPhotoUid(selectedAlbum.settings.guidePhotoUid!)
        : null;

    // // getGuidObjects 메소드로 뺄 것
    // guidePersons = await _poseDetector.getPersonsFromImageData(
    //     _gallery.getPhoto(selectedAlbum.settings.guidePhotoUid ?? ''));
    // // 가이드오브젝트를 화면에 표시하는 로직 screen에 추가할 것.

    return CameraScreenState(
      guideLineOpacity: 0.6,
      guidePhotoOpacity: 0.4,
      selectedAlbum: selectedAlbum,
      selectedCameraIndex: 0,
      timerSeconds: 0,
      guidePhoto: guidePhoto,
      // isGuidePoseSame: false,
      // isGuidePhotoVisible: true,
      // isGuideLineVisible: true,
    );
  }

  late final Gallery _gallery = ref.read(gallaryProvider);
  List<Person> guidePersons = []; // 이거 그냥 state로 빼도 될 듯

  Future<AlbumMetadata> getSelectedAlbumInfo({String? albumUid}) async =>
      albumUid == null
          ? _gallery.getDefaultAlbumMetadata()
          : _gallery.getAlbumMetadata(albumUid);

  Future takePhoto(
      BuildContext context, CameraController cameraController) async {
    talker.warning(
        'cameraScreenController takePhoto : current Album : ${state.value!.selectedAlbum.albumUid}');

    // 진동
    Vibration.hasVibrator().then(
        (value) => value == true ? Vibration.vibrate(duration: 50) : null);

    // 사진 찍기
    XFile takedPhoto = await cameraController.takePicture();
    Uint8List photoBytes = await takedPhoto.readAsBytes(); // xfile to bytes

    if (state.value == null) return;
    String photoUid = await _gallery.addPhoto(
        photo: AppPhoto(
          imgeBytes: photoBytes,
          albumUid: state.value!.selectedAlbum.albumUid,
          photoUid: const Uuid().v4(),
          createdAtISO8601: DateTime.now().toIso8601String(),
          imageWidth: cameraController.value.previewSize!.width, // ## 맞아?
          imageHeight: cameraController.value.previewSize!.height, // ## 맞아?
        ),
        albumUid: state.value!.selectedAlbum.albumUid);
    talker.debug(photoUid);
    // 사진 추가 후 다른 state 최신화
    ref.read(galleryScreenControllerProvider.notifier).refresh();
  }
}
