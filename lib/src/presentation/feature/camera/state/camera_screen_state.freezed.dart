// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CameraScreenState {
  int get selectedCameraIndex => throw _privateConstructorUsedError;
  int get timerSeconds => throw _privateConstructorUsedError;
  double get guideLineOpacity => throw _privateConstructorUsedError;
  double get guidePhotoOpacity => throw _privateConstructorUsedError;
  AlbumMetadata get selectedAlbum => throw _privateConstructorUsedError;
  AppPhoto? get guidePhoto => throw _privateConstructorUsedError;
  int get resolutionNumber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CameraScreenStateCopyWith<CameraScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraScreenStateCopyWith<$Res> {
  factory $CameraScreenStateCopyWith(
          CameraScreenState value, $Res Function(CameraScreenState) then) =
      _$CameraScreenStateCopyWithImpl<$Res, CameraScreenState>;
  @useResult
  $Res call(
      {int selectedCameraIndex,
      int timerSeconds,
      double guideLineOpacity,
      double guidePhotoOpacity,
      AlbumMetadata selectedAlbum,
      AppPhoto? guidePhoto,
      int resolutionNumber});

  $AlbumMetadataCopyWith<$Res> get selectedAlbum;
  $AppPhotoCopyWith<$Res>? get guidePhoto;
}

