import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Loads a network flyer URL or an [assets/] path consistently for event UIs.
class EventFlyerImage extends StatelessWidget {
  const EventFlyerImage({
    super.key,
    required this.flyer,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.expandToParent = false,
    this.placeholderColor,
    this.errorIconColor,
    this.indicatorColor,
  });

  final String flyer;
  final double? height;
  final double? width;
  final BoxFit fit;
  /// When true, wraps the flyer in [SizedBox.expand] (use inside sliver/stack hero areas).
  final bool expandToParent;
  final Color? placeholderColor;
  final Color? errorIconColor;
  final Color? indicatorColor;

  bool get _isAsset => flyer.startsWith('assets/');

  Widget _placeholder(BuildContext context) {
    final ph = placeholderColor ?? Theme.of(context).dividerColor;
    final ih =
        errorIconColor ?? Theme.of(context).iconTheme.color?.withOpacity(0.54);
    return Container(
      height: height,
      width: width,
      color: ph,
      alignment: Alignment.center,
      child: Icon(Icons.event, size: 52, color: ih),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flyer.isEmpty) {
      final Widget p = _placeholder(context);
      return expandToParent ? SizedBox.expand(child: p) : p;
    }

    Widget core;
    if (_isAsset) {
      core = Image.asset(
        flyer,
        height: expandToParent ? null : height,
        width: expandToParent ? null : width,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    } else if (expandToParent) {
      core = CachedNetworkImage(
        imageUrl: flyer,
        fit: fit,
        placeholder:
            (_, __) => Container(
              color:
                  placeholderColor ?? Theme.of(context).dividerColor,
              alignment: Alignment.center,
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color:
                      indicatorColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        errorWidget:
            (_, __, ___) => Icon(Icons.event,
                size: 52,
                color:
                    errorIconColor ?? Theme.of(context).iconTheme.color),
      );
    } else {
      core = CachedNetworkImage(
        imageUrl: flyer,
        height: height,
        width: width,
        fit: fit,
        placeholder: (_, __) => Container(
          height: height,
          width: width,
          color: placeholderColor ?? Theme.of(context).dividerColor,
          alignment: Alignment.center,
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color:
                  indicatorColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        errorWidget:
            (_, __, ___) => Container(
              height: height,
              width: width,
              color:
                  placeholderColor ?? Theme.of(context).dividerColor,
              alignment: Alignment.center,
              child: Icon(Icons.event,
                  size: 52,
                  color:
                      errorIconColor ??
                      Theme.of(context).iconTheme.color),
            ),
      );
    }

    if (expandToParent) {
      core = SizedBox.expand(child: core);
    }
    return core;
  }
}
