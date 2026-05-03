import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/listings_provider.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/widgets/fade_in_image.dart' show FadeInNetworkImage;
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/category_localization.dart';

class NearMeListScreen extends ConsumerWidget {
  const NearMeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync =
        ref.watch(randomListingsProvider(kRandomNearMeFullListLimit));

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: () => context.pop(),
          color: context.primaryTextColor,
        ),
        title: Text(
          AppLocalizations.of(context)!.exploreNearMe,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
      ),
      body: nearbyAsync.when(
        data: (listings) {
          if (listings.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.exploreNoListings,
                style: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            );
          }
          return RefreshIndicator(
            color: context.primaryColorTheme,
            backgroundColor: context.cardColor,
            onRefresh: () async {
              ref.invalidate(randomListingsProvider(kRandomNearMeFullListLimit));
              await Future<void>.delayed(const Duration(milliseconds: 400));
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                return _NearMeCard(listing: listings[index]);
              },
            ),
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          itemCount: 6,
          itemBuilder: (context, index) => const _NearMeSkeletonCard(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load listings',
                  style: context.bodyLarge.copyWith(color: context.errorColor),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    ref.invalidate(randomListingsProvider(kRandomNearMeFullListLimit));
                  },
                  child: Text(AppLocalizations.of(context)!.commonRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NearMeCard extends StatelessWidget {
  const _NearMeCard({required this.listing});

  final Map<String, dynamic> listing;

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (listing['images'] != null &&
        listing['images'] is List &&
        (listing['images'] as List).isNotEmpty) {
      final firstImage = (listing['images'] as List).first;
      if (firstImage is Map && firstImage['media'] != null) {
        imageUrl = firstImage['media']['url'] ??
            firstImage['media']['thumbnailUrl'];
      }
    }

    final name = listing['name'] ?? 'Unknown';
    final address = listing['address'] ?? listing['city']?['name'] ?? '';
    final catRaw = listing['category'];
    late final String category;
    if (catRaw is Map<String, dynamic>) {
      final locCat =
          localizedCategoryName(catRaw, Localizations.localeOf(context)).trim();
      category = locCat.isNotEmpty ? locCat : (listing['type'] ?? 'Place');
    } else {
      category = listing['type'] ?? 'Place';
    }
    final id = listing['id'] ?? '';

    return GestureDetector(
      onTap: () => context.push('/listing/$id'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
              child: imageUrl != null
                  ? FadeInNetworkImage(
                      imageUrl: imageUrl,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12)),
                      errorWidget: Container(
                        height: 80,
                        width: 80,
                        color: context.dividerColor,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      height: 80,
                      width: 80,
                      color: context.dividerColor,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: context.secondaryTextColor,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            address,
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.primaryColorTheme.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: context.labelSmall.copyWith(
                              color: context.primaryColorTheme,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearMeSkeletonCard extends StatelessWidget {
  const _NearMeSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.grey300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            color: context.grey400,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: context.grey400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: context.grey400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
