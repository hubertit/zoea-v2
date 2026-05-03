import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';

class ZoeaCardScreen extends ConsumerStatefulWidget {
  const ZoeaCardScreen({super.key});

  @override
  ConsumerState<ZoeaCardScreen> createState() => _ZoeaCardScreenState();
}

class _ZoeaCardScreenState extends ConsumerState<ZoeaCardScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.zoeaCardScreenTitle),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card,
              size: 64,
              color: context.primaryColorTheme,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              l10n.zoeaCardScreenTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.zoeaCardSubtitle,
              style: TextStyle(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
