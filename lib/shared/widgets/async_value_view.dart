import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    this.preservePreviousData = true,
    this.loading,
    this.error,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T value) data;
  final VoidCallback? onRetry;
  final bool preservePreviousData;
  final WidgetBuilder? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;

  @override
  Widget build(BuildContext context) {
    final previousValue = value.valueOrNull;

    if (preservePreviousData && previousValue != null) {
      return Stack(
        children: [
          data(previousValue),
          if (value.isLoading) const _AsyncLoadingOverlay(),
          if (value.hasError && !value.isLoading)
            _AsyncErrorBanner(
              error: value.error!,
              onRetry: onRetry,
            ),
        ],
      );
    }

    return value.when(
      data: data,
      loading: () => loading?.call(context) ?? const _AsyncLoadingState(),
      error: (error, stackTrace) {
        return this.error?.call(error, stackTrace) ??
            _AsyncErrorState(error: error, onRetry: onRetry);
      },
    );
  }
}

class _AsyncLoadingState extends StatelessWidget {
  const _AsyncLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _AsyncLoadingOverlay extends StatelessWidget {
  const _AsyncLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: AppSpacing.none,
      left: AppSpacing.none,
      right: AppSpacing.none,
      child: LinearProgressIndicator(minHeight: AppSpacing.xs),
    );
  }
}

class _AsyncErrorState extends StatelessWidget {
  const _AsyncErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.accent,
              size: AppSizes.avatarMd,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: context.text.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AsyncErrorBanner extends StatelessWidget {
  const _AsyncErrorBanner({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.page,
      right: AppSpacing.page,
      bottom: AppSpacing.page,
      child: Card(
        color: AppColors.textPrimary,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.onAccent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  error.toString(),
                  style: context.inverseText.bodyMedium,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(width: AppSpacing.md),
                TextButton(
                  onPressed: onRetry,
                  child: Text(context.l10n.retry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
