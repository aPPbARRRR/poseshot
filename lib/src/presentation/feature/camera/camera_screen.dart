import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poseshot/src/presentation/const/app_color.dart';
import 'package:poseshot/src/presentation/feature/camera/widget/detected_person_widget.dart';
import 'package:poseshot/src/presentation/feature/camera/widget/take_photo_button.dart';

import 'camera_screen_controller.dart';

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
        ),
        body: state.map(
          error: (_) => const Center(child: CircularProgressIndicator()),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          data: (data) {
            final cameraController = controller.cameraController;
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  child: CameraViewWidget(cameraController: cameraController),
                ),
                if (state.value != null && state.value!.guidePhoto != null)
                  Positioned(
                      top: 0,
                      child: Opacity(
                          opacity: state.value!
                              .guidePhotoOpacity, // 얘는 가이드 라인 보여주는걸로 수정해야함
                          child: Image.memory(
                              state.value!.guidePhoto!.imgeBytes))),
                if (state.value != null && state.value!.guidePhoto != null)
                  Positioned(
                      top: 0,
                      child: Opacity(
                          opacity: state.value!.guidePhotoOpacity,
                          child: Image.memory(
                              state.value!.guidePhoto!.imgeBytes))),
                if (cameraController.value.previewSize != null)
                  ...getDetectedPersonsWidget(
                      widgetSize: Size(
                          MediaQuery.of(context).size.width,
                          (MediaQuery.of(context).size.width) *
                              cameraController.value.aspectRatio)),
                Positioned(
                  top: 0,
                  child: resolutionButtons(
                      selectedResolutionIndex: controller.resolutions.indexOf(
                          controller.cameraController.mediaSettings
                                  .resolutionPreset ??
                              ResolutionPreset.max),
                      changeResolution: (index) =>
                          controller.selectResolution(index)),
                ),
                Positioned(
                  top: 0,
                  left: 50,
                  child: availableCameraButtons(
                      availableCamerasNumber: controller.cameras.length,
                      selectedCameraIndex: state.value!.selectedCameraIndex,
                      changeCamera: (index) => controller.selectCamera(index)),
                ),
                Positioned(
                  child: cameraShutterWidget(),
                ),
                Positioned(
                  bottom: 0,
                  child: takePhotoButton(context, controller),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column resolutionButtons(
      {required Function(int index) changeResolution,
      required int selectedResolutionIndex}) {
    final List<IconData> icons = [
      Icons.sd,
      Icons.hd,
      Icons.one_k,
      Icons.two_k,
      Icons.high_quality
    ];
    return Column(
      children: icons
          .map((icon) => IconButton(
                icon: Icon(icon,
                    color: icons.indexOf(icon) == selectedResolutionIndex
                        ? AppColor.primaryMain
                        : AppColor.gray30),
                onPressed: () => changeResolution(icons.indexOf(icon)),
              ))
          .toList(),
    );
  }

  Column availableCameraButtons(
      {required int availableCamerasNumber,
      required int selectedCameraIndex,
      required Function(int index) changeCamera}) {
    return Column(
      children: List.generate(
          availableCamerasNumber,
          (index) => IconButton(
                icon: Icon(Icons.camera,
                    color: index == selectedCameraIndex
                        ? AppColor.primaryMain
                        : AppColor.gray30),
                onPressed: () => changeCamera(index),
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
            controller.takePhoto(context);
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

  List<Widget> getDetectedPersonsWidget({required Size widgetSize}) =>
      List.generate(
          10,
          (index) =>
              DetectedPersonWidget(index: index, widgetSize: widgetSize));
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
      child: cameraController
          .buildPreview(), // 빌드 메소드로 Texture 직접 빌드하면 스택 내에 넣거나 등으로 사이즈 조절 할 수 있지 않나?
    );
  }
}
