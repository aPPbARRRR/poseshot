// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cameraScreenControllerHash() =>
    r'4ed9bd996962e7159e24b4585796c31bb1be13d4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CameraScreenController
    extends BuildlessAutoDisposeAsyncNotifier<CameraScreenState> {
  late final String? albumUid;

  FutureOr<CameraScreenState> build({
    String? albumUid,
  });
}

/// See also [CameraScreenController].
@ProviderFor(CameraScreenController)
const cameraScreenControllerProvider = CameraScreenControllerFamily();

/// See also [CameraScreenController].
class CameraScreenControllerFamily
    extends Family<AsyncValue<CameraScreenState>> {
  /// See also [CameraScreenController].
  const CameraScreenControllerFamily();

  /// See also [CameraScreenController].
  CameraScreenControllerProvider call({
    String? albumUid,
  }) {
    return CameraScreenControllerProvider(
      albumUid: albumUid,
    );
  }

  @override
  CameraScreenControllerProvider getProviderOverride(
    covariant CameraScreenControllerProvider provider,
  ) {
    return call(
      albumUid: provider.albumUid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cameraScreenControllerProvider';
}

/// See also [CameraScreenController].
class CameraScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CameraScreenController,
        CameraScreenState> {
  /// See also [CameraScreenController].
  CameraScreenControllerProvider({
    String? albumUid,
  }) : this._internal(
          () => CameraScreenController()..albumUid = albumUid,
          from: cameraScreenControllerProvider,
          name: r'cameraScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cameraScreenControllerHash,
          dependencies: CameraScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              CameraScreenControllerFamily._allTransitiveDependencies,
          albumUid: albumUid,
        );

  CameraScreenControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.albumUid,
  }) : super.internal();

  final String? albumUid;

  @override
  FutureOr<CameraScreenState> runNotifierBuild(
    covariant CameraScreenController notifier,
  ) {
    return notifier.build(
      albumUid: albumUid,
    );
  }

  @override
  Override overrideWith(CameraScreenController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CameraScreenControllerProvider._internal(
        () => create()..albumUid = albumUid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        albumUid: albumUid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CameraScreenController,
      CameraScreenState> createElement() {
    return _CameraScreenControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CameraScreenControllerProvider &&
        other.albumUid == albumUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, albumUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CameraScreenControllerRef
    on AutoDisposeAsyncNotifierProviderRef<CameraScreenState> {
  /// The parameter `albumUid` of this provider.
  String? get albumUid;
}

class _CameraScreenControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CameraScreenController,
        CameraScreenState> with CameraScreenControllerRef {
  _CameraScreenControllerProviderElement(super.provider);

  @override
  String? get albumUid => (origin as CameraScreenControllerProvider).albumUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
