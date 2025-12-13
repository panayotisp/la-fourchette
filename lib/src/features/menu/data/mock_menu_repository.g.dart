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

@ProviderFor(currentWeekMenu)
const currentWeekMenuProvider = CurrentWeekMenuProvider._();

final class CurrentWeekMenuProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklyMenu>,
          WeeklyMenu,
          FutureOr<WeeklyMenu>
        >
    with $FutureModifier<WeeklyMenu>, $FutureProvider<WeeklyMenu> {
  const CurrentWeekMenuProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWeekMenuProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWeekMenuHash();

  @$internal
  @override
  $FutureProviderElement<WeeklyMenu> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WeeklyMenu> create(Ref ref) {
    return currentWeekMenu(ref);
  }
}

String _$currentWeekMenuHash() => r'c5ef68029e968ab715feb14707a4c1a9c4ab5401';
