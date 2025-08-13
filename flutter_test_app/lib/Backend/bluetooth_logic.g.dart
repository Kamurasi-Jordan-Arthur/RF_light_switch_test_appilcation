// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bleStatusHash() => r'2eb06c0fbcf88d4bd606679eab12615e6128657f';

/// See also [bleStatus].
@ProviderFor(bleStatus)
final bleStatusProvider = AutoDisposeStreamProvider<BleStatus>.internal(
  bleStatus,
  name: r'bleStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bleStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BleStatusRef = AutoDisposeStreamProviderRef<BleStatus>;
String _$connecToDeviceHash() => r'6f705badb1a772993455dcd43780e4291e0dbbbd';

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

/// See also [connecToDevice].
@ProviderFor(connecToDevice)
const connecToDeviceProvider = ConnecToDeviceFamily();

/// See also [connecToDevice].
class ConnecToDeviceFamily extends Family<AsyncValue<ConnectionStateUpdate>> {
  /// See also [connecToDevice].
  const ConnecToDeviceFamily();

  /// See also [connecToDevice].
  ConnecToDeviceProvider call({required int index}) {
    return ConnecToDeviceProvider(index: index);
  }

  @override
  ConnecToDeviceProvider getProviderOverride(
    covariant ConnecToDeviceProvider provider,
  ) {
    return call(index: provider.index);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'connecToDeviceProvider';
}

/// See also [connecToDevice].
class ConnecToDeviceProvider
    extends AutoDisposeStreamProvider<ConnectionStateUpdate> {
  /// See also [connecToDevice].
  ConnecToDeviceProvider({required int index})
    : this._internal(
        (ref) => connecToDevice(ref as ConnecToDeviceRef, index: index),
        from: connecToDeviceProvider,
        name: r'connecToDeviceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$connecToDeviceHash,
        dependencies: ConnecToDeviceFamily._dependencies,
        allTransitiveDependencies:
            ConnecToDeviceFamily._allTransitiveDependencies,
        index: index,
      );

  ConnecToDeviceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.index,
  }) : super.internal();

  final int index;

  @override
  Override overrideWith(
    Stream<ConnectionStateUpdate> Function(ConnecToDeviceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConnecToDeviceProvider._internal(
        (ref) => create(ref as ConnecToDeviceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        index: index,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ConnectionStateUpdate> createElement() {
    return _ConnecToDeviceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConnecToDeviceProvider && other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConnecToDeviceRef on AutoDisposeStreamProviderRef<ConnectionStateUpdate> {
  /// The parameter `index` of this provider.
  int get index;
}

class _ConnecToDeviceProviderElement
    extends AutoDisposeStreamProviderElement<ConnectionStateUpdate>
    with ConnecToDeviceRef {
  _ConnecToDeviceProviderElement(super.provider);

  @override
  int get index => (origin as ConnecToDeviceProvider).index;
}

String _$foundBleDevicesHash() => r'bfccc228d0bd484fc1ab7d787597ace5ad8c338b';

/// See also [FoundBleDevices].
@ProviderFor(FoundBleDevices)
final foundBleDevicesProvider =
    AutoDisposeNotifierProvider<
      FoundBleDevices,
      List<DiscoveredDevice>
    >.internal(
      FoundBleDevices.new,
      name: r'foundBleDevicesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$foundBleDevicesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FoundBleDevices = AutoDisposeNotifier<List<DiscoveredDevice>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
