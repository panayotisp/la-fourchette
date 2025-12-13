// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_reservation_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ApiReservationRepository)
const apiReservationRepositoryProvider = ApiReservationRepositoryProvider._();

final class ApiReservationRepositoryProvider
    extends
        $AsyncNotifierProvider<ApiReservationRepository, List<Reservation>> {
  const ApiReservationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiReservationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiReservationRepositoryHash();

  @$internal
  @override
  ApiReservationRepository create() => ApiReservationRepository();
}

String _$apiReservationRepositoryHash() =>
    r'8fb529d360fa16aec4b54c2b49671add5943b312';

abstract class _$ApiReservationRepository
    extends $AsyncNotifier<List<Reservation>> {
  FutureOr<List<Reservation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Reservation>>, List<Reservation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Reservation>>, List<Reservation>>,
              AsyncValue<List<Reservation>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
