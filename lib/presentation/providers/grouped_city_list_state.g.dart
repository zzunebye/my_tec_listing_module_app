// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_city_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupedCityListStateHash() =>
    r'7abfa5152630759d11eea63012d888d72c436c33';

/// Provider that groups cities by region for UI consumption
///
/// Copied from [GroupedCityListState].
@ProviderFor(GroupedCityListState)
final groupedCityListStateProvider =
    AutoDisposeAsyncNotifierProvider<
      GroupedCityListState,
      List<RegionWithCitiesEntity>
    >.internal(
      GroupedCityListState.new,
      name: r'groupedCityListStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupedCityListStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GroupedCityListState =
    AutoDisposeAsyncNotifier<List<RegionWithCitiesEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
