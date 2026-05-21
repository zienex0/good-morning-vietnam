import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

const double _sliverAppBarExpandedHeight = 152;

class AppSliverPage extends StatelessWidget {
  const AppSliverPage({
    required this.slivers,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottomNavigationBar,
    this.includeScaffold = true,
    this.leadingWidth,
    super.key,
  }) : assert(
         includeScaffold || bottomNavigationBar == null,
         'bottomNavigationBar requires includeScaffold to be true.',
       );

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final List<Widget> slivers;
  final Widget? bottomNavigationBar;
  final bool includeScaffold;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null || subtitle != null;
    final bottomContentPadding =
        MediaQuery.viewPaddingOf(context).bottom +
        AppSpacing.xl +
        (bottomNavigationBar == null ? AppSpacing.none : AppSpacing.xl);
    final appBarLeading = leading == null
        ? null
        : Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.page),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: leading,
            ),
          );
    final appBarActions = actions.isEmpty
        ? actions
        : [
            ...actions.take(actions.length - 1),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.page),
              child: actions.last,
            ),
          ];

    final content = CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: AppSpacing.xxxl + AppSpacing.xl,

          elevation: 0,
          scrolledUnderElevation: 0.1,
          shadowColor: Theme.of(context).dividerColor,
          leading: appBarLeading,
          leadingWidth: leading == null
              ? leadingWidth
              : leadingWidth ?? AppSpacing.page + AppSizes.controlMd,
          actions: appBarActions,
          expandedHeight: _sliverAppBarExpandedHeight,

          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,

          foregroundColor: AppColors.textPrimary,
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsetsDirectional.only(
              start: leading == null
                  ? AppSpacing.page
                  : AppSpacing.page + AppSizes.controlMd + AppSpacing.md,
              end: AppSpacing.page,
              bottom: AppSpacing.md,
            ),
            title: hasTitle
                ? _SliverTitle(title: title, subtitle: subtitle)
                : null,
            background: const ColoredBox(color: AppColors.canvas),
          ),
        ),
        ...slivers,
        SliverPadding(padding: EdgeInsets.only(bottom: bottomContentPadding)),
      ],
    );

    if (!includeScaffold) {
      return content;
    }

    return Scaffold(bottomNavigationBar: bottomNavigationBar, body: content);
  }
}

class _SliverTitle extends StatelessWidget {
  const _SliverTitle({this.title, this.subtitle});

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.titleStrong,
          ),
        if (subtitle != null) ...[
          if (title != null) const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.mutedText.bodySmall,
          ),
        ],
      ],
    );
  }
}