/// @nodoc
class _$CameraScreenStateCopyWithImpl<$Res, $Val extends CameraScreenState>
    implements $CameraScreenStateCopyWith<$Res> {
  _$CameraScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCameraIndex = null,
    Object? timerSeconds = null,
    Object? guideLineOpacity = null,
    Object? guidePhotoOpacity = null,
    Object? selectedAlbum = null,
    Object? guidePhoto = freezed,
    Object? resolutionNumber = null,
  }) {
    return _then(_value.copyWith(
      selectedCameraIndex: null == selectedCameraIndex
          ? _value.selectedCameraIndex
          : selectedCameraIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timerSeconds: null == timerSeconds
          ? _value.timerSeconds
          : timerSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      guideLineOpacity: null == guideLineOpacity
          ? _value.guideLineOpacity
          : guideLineOpacity // ignore: cast_nullable_to_non_nullable
              as double,
      guidePhotoOpacity: null == guidePhotoOpacity
          ? _value.guidePhotoOpacity
          : guidePhotoOpacity // ignore: cast_nullable_to_non_nullable
              as double,
      selectedAlbum: null == selectedAlbum
          ? _value.selectedAlbum
          : selectedAlbum // ignore: cast_nullable_to_non_nullable
              as AlbumMetadata,
      guidePhoto: freezed == guidePhoto
          ? _value.guidePhoto
          : guidePhoto // ignore: cast_nullable_to_non_nullable
              as AppPhoto?,
      resolutionNumber: null == resolutionNumber
          ? _value.resolutionNumber
          : resolutionNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AlbumMetadataCopyWith<$Res> get selectedAlbum {
    return $AlbumMetadataCopyWith<$Res>(_value.selectedAlbum, (value) {
      return _then(_value.copyWith(selectedAlbum: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AppPhotoCopyWith<$Res>? get guidePhoto {
    if (_value.guidePhoto == null) {
      return null;
    }

    return $AppPhotoCopyWith<$Res>(_value.guidePhoto!, (value) {
      return _then(_value.copyWith(guidePhoto: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CameraScreenStateImplCopyWith<$Res>
    implements $CameraScreenStateCopyWith<$Res> {
  factory _$$CameraScreenStateImplCopyWith(_$CameraScreenStateImpl value,
          $Res Function(_$CameraScreenStateImpl) then) =
      __$$CameraScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int selectedCameraIndex,
      int timerSeconds,
      double guideLineOpacity,
      double guidePhotoOpacity,
      AlbumMetadata selectedAlbum,
      AppPhoto? guidePhoto,
      int resolutionNumber});

  @override
  $AlbumMetadataCopyWith<$Res> get selectedAlbum;
  @override
  $AppPhotoCopyWith<$Res>? get guidePhoto;
}

/// @nodoc
class __$$CameraScreenStateImplCopyWithImpl<$Res>
    extends _$CameraScreenStateCopyWithImpl<$Res, _$CameraScreenStateImpl>
    implements _$$CameraScreenStateImplCopyWith<$Res> {
  __$$CameraScreenStateImplCopyWithImpl(_$CameraScreenStateImpl _value,
      $Res Function(_$CameraScreenStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCameraIndex = null,
    Object? timerSeconds = null,
    Object? guideLineOpacity = null,
    Object? guidePhotoOpacity = null,
    Object? selectedAlbum = null,
    Object? guidePhoto = freezed,
    Object? resolutionNumber = null,
  }) {
    return _then(_$CameraScreenStateImpl(
      selectedCameraIndex: null == selectedCameraIndex
          ? _value.selectedCameraIndex
          : selectedCameraIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timerSeconds: null == timerSeconds
          ? _value.timerSeconds
          : timerSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      guideLineOpacity: null == guideLineOpacity
          ? _value.guideLineOpacity
          : guideLineOpacity // ignore: cast_nullable_to_non_nullable
              as double,
      guidePhotoOpacity: null == guidePhotoOpacity
          ? _value.guidePhotoOpacity
          : guidePhotoOpacity // ignore: cast_nullable_to_non_nullable
              as double,
      selectedAlbum: null == selectedAlbum
          ? _value.selectedAlbum
          : selectedAlbum // ignore: cast_nullable_to_non_nullable
              as AlbumMetadata,
      guidePhoto: freezed == guidePhoto
          ? _value.guidePhoto
          : guidePhoto // ignore: cast_nullable_to_non_nullable
              as AppPhoto?,
      resolutionNumber: null == resolutionNumber
          ? _value.resolutionNumber
          : resolutionNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CameraScreenStateImpl
    with DiagnosticableTreeMixin
    implements _CameraScreenState {
  _$CameraScreenStateImpl(
      {required this.selectedCameraIndex,
      required this.timerSeconds,
      required this.guideLineOpacity,
      required this.guidePhotoOpacity,
      required this.selectedAlbum,
      required this.guidePhoto,
      required this.resolutionNumber});

  @override
  final int selectedCameraIndex;
  @override
  final int timerSeconds;
  @override
  final double guideLineOpacity;
  @override
  final double guidePhotoOpacity;
  @override
  final AlbumMetadata selectedAlbum;
  @override
  final AppPhoto? guidePhoto;
  @override
  final int resolutionNumber;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CameraScreenState(selectedCameraIndex: $selectedCameraIndex, timerSeconds: $timerSeconds, guideLineOpacity: $guideLineOpacity, guidePhotoOpacity: $guidePhotoOpacity, selectedAlbum: $selectedAlbum, guidePhoto: $guidePhoto, resolutionNumber: $resolutionNumber)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CameraScreenState'))
      ..add(DiagnosticsProperty('selectedCameraIndex', selectedCameraIndex))
      ..add(DiagnosticsProperty('timerSeconds', timerSeconds))
      ..add(DiagnosticsProperty('guideLineOpacity', guideLineOpacity))
      ..add(DiagnosticsProperty('guidePhotoOpacity', guidePhotoOpacity))
      ..add(DiagnosticsProperty('selectedAlbum', selectedAlbum))
      ..add(DiagnosticsProperty('guidePhoto', guidePhoto))
      ..add(DiagnosticsProperty('resolutionNumber', resolutionNumber));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraScreenStateImpl &&
            (identical(other.selectedCameraIndex, selectedCameraIndex) ||
                other.selectedCameraIndex == selectedCameraIndex) &&
            (identical(other.timerSeconds, timerSeconds) ||
                other.timerSeconds == timerSeconds) &&
            (identical(other.guideLineOpacity, guideLineOpacity) ||
                other.guideLineOpacity == guideLineOpacity) &&
            (identical(other.guidePhotoOpacity, guidePhotoOpacity) ||
                other.guidePhotoOpacity == guidePhotoOpacity) &&
            (identical(other.selectedAlbum, selectedAlbum) ||
                other.selectedAlbum == selectedAlbum) &&
            (identical(other.guidePhoto, guidePhoto) ||
                other.guidePhoto == guidePhoto) &&
            (identical(other.resolutionNumber, resolutionNumber) ||
                other.resolutionNumber == resolutionNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedCameraIndex,
      timerSeconds,
      guideLineOpacity,
      guidePhotoOpacity,
      selectedAlbum,
      guidePhoto,
      resolutionNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraScreenStateImplCopyWith<_$CameraScreenStateImpl> get copyWith =>
      __$$CameraScreenStateImplCopyWithImpl<_$CameraScreenStateImpl>(
          this, _$identity);
}

abstract class _CameraScreenState implements CameraScreenState {
  factory _CameraScreenState(
      {required final int selectedCameraIndex,
      required final int timerSeconds,
      required final double guideLineOpacity,
      required final double guidePhotoOpacity,
      required final AlbumMetadata selectedAlbum,
      required final AppPhoto? guidePhoto,
      required final int resolutionNumber}) = _$CameraScreenStateImpl;

  @override
  int get selectedCameraIndex;
  @override
  int get timerSeconds;
  @override
  double get guideLineOpacity;
  @override
  double get guidePhotoOpacity;
  @override
  AlbumMetadata get selectedAlbum;
  @override
  AppPhoto? get guidePhoto;
  @override
  int get resolutionNumber;
  @override
  @JsonKey(ignore: true)
  _$$CameraScreenStateImplCopyWith<_$CameraScreenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
