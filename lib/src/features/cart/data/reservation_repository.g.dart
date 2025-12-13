// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReservationRepository)
const reservationRepositoryProvider = ReservationRepositoryProvider._();

final class ReservationRepositoryProvider
    extends $AsyncNotifierProvider<ReservationRepository, List<Reservation>> {
  const ReservationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reservationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reservationRepositoryHash();

  @$internal
  @override
  ReservationRepository create() => ReservationRepository();
}

String _$reservationRepositoryHash() =>
    r'17d3eba4af9c62ffd5398a060f17d244084b2fe8';

abstract class _$ReservationRepository
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
