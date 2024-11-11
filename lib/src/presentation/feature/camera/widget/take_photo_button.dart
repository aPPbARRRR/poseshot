import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poseshot/src/presentation/const/app_color.dart';

class TakePhotoButton extends StatefulWidget {
  const TakePhotoButton({
    super.key,
    required this.isSamePose,
    required this.onPressed,
    required this.maxWidth,
    required this.maxHeight,
    required this.minWidth,
    required this.minHeight,
  });

  final bool isSamePose;
  final Function() onPressed;
  final double maxWidth;
  final double maxHeight;
  final double minWidth;
  final double minHeight;

  @override
  State<TakePhotoButton> createState() => _TakePhotoButtonState();
}

class _TakePhotoButtonState extends State<TakePhotoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _width;
  late Animation<double> _height;
  late Animation<Color> _color;

  // late final Animation<double> animation;

  late double _curWidth = widget.minWidth;
  late double _curHeight = widget.minHeight;
  late Color _curColor = AppColor.gray40;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    // animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.addListener(() {
      setState(() {
        _curWidth = _width.value;
        _curHeight = _height.value;
        _curColor = _color.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant TakePhotoButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSamePose != widget.isSamePose) {
      _width = Tween<double>(
        begin: _curWidth,
        end: widget.isSamePose ? widget.maxWidth : widget.minWidth,
      ).animate(_animationController);

      _height = Tween<double>(
        begin: _curHeight,
        end: widget.isSamePose ? widget.maxHeight : widget.minHeight,
      ).animate(_animationController);

      _color = Tween<Color>(
        begin: _curColor,
        end: widget.isSamePose ? AppColor.primaryMain : AppColor.gray40,
      ).animate(_animationController);

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: Container(
            width: _curWidth,
            // isSamePose
            //     ? widget.maxWidth.toDouble()
            //     : widget.minWidth.toDouble(),
            height: _curHeight,
            // isSamePose
            //     ? widget.maxHeight.toDouble()
            //     : widget.minHeight.toDouble(),
            decoration: BoxDecoration(
              color: AppColor.primaryMain,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: _curColor,
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.gray30,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'asset/image/logo_without_ball.svg',
                        color: _curColor,
                      ),
                    )),
              ),
            )),
      ),
    );
  }
}
