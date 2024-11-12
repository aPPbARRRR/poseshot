import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/detected_persons_provider.dart';

import 'animated_person_painter.dart';

class DetectedPersonWidget extends ConsumerWidget {
  const DetectedPersonWidget(
      {super.key, required this.index, required this.widgetSize});

  final int index;
  final Size widgetSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(detectedPersonsProvider);

    return Positioned(
      top: 0,
      child: state[index] == null
          ? const SizedBox()
          : AnimatedPersonPainter(
              person: state[index]!,
              widgetWidth: widgetSize.width,
              widgetHeight: widgetSize.height,
              colorIndex: index,
            ),
    );
  }
}
