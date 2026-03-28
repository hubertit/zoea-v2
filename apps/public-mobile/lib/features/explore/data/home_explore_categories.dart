/// Parent categories shown on the Explore home grid (order is fixed in the app).
/// [slug] is used for `/category/:slug` (resolved to categoryId on the server)
/// except [HomeCategoryNav.stay] and [HomeCategoryNav.events].
class HomeExploreCategoryTile {
  final String slug;
  final String defaultName;
  final String iconName;
  final HomeCategoryNav nav;

  const HomeExploreCategoryTile({
    required this.slug,
    required this.defaultName,
    required this.iconName,
    this.nav = HomeCategoryNav.categoryPlaces,
  });
}

enum HomeCategoryNav {
  /// `context.push('/category/:slug')` — listings filtered by that category’s id.
  categoryPlaces,

  /// `context.go('/accommodation')`
  stay,

  /// `context.go('/events')`
  events,
}

/// Order matches product layout: Events, Dining, Experiences, Nightlife, Accommodation, Shopping.
const kHomeExploreCategoryTiles = <HomeExploreCategoryTile>[
  HomeExploreCategoryTile(
    slug: 'events',
    defaultName: 'Events',
    iconName: 'event',
    nav: HomeCategoryNav.events,
  ),
  HomeExploreCategoryTile(
    slug: 'dining',
    defaultName: 'Dining',
    iconName: 'restaurant',
  ),
  HomeExploreCategoryTile(
    slug: 'experiences',
    defaultName: 'Experiences',
    iconName: 'explore',
  ),
  HomeExploreCategoryTile(
    slug: 'nightlife',
    defaultName: 'Nightlife',
    iconName: 'nightlife',
  ),
  HomeExploreCategoryTile(
    slug: 'accommodation',
    defaultName: 'Accommodation',
    iconName: 'hotel',
    nav: HomeCategoryNav.stay,
  ),
  HomeExploreCategoryTile(
    slug: 'shopping',
    defaultName: 'Shopping',
    iconName: 'shopping_bag',
  ),
];

/// Merge [kHomeExploreCategoryTiles] with API categories (match by slug).
List<Map<String, dynamic>> homeExploreCategoriesFromApi(
  List<Map<String, dynamic>> apiCategories,
) {
  final bySlug = <String, Map<String, dynamic>>{};
  for (final c in apiCategories) {
    final s = c['slug'] as String?;
    if (s != null && s.isNotEmpty) {
      bySlug[s] = c;
    }
  }

  return kHomeExploreCategoryTiles.map((tile) {
    final fromApi = bySlug[tile.slug];
    if (fromApi != null && fromApi['isActive'] != false) {
      return Map<String, dynamic>.from(fromApi);
    }
    return <String, dynamic>{
      'slug': tile.slug,
      'name': tile.defaultName,
      'icon': tile.iconName,
      'isActive': true,
      'sortOrder': 0,
      '_homeNav': tile.nav.name,
    };
  }).toList();
}
