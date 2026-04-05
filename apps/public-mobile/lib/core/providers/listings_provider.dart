import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'country_provider.dart';
import '../services/listings_service.dart';

final listingsServiceProvider = Provider<ListingsService>((ref) {
  return ListingsService();
});

/// Parameters for listings query
class ListingsParams {
  final int? page;
  final int? limit;
  final String? type;
  /// Comma-separated listing types for GET /listings?types=
  final String? types;
  final String? category;
  /// When true with [category], backend includes descendant categories.
  final bool includeChildren;
  final String? city;
  final String? country;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final double? rating;
  final bool? isFeatured;
  final String? sortBy;
  final String? status;

  const ListingsParams({
    this.page,
    this.limit,
    this.type,
    this.types,
    this.category,
    this.includeChildren = false,
    this.city,
    this.country,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.rating,
    this.isFeatured,
    this.sortBy,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingsParams &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit &&
          type == other.type &&
          types == other.types &&
          category == other.category &&
          includeChildren == other.includeChildren &&
          city == other.city &&
          country == other.country &&
          search == other.search &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          rating == other.rating &&
          isFeatured == other.isFeatured &&
          sortBy == other.sortBy &&
          status == other.status;

  @override
  int get hashCode =>
      page.hashCode ^
      limit.hashCode ^
      type.hashCode ^
      types.hashCode ^
      category.hashCode ^
      includeChildren.hashCode ^
      city.hashCode ^
      country.hashCode ^
      search.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      rating.hashCode ^
      isFeatured.hashCode ^
      sortBy.hashCode ^
      status.hashCode;
}

/// Provider for all listings with pagination
final listingsProvider = FutureProvider.family<Map<String, dynamic>, ListingsParams>((ref, params) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getListings(
    page: params.page,
    limit: params.limit,
    type: params.type,
    types: params.types,
    category: params.category,
    includeChildren: params.includeChildren,
    city: params.city,
    country: params.country,
    search: params.search,
    minPrice: params.minPrice,
    maxPrice: params.maxPrice,
    rating: params.rating,
    isFeatured: params.isFeatured,
    sortBy: params.sortBy,
    status: params.status,
  );
});

/// Provider for featured listings
final featuredListingsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, countryId) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getFeaturedListings(countryId: countryId);
});

/// Same dataset as home "Recommended" carousel: featured for the selected country, or all featured when that is empty.
final featuredListingsWithHomeFallbackProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final countryId = ref.watch(selectedCountryProvider).value?.id;
  final listingsService = ref.watch(listingsServiceProvider);
  var list = await listingsService.getFeaturedListings(countryId: countryId);
  if (list.isEmpty) {
    list = await listingsService.getFeaturedListings(countryId: null);
  }
  return list;
});

/// Parameters for nearby listings query
class NearbyListingsParams {
  final double latitude;
  final double longitude;
  final double? radiusKm;
  final int? limit;
  final String? type;

  const NearbyListingsParams({
    required this.latitude,
    required this.longitude,
    this.radiusKm,
    this.limit,
    this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NearbyListingsParams &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          radiusKm == other.radiusKm &&
          limit == other.limit &&
          type == other.type;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      radiusKm.hashCode ^
      limit.hashCode ^
      type.hashCode;
}

/// Provider for nearby listings
final nearbyListingsProvider = FutureProvider.family<List<Map<String, dynamic>>, NearbyListingsParams>((ref, params) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getNearbyListings(
    latitude: params.latitude,
    longitude: params.longitude,
    radiusKm: params.radiusKm ?? 10.0,
    limit: params.limit,
    type: params.type,
  );
});

/// Home Explore “Near Me” horizontal strip count.
const int kRandomNearMePreviewLimit = 5;

/// Full list when opening “View more” from Near Me (same `/listings/random` source).
const int kRandomNearMeFullListLimit = 40;

/// Provider for random listings (for Near Me section until geolocation is implemented)
final randomListingsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, limit) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getRandomListings(limit: limit);
});

/// Parameters for listings by type query
class ListingsByTypeParams {
  final String type;
  final int? page;
  final int? limit;
  final String? category;
  final String? city;
  final String? search;
  final String? status;

  const ListingsByTypeParams({
    required this.type,
    this.page,
    this.limit,
    this.category,
    this.city,
    this.search,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingsByTypeParams &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          page == other.page &&
          limit == other.limit &&
          category == other.category &&
          city == other.city &&
          search == other.search &&
          status == other.status;

  @override
  int get hashCode =>
      type.hashCode ^
      page.hashCode ^
      limit.hashCode ^
      category.hashCode ^
      city.hashCode ^
      search.hashCode ^
      status.hashCode;
}

/// Provider for listings by type
final listingsByTypeProvider = FutureProvider.family<Map<String, dynamic>, ListingsByTypeParams>((ref, params) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getListingsByType(
    type: params.type,
    page: params.page,
    limit: params.limit,
    category: params.category,
    city: params.city,
    search: params.search,
    status: params.status,
  );
});

/// Provider for single listing by ID
final listingByIdProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getListingById(id);
});

/// Provider for single listing by slug
final listingBySlugProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, slug) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getListingBySlug(slug);
});

/// Provider for merchant listings
final merchantListingsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, merchantId) async {
  final listingsService = ref.watch(listingsServiceProvider);
  return await listingsService.getListingsByMerchant(merchantId);
});

