import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

/// An animated shimmer placeholder for content that is still loading. Compose
/// several to mimic the shape of the real layout.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    this.width,
    this.height = AppSpacing.md,
    this.borderRadius = const BorderRadius.all(AppRadii.md),
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = (_controller.value * 4) - 2;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(dx - 1, 0),
              end: Alignment(dx + 1, 0),
              colors: [
                context.colors.surfaceRaised,
                context.colors.surface,
                context.colors.surfaceRaised,
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}
