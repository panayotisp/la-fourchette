// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_menu_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mockMenuRepository)
const mockMenuRepositoryProvider = MockMenuRepositoryProvider._();

final class MockMenuRepositoryProvider
    extends
        $FunctionalProvider<
          MockMenuRepository,
          MockMenuRepository,
          MockMenuRepository
        >
    with $Provider<MockMenuRepository> {
  const MockMenuRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockMenuRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockMenuRepositoryHash();

  @$internal
  @override
  $ProviderElement<MockMenuRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MockMenuRepository create(Ref ref) {
    return mockMenuRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockMenuRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockMenuRepository>(value),
    );
  }
}

String _$mockMenuRepositoryHash() =>
    r'c9607b3cf7d62f4b3479b04702e2af5575ffaebf';
