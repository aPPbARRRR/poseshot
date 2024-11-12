import 'package:poseshot/src/model/person.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'detected_persons_provider.g.dart';

@riverpod
class DetectedPersons extends _$DetectedPersons {
  @override
  Map<int, Person?> build() {
    return {
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
  }

  void updatePerson(Map<int, Person?> persons) => state = persons;
}
