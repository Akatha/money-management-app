// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validators.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passShowHash() => r'a048d7148c086bd1caa42735d3b46df3bd524c16';

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

abstract class _$PassShow extends BuildlessAutoDisposeNotifier<bool> {
  late final int id;

  bool build({
    required int id,
  });
}

/// See also [PassShow].
@ProviderFor(PassShow)
const passShowProvider = PassShowFamily();

/// See also [PassShow].
class PassShowFamily extends Family<bool> {
  /// See also [PassShow].
  const PassShowFamily();

  /// See also [PassShow].
  PassShowProvider call({
    required int id,
  }) {
    return PassShowProvider(
      id: id,
    );
  }

  @override
  PassShowProvider getProviderOverride(
    covariant PassShowProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'passShowProvider';
}

/// See also [PassShow].
class PassShowProvider extends AutoDisposeNotifierProviderImpl<PassShow, bool> {
  /// See also [PassShow].
  PassShowProvider({
    required int id,
  }) : this._internal(
          () => PassShow()..id = id,
          from: passShowProvider,
          name: r'passShowProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$passShowHash,
          dependencies: PassShowFamily._dependencies,
          allTransitiveDependencies: PassShowFamily._allTransitiveDependencies,
          id: id,
        );

  PassShowProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  bool runNotifierBuild(
    covariant PassShow notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(PassShow Function() create) {
    return ProviderOverride(
      origin: this,
      override: PassShowProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PassShow, bool> createElement() {
    return _PassShowProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PassShowProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PassShowRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PassShowProviderElement
    extends AutoDisposeNotifierProviderElement<PassShow, bool>
    with PassShowRef {
  _PassShowProviderElement(super.provider);

  @override
  int get id => (origin as PassShowProvider).id;
}

String _$validateModeHash() => r'bfe7c0ae72705d39f86351d125eac5c80717eded';

abstract class _$validateMode
    extends BuildlessAutoDisposeNotifier<AutovalidateMode> {
  late final int id;

  AutovalidateMode build({
    required int id,
  });
}

/// See also [validateMode].
@ProviderFor(validateMode)
const validateModeProvider = ValidateModeFamily();

/// See also [validateMode].
class ValidateModeFamily extends Family<AutovalidateMode> {
  /// See also [validateMode].
  const ValidateModeFamily();

  /// See also [validateMode].
  ValidateModeProvider call({
    required int id,
  }) {
    return ValidateModeProvider(
      id: id,
    );
  }

  @override
  ValidateModeProvider getProviderOverride(
    covariant ValidateModeProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'validateModeProvider';
}

/// See also [validateMode].
class ValidateModeProvider
    extends AutoDisposeNotifierProviderImpl<validateMode, AutovalidateMode> {
  /// See also [validateMode].
  ValidateModeProvider({
    required int id,
  }) : this._internal(
          () => validateMode()..id = id,
          from: validateModeProvider,
          name: r'validateModeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$validateModeHash,
          dependencies: ValidateModeFamily._dependencies,
          allTransitiveDependencies:
              ValidateModeFamily._allTransitiveDependencies,
          id: id,
        );

  ValidateModeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  AutovalidateMode runNotifierBuild(
    covariant validateMode notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(validateMode Function() create) {
    return ProviderOverride(
      origin: this,
      override: ValidateModeProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<validateMode, AutovalidateMode>
      createElement() {
    return _ValidateModeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidateModeProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ValidateModeRef on AutoDisposeNotifierProviderRef<AutovalidateMode> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ValidateModeProviderElement
    extends AutoDisposeNotifierProviderElement<validateMode, AutovalidateMode>
    with ValidateModeRef {
  _ValidateModeProviderElement(super.provider);

  @override
  int get id => (origin as ValidateModeProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
