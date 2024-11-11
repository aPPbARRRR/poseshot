import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poseshot/src/application/pose_detector/impl/movenet_pose_detector.dart';
import 'package:poseshot/src/presentation/const/app_color.dart';
import 'package:poseshot/src/presentation/feature/camera/widget/animated_body_boundary_painter.dart';
import 'package:poseshot/src/presentation/feature/camera/widget/take_photo_button.dart';
import 'package:vibration/vibration.dart';

import '../../../../develop_only/talker.dart';
import '../../../application/pose_detector/pose_detector.dart';
import '../../../model/person.dart';
import 'camera_screen_controller.dart';
import 'util/tracker.dart';
import 'widget/animated_arms_painter.dart';
import 'widget/animated_body_painter.dart';
import 'widget/animated_face_painter.dart';
import 'widget/animated_legs_painter.dart';
import 'widget/animated_person_painter.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({
    super.key,
    this.albumUid,
  });

  final String? albumUid;

  final double appBarHeight = 80;
  final double bottomHeight = 150;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  // late final PoseDetector _poseDetector = ref.read(poseDetectorProvider);
  late final PoseDetector _poseDetector = MovenetPoseDetector();
  late final List<CameraDescription> cameras;
  late CameraController cameraController; // final이 아님. 차라리 state로 제공하는게 나은가?

  final Tracker _tracker = Tracker();
  List<Person> personsNow = [];
  Map<int, Person?> persons = {
    0: null,
    1: null,
    2: null,
    3: null,
    4: null,
    5: null,
    6: null,
    7: null,
    8: null,
    9: null,
  };

  bool _isProcessing = false;
  bool _isInitialized = false;
  late double cameraWidgetWidth = MediaQuery.of(context).size.width;
  late double cameraWidgetHeight =
      cameraWidgetWidth * cameraController.value.aspectRatio;

  @override
  void initState() {
    super.initState();
    beforeBuild();
  }

  @override
  void dispose() async {
    cameraController.stopImageStream();
    cameraController.dispose().then((_) => _poseDetector.disposeDetector());
    super.dispose();
  }

  Future<void> beforeBuild() async {
    await _poseDetector.initDetector();
    await initCamera();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initCamera() async {
    _isInitialized = await initCameraController();
    await startCamearaStreaming();
  }

  Future<bool> initCameraController() async {
    cameras = await availableCameras();
    talker.warning(cameras);

    cameraController = CameraController(cameras[0],
        ResolutionPreset.medium); // resolution의 경우 기기 고정으로, 최초 실행시 고정.
    await cameraController.initialize();
    return true;
  }

  Future<void> startCamearaStreaming() async {
    cameraController
        .startImageStream(performEveryFrame)
        .catchError((Object e) => talker.error(e));
  }

  Future performEveryFrame(CameraImage cameraImage) async {
    if (!context.mounted) return;
    if (_isProcessing) {
      setState(() {});
    } else {
      _isProcessing = true;
      try {
        _poseDetector
            .getPersonsFromCameraImage(cameraImage,
                cameraController.value.description.sensorOrientation)
            .then((result) {
          persons = _tracker.getPersons(result);

          if (context.mounted) {
            setState(() {
              _isProcessing = false;
            });
          }
        });

        // List<Person> inferenceResultPersons =
        //     await _poseDetector.getPersonsFromCameraImage(cameraImage,
        //         cameraController.value.description.sensorOrientation);
        // persons = _tracker.getPersons(inferenceResultPersons);
        // if (context.mounted) {
        //   setState(() {});
        // }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> changeCamera({ResolutionPreset? resolution}) async {
    final newCameraDescription = cameras[resolution != null
        ? cameras.indexOf(cameraController.description)
        : (cameras.indexOf(cameraController.description) + 1) % cameras.length];
    // 스트리밍 중지
    await cameraController.stopImageStream();
    setState(() {
      _isInitialized = false;
    });
    await cameraController.dispose();
    // 새로운 카메라 description 으로 카메라 컨트롤러 초기화
    cameraController = CameraController(
        newCameraDescription, resolution ?? ResolutionPreset.medium);
    // 스트리밍 시작
    _poseDetector.refreshLatency();

    await cameraController.initialize();

    _isInitialized = true;
    cameraWidgetHeight = cameraWidgetWidth *
        cameraController
            .value.aspectRatio; // 가이드라인 위젯 크기 조정(카메라 비율을 기준으로 좌표 표시되기 때문)
    await startCamearaStreaming();
    setState(() {});
  }

  bool _isSamePose = false;
  bool _isShutterOperating = false;

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(cameraScreenControllerProvider(albumUid: widget.albumUid));
    final controller = ref.read(
        cameraScreenControllerProvider(albumUid: widget.albumUid).notifier);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {},
      child: Scaffold(
          appBar: AppBar(
            title: const Text('camera'),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.cameraswitch),
                onPressed: () async => changeCamera(),
              )
            ],
          ),
          body: !_isInitialized
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child:
                          CameraViewWidget(cameraController: cameraController),
                    ),
                    if (state.value != null && state.value!.guidePhoto != null)
                      Positioned(
                          top: 0,
                          child: Opacity(
                              opacity: state.value!
                                  .guidePhotoOpacity, // 얘는 가이드 라인 보여주는걸로 수정해야함
                              child: Image.memory(
                                  state.value!.guidePhoto!.imgeBytes))),
                    // 사진 분석 -> 이건 그냥 isolate에서 하지 말고 main에서 함
                    // 사진 분석 완료시 그냥 AnimatedPainter로 그려
                    if (state.value != null && state.value!.guidePhoto != null)
                      Positioned(
                          top: 0,
                          child: Opacity(
                              opacity: state.value!.guidePhotoOpacity,
                              child: Image.memory(
                                  state.value!.guidePhoto!.imgeBytes))),
                    if (cameraController.value.previewSize != null)
                      ...getAnimatedFacePainterFromPersons(
                          persons, Size(cameraWidgetWidth, cameraWidgetHeight)),
                    ...getAnimatedBodyPainterFromPersons(
                        persons, Size(cameraWidgetWidth, cameraWidgetHeight)),
                    ...getAnimatedArmsPainterFromPersons(
                        persons, Size(cameraWidgetWidth, cameraWidgetHeight)),
                    ...getAnimatedLegsPainterFromPersons(
                        persons, Size(cameraWidgetWidth, cameraWidgetHeight)),
                    Positioned(
                      top: 0,
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.sd),
                            color: AppColor.gray30,
                            onPressed: () => cameraController
                                        .mediaSettings.resolutionPreset !=
                                    ResolutionPreset.medium
                                ? changeCamera(
                                    resolution: ResolutionPreset.medium)
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.hd),
                            color: AppColor.gray30,
                            onPressed: () => cameraController
                                        .mediaSettings.resolutionPreset !=
                                    ResolutionPreset.high
                                ? changeCamera(
                                    resolution: ResolutionPreset.high)
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.one_k),
                            color: AppColor.gray30,
                            onPressed: () => cameraController
                                        .mediaSettings.resolutionPreset !=
                                    ResolutionPreset.veryHigh
                                ? changeCamera(
                                    resolution: ResolutionPreset.veryHigh)
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.two_k),
                            color: AppColor.gray30,
                            onPressed: () => cameraController
                                        .mediaSettings.resolutionPreset !=
                                    ResolutionPreset.ultraHigh
                                ? changeCamera(
                                    resolution: ResolutionPreset.ultraHigh)
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.high_quality),
                            color: AppColor.gray30,
                            onPressed: () => cameraController
                                        .mediaSettings.resolutionPreset !=
                                    ResolutionPreset.max
                                ? changeCamera(resolution: ResolutionPreset.max)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      child: cameraShutterWidget(),
                    ),
                    Positioned(
                      bottom: 0,
                      child: takePhotoButton(context, controller),
                    ),
                  ],
                )),
    );
  }

  Container takePhotoButton(
      BuildContext context, CameraScreenController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.gray100.withOpacity(0.4),
      height: widget.bottomHeight,
      child: Center(
        child: TakePhotoButton(
          isSamePose: _isSamePose,
          onPressed: () async {
            controller.takePhoto(context, cameraController);
            setState(() {
              _isSamePose = !_isSamePose;
              _isShutterOperating = true;
            });
          },
          maxHeight: widget.bottomHeight,
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: widget.bottomHeight * 0.5,
          minWidth: widget.bottomHeight * 0.5,
        ),
      ),
    );
  }

  IgnorePointer cameraShutterWidget() {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        color: _isShutterOperating
            ? AppColor.gray100.withOpacity(0.8)
            : Colors.transparent,
        onEnd: () => setState(() => _isShutterOperating = false),
      ),
    );
  }

  // ##############################################################

  List<Widget> getAnimatedArmsPainterFromPersons(
      Map<int, Person?> persons, Size widgetSize) {
    return List.generate(
        10,
        (index) => Positioned(
            top: 0,
            child: persons[index] != null
                ? getAnimatedArmsPainterFromPerson(
                    persons[index]!, widgetSize, index)
                : const SizedBox()));
  }

  AnimatedArmsPainter getAnimatedArmsPainterFromPerson(
      Person person, Size widgetSize, int id) {
    return AnimatedArmsPainter(
      person: person,
      widgetWidth: widgetSize.width,
      widgetHeight: widgetSize.height,
      colorIndex: id,
    );
  }

  List<Widget> getAnimatedLegsPainterFromPersons(
      Map<int, Person?> persons, Size widgetSize) {
    return List.generate(
        10,
        (index) => Positioned(
            top: 0,
            child: persons[index] != null
                ? getAnimatedLegsPainterFromPerson(
                    persons[index]!, widgetSize, index)
                : const SizedBox()));
  }

  AnimatedLegsPainter getAnimatedLegsPainterFromPerson(
      Person person, Size widgetSize, int id) {
    return AnimatedLegsPainter(
      person: person,
      widgetWidth: widgetSize.width,
      widgetHeight: widgetSize.height,
      colorIndex: id,
    );
  }

  List<Widget> getAnimatedPersonPainterFromPersons(
      Map<int, Person?> persons, Size widgetSize) {
    return List.generate(
        10,
        (index) => Positioned(
            top: 0,
            child: persons[index] != null
                ? getAnimatedPersonPainterFromPerson(
                    persons[index]!, widgetSize, index)
                : const SizedBox()));
  }

  AnimatedPersonPainter getAnimatedPersonPainterFromPerson(
      Person person, Size widgetSize, int id) {
    return AnimatedPersonPainter(
      person: person,
      widgetWidth: widgetSize.width,
      widgetHeight: widgetSize.height,
      colorIndex: id,
    );
  }

  List<Widget> getAnimatedBodyPainterFromPersons(
      Map<int, Person?> persons, Size widgetSize) {
    return List.generate(
        10,
        (index) => Positioned(
            top: 0,
            child: persons[index] != null
                ? getAnimatedBodyPainterFromPerson(
                    persons[index]!, widgetSize, index)
                : const SizedBox()));
  }

  AnimatedBodyPainter getAnimatedBodyPainterFromPerson(
      Person person, Size widgetSize, int id) {
    return AnimatedBodyPainter(
      person: person,
      widgetWidth: widgetSize.width,
      widgetHeight: widgetSize.height,
      colorIndex: id,
    );
  }

  List<Widget> getAnimatedFacePainterFromPersons(
      Map<int, Person?> persons, Size widgetSize) {
    return List.generate(
        10,
        (index) => Positioned(
            top: 0,
            child: persons[index] != null
                ? getAnimatedFacePainterFromPerson(
                    persons[index]!, widgetSize, index)
                : const SizedBox()));
  }

  AnimatedFacePainter getAnimatedFacePainterFromPerson(
      Person person, Size widgetSize, int id) {
    return AnimatedFacePainter(
      person: person,
      widgetWidth: widgetSize.width,
      widgetHeight: widgetSize.height,
      colorIndex: id,
    );
  }

  List<Widget> getAnimatedPersonBoundaries(
      Map<int, Person?> persons, Size widgetSize) {
    return List.generate(
        10,
        (index) => Positioned(
            top: 0,
            child: persons[index] != null
                ? getAnimatedPersonBoundary(persons[index]!, widgetSize, index)
                : const SizedBox()));
  }

  AnimatedBodyboundaryPainter getAnimatedPersonBoundary(
      Person person, Size widgetSize, int index) {
    return AnimatedBodyboundaryPainter(
        person: person,
        widgetWidth: widgetSize.width,
        widgetHeight: widgetSize.height);
  }
}

class CameraViewWidget extends StatelessWidget {
  const CameraViewWidget({
    super.key,
    required this.cameraController,
  });

  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: cameraController.value.previewSize!.width *
          (MediaQuery.of(context).size.width /
              cameraController.value.previewSize!.height),
      // child: CameraPreview(cameraController),
      child: cameraController
          .buildPreview(), // 빌드 메소드로 Texture 직접 빌드하면 스택 내에 넣거나 등으로 사이즈 조절 할 수 있지 않나?
    );
  }
}
