// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminOrders)
const adminOrdersProvider = AdminOrdersProvider._();

final class AdminOrdersProvider
    extends $AsyncNotifierProvider<AdminOrders, List<Reservation>> {
  const AdminOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminOrdersHash();

  @$internal
  @override
  AdminOrders create() => AdminOrders();
}

String _$adminOrdersHash() => r'453312acd59289f037452e1ba5b8a46499caba99';

abstract class _$AdminOrders extends $AsyncNotifier<List<Reservation>> {
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
