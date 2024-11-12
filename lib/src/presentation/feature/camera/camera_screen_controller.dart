import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poseshot/src/application/pose_detector/pose_detector.dart';
import 'package:poseshot/src/model/album_metadata.dart';
import 'package:poseshot/src/model/app_photo.dart';
import 'package:poseshot/src/presentation/feature/camera/provider/detected_persons_provider.dart';
import 'package:poseshot/src/presentation/feature/camera/util/tracker.dart';
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
    _cameras = await availableCameras();
    await initCameraStreamingWithDetection();

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

    ref.onDispose(onDisposed); // 작동 확인 후 필요시 view의 onDispose로 이동

    return CameraScreenState(
      // 화질 선택, 화면비 선택 등 추가 필요.
      guideLineOpacity: 0.6,
      guidePhotoOpacity: 0.4,
      selectedAlbum: selectedAlbum,
      selectedCameraIndex: 0,
      timerSeconds: 0,
      guidePhoto: guidePhoto,
      resolutionNumber: resolutions.length - 1,
      // isGuidePoseSame: false,
      // isGuidePhotoVisible: true,
      // isGuideLineVisible: true,
    );
  }

  late CameraController cameraController;
  late final List<CameraDescription> _cameras;
  get cameras => _cameras;

  late final PoseDetector _poseDetector = ref.read(poseDetectorProvider);

  late final Gallery _gallery = ref.read(gallaryProvider);

  List<Person> guidePersons = []; // 이거 그냥 state로 빼도 될 듯
  final Tracker _tracker = Tracker();
  bool _isProcessing = false;
  bool _isCameraInitialized = false;

  List<ResolutionPreset> resolutions = [
    ResolutionPreset.medium, // 480
    ResolutionPreset.veryHigh, // 720
    ResolutionPreset.high, // 1080
    ResolutionPreset.ultraHigh, // 2k
    ResolutionPreset.max, // 맥스로 해도 카메라 성능 제한됨. camera 패키지에서 설정된 프리셋으로만 제공됨.
  ];

  Future<void> initCameraStreamingWithDetection(
      {CameraController? newCameraController}) async {
    await initCameraController(newCameraController: newCameraController);

    await _poseDetector.initDetector();
    cameraController // need to await?
        .startImageStream(performEveryFrame)
        .catchError((Object e) => talker.error(e));
  }

  Future<void> onDisposed() async {
    await cameraController.stopImageStream();
    _poseDetector.disposeDetector();
    await cameraController.dispose();
  }

  Future<void> initCameraController(
      {CameraController? newCameraController}) async {
    cameraController = newCameraController ??
        CameraController(
            _cameras[state.value?.selectedCameraIndex ?? 0],
            resolutions[
                state.value?.resolutionNumber ?? resolutions.length - 1],
            enableAudio: false);
    await cameraController.initialize();
    _isCameraInitialized = true;
  }

  Future performEveryFrame(CameraImage cameraImage) async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      ref.read(detectedPersonsProvider.notifier).updatePerson(
          _tracker.getPersons(await _poseDetector.getPersonsFromCameraImage(
              cameraImage,
              cameraController.value.description.sensorOrientation)));
    } catch (e) {
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> changeCamera({int? cameraIndex, int? resolutionNumber}) async {
    // 스트리밍 중지
    await cameraController.stopImageStream();
    await cameraController.dispose();
    _isCameraInitialized = false;
    // 새로운 카메라 description 으로 카메라 컨트롤러 초기화
    cameraController = CameraController(
        _cameras[cameraIndex ?? state.value!.selectedCameraIndex],
        resolutions[resolutionNumber ?? state.value!.resolutionNumber]);
    // 스트리밍 시작
    _poseDetector.refreshLatency();
    await initCameraStreamingWithDetection(
        newCameraController: cameraController);
  }

  Future<void> selectCamera(int cameraIndex) async {
    if (state.value != null && state.value!.selectedCameraIndex == cameraIndex)
      return;
    state = const AsyncLoading();
    await changeCamera(cameraIndex: cameraIndex);
    state = AsyncData(state.value!.copyWith(selectedCameraIndex: cameraIndex));
  }

  Future<void> selectResolution(int resolutionNumber) async {
    talker.warning(state.value!.resolutionNumber);
    talker.warning(resolutionNumber);

    if (state.value != null &&
        state.value!.resolutionNumber == resolutionNumber) return;
    state = const AsyncLoading();
    await changeCamera(resolutionNumber: resolutionNumber);
    state =
        AsyncData(state.value!.copyWith(resolutionNumber: resolutionNumber));
    // cameraWidgetHeight = cameraWidgetWidth *
    //     cameraController
    //         .value.aspectRatio; // 가이드라인 위젯 크기 조정(카메라 비율을 기준으로 좌표 표시되기 때문)
    // await startCamearaStreaming();
  }

  Future<AlbumMetadata> getSelectedAlbumInfo({String? albumUid}) async =>
      albumUid == null
          ? _gallery.getDefaultAlbumMetadata()
          : _gallery.getAlbumMetadata(albumUid);

  // ##### 이하 사용자 액션

  Future takePhoto(BuildContext context) async {
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
