// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_menu_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiMenuRepository)
const apiMenuRepositoryProvider = ApiMenuRepositoryProvider._();

final class ApiMenuRepositoryProvider
    extends
        $FunctionalProvider<
          ApiMenuRepository,
          ApiMenuRepository,
          ApiMenuRepository
        >
    with $Provider<ApiMenuRepository> {
  const ApiMenuRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiMenuRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiMenuRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApiMenuRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApiMenuRepository create(Ref ref) {
    return apiMenuRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiMenuRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiMenuRepository>(value),
    );
  }
}

String _$apiMenuRepositoryHash() => r'fbeca52831e6bd2d277bd6101cbeb0229b5b3d48';

@ProviderFor(currentWeekMenuApi)
const currentWeekMenuApiProvider = CurrentWeekMenuApiProvider._();

final class CurrentWeekMenuApiProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklyMenu>,
          WeeklyMenu,
          FutureOr<WeeklyMenu>
        >
    with $FutureModifier<WeeklyMenu>, $FutureProvider<WeeklyMenu> {
  const CurrentWeekMenuApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWeekMenuApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWeekMenuApiHash();

  @$internal
  @override
  $FutureProviderElement<WeeklyMenu> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WeeklyMenu> create(Ref ref) {
    return currentWeekMenuApi(ref);
  }
}

String _$currentWeekMenuApiHash() =>
    r'4a3b22dd5591ea0d7e5cde5157c70f325ed5b41c';
