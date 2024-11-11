import 'dart:math';

// import 'package:poseshot/develop_only/talker.dart';
import 'package:poseshot/src/model/object_bounding_box_extension.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../../model/person.dart';

class Tracker {
  final double _bestScoreThreshold = 0.2;
  List<Track> _tracks = [];
  Map<int, Track?> TracksMap = {
    0: null,
    1: null,
    2: null,
    3: null,
    4: null,
    5: null,
    6: null,
    7: null,
    8: null,
    9: null
  };

  final Stopwatch stopwatch = Stopwatch(); // 임시

  // 트랙 정리
  void _cleanTracks() {
    // talker.warning(
    // 'cleaning tracks : ${_tracks.map((e) => 'id:${e.id}/buffer:${e._buffer}')}');
    for (Track track in _tracks) {
      track.increaseBuffer();
    }

    _tracks.removeWhere((track) => track.isDead());
    // talker.warning(
    // 'cleaning tracks completed : ${_tracks.map((e) => 'id:${e.id}/buffer:${e._buffer}')}');
  }

  Map<int, Person?> getPersons(List<Person> newPersons) {
    // 외부 호출용.
    // 로직 수행 후 화면에 사용할 persons 반환
    stopwatch.start();
    Map<int, Track?> newTracksMap = Map.from(TracksMap);
    _tracks = _updateTracksWithNewPersons(_tracks, newPersons);
    _cleanTracks();
    // talker.warning('tracks: ${_tracks.length} / ${_tracks.map(
    //   (e) => e.id,
    // )}');

    for (Track track in _tracks) {
      newTracksMap[track.id] = track;
    }

    stopwatch.stop();
    // talker.warning('tracking time: ${stopwatch.elapsedMilliseconds}ms');
    stopwatch.reset();

    // Buffer 적용하여 리턴
    return _cleanTracksMap(newTracksMap)
        .map((key, value) => MapEntry(key, value?.person));
  }

  Map<int, Track?> _cleanTracksMap(Map<int, Track?> tracksMap) =>
      tracksMap..removeWhere((key, value) => value is Track && value.isDead());

  List<double> flatten(List<List<double>> list) =>
      list.expand((e) => e).toList();

  List<Track> _updateTracksWithNewPersons(
      List<Track> tracks, List<Person> newPersons) {
    if (tracks.isEmpty) {
      addPersons(tracks, newPersons);
      return tracks;
    }
    List<Person> remains = List.from(newPersons);

    final List<List<double>> iouScores =
        _getIOUs(tracks: tracks, newPersons: newPersons);
    // talker.error('iouScores: ${iouScores.length} / $iouScores');

    List<List<double>> iouScoresInLoop =
        _getIOUs(tracks: tracks, newPersons: newPersons);
    // iouScores.map((e) => e.map((f) => f).toList()).toList();

    while (remains.isNotEmpty && iouScoresInLoop.flatten().isNotEmpty) {
      double bestScore = iouScoresInLoop.flatten().length > 1
          ? iouScoresInLoop.flatten().reduce((a, b) => a > b ? a : b)
          : iouScoresInLoop.flatten().first;

      // talker.debug('bestScore: $bestScore');
      if (bestScore < _bestScoreThreshold) {
        break;
      }
      int trackIndex = _bestScoreIndexOfTrack(iouScores, bestScore);

      int newPersonIndex =
          _bestScoreIndexOfNewPersons(iouScores, bestScore, trackIndex);

      // talker
      // .warning('trackIndex: $trackIndex, newPersonIndex: $newPersonIndex');

      tracks[trackIndex].update(newPersons[newPersonIndex].copyWith(
          id: tracks[trackIndex]
              .id)); // 트랙 업데이트, id는 기존 트랙 id로 유지됨. 이 id는 최초 트랙에 추가될 때에 부여됨
      remains.remove(newPersons[newPersonIndex]);

      int indexOfBestScoreInIouScoreInLoop = iouScoresInLoop[
              iouScoresInLoop.indexWhere((e) => e.contains(bestScore))]
          .indexOf(bestScore);
      // 배정된 track과 person의 score를 삭제
      iouScoresInLoop.removeWhere((e) => e.contains(bestScore));
      for (List<double> iouScoreInLoop in iouScoresInLoop) {
        iouScoreInLoop.removeAt(indexOfBestScoreInIouScoreInLoop); // ##
      }

      // talker.error(iouScoresInLoop);
      // talker.debug(iouScores);
    }

    addPersons(tracks, remains);
    return tracks;
  }

  void addPersons(List<Track> tracks, List<Person> remains) {
    for (Person person in remains) {
      List<int> usingIds = tracks.map((track) => track.id).toList();
      int newId = 0;
      while (usingIds.contains(newId)) {
        newId++;
      }
      tracks.add(Track(id: newId, person: person));
    }
  }

  double _bestScore(List<List<double>> scoresLists) => scoresLists.length < 2
      ? scoresLists.expand((e) => e).first
      : scoresLists.expand((e) => e).reduce((a, b) => a > b ? a : b);

  int _bestScoreIndexOfTrack(
          List<List<double>> scoresLists, double bestScore) =>
      scoresLists.indexWhere((scores) => scores.contains(bestScore));

  int _bestScoreIndexOfNewPersons(List<List<double>> scoresLists,
          double bestScore, int bestScoreIndexOfTrack) =>
      scoresLists[bestScoreIndexOfTrack].indexOf(bestScore);

  // iou, aok 적용 유사도 점수 계산
  List<List<double>> _getIOUs(
          {required List<Track> tracks, required List<Person> newPersons}) =>
      tracks
          .map((track) => newPersons
              .map((newPerson) => _iou(track.person, newPerson))
              .toList())
          .toList();

  double _iou(Person a, Person b) {
    // iou, aok 적용 후 합산점수로 반환

    // 1차 시도 -> iou만 적용
    // 2차 시도 -> aok만 적용
    // 3차 시도 -> iou, aok 적용 후 합산점수로 반환
    double xMin = max(a.boundingBox.xMin, b.boundingBox.xMin);
    double yMin = max(a.boundingBox.yMin, b.boundingBox.yMin);
    double xMax = min(a.boundingBox.xMax, b.boundingBox.xMax);
    double yMax = min(a.boundingBox.yMax, b.boundingBox.yMax);
// 이하 iou 적용
    if (
        // a, b 바운딩 박스 겹치는 영역 없는 경우
        xMin >= xMax || yMin >= yMax) {
      return 0;
    }
    // a, b 바운딩 박스 겹치는 영역 있는 경우
    double intersection = (xMax - xMin) * (yMax - yMin); // 교차 영역 면적
    return intersection /
        (a.boundingBox.objectArea() +
            b.boundingBox.objectArea() -
            intersection); // IoU 계산 : 교집합면적/(a,b 합집합 전체 면적)
  }
}

class Track {
  final int id;
  Person _person;
  int _buffer;
  Track({required this.id, required Person person})
      : _person = person,
        _buffer = 0;

  Person get person => _person;
  int get buffer => _buffer;

  void update(Person person) {
    _person = person;
    _buffer = 0;
  }

  void increaseBuffer() {
    _buffer++;
  }

  bool isDead() {
    return _buffer > 2;
  }
}
