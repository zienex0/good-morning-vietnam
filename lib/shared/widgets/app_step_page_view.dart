import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppStepPageView extends StatefulWidget {
  const AppStepPageView({
    required this.titles,
    required this.pagesSlivers,
    this.leading,
    this.actions = const [],
    this.bottomNavigationBar,
    this.physics,
    this.pageScrollPhysics = const [],
    this.onPageChanged,
    this.initialPage = 0,
    super.key,
  }) : assert(
         titles.length == pagesSlivers.length,
         'The amount of titles must exactly match the amount of pages.',
       ),
       assert(
         pageScrollPhysics.length == 0 ||
             pageScrollPhysics.length == pagesSlivers.length,
         'Page scroll physics must be empty or match the amount of pages.',
       );

  final List<Widget> titles;

  final List<List<Widget>> pagesSlivers;

  final Widget? leading;
  final List<Widget> actions;

  final Widget? bottomNavigationBar;

  final ScrollPhysics? physics;

  final List<ScrollPhysics?> pageScrollPhysics;

  final ValueChanged<int>? onPageChanged;

  final int initialPage;

  @override
  State<AppStepPageView> createState() => AppStepPageViewState();
}

class AppStepPageViewState extends State<AppStepPageView> {
  late final PageController _pageController;
  late int _currentIndex;

  int get currentIndex => _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> incrementPageIndex() async {
    if (_currentIndex < widget.pagesSlivers.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> decrementPageIndex() async {
    if (_currentIndex > 0) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onPageChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.titles.isEmpty
        ? 0.0
        : (_currentIndex + 1) / widget.titles.length;

    final currentTitle =
        widget.titles.isNotEmpty && _currentIndex < widget.titles.length
        ? widget.titles[_currentIndex]
        : const SizedBox.shrink();

    final bottomContentPadding =
        MediaQuery.viewPaddingOf(context).bottom +
        AppSpacing.xl +
        (widget.bottomNavigationBar == null ? AppSpacing.none : AppSpacing.xl);

    final appBarLeading = widget.leading == null
        ? null
        : Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.page),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: widget.leading,
            ),
          );

    final appBarActions = widget.actions.isEmpty
        ? widget.actions
        : [
            ...widget.actions.take(widget.actions.length - 1),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.page),
              child: widget.actions.last,
            ),
          ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        bottomNavigationBar: widget.bottomNavigationBar,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0.1,
          shadowColor: Theme.of(context).dividerColor,
          backgroundColor: context.colors.surface,
          surfaceTintColor: Colors.transparent,
          foregroundColor: context.colors.textPrimary,
          centerTitle: false,

          leading: appBarLeading,
          leadingWidth: widget.leading == null
              ? null
              : AppSpacing.page + AppSizes.controlMd,
          actions: appBarActions,

          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: SizedBox(
              key: ValueKey<int>(_currentIndex),
              width: double.infinity,
              child: currentTitle,
            ),
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSpacing.xs),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress),
              duration: const Duration(milliseconds: 300),
              builder: (_, value, child) => LinearProgressIndicator(
                value: value,
                minHeight: AppSpacing.xs,
              ),
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: _handlePageChanged,
          physics: widget.physics,
          itemCount: widget.pagesSlivers.length,
          itemBuilder: (context, index) {
            final pageSlivers = widget.pagesSlivers[index];
            return CustomScrollView(
              physics: widget.pageScrollPhysics.isEmpty
                  ? null
                  : widget.pageScrollPhysics[index],
              slivers: [
                ...pageSlivers,
                if (pageSlivers.isEmpty ||
                    (pageSlivers.last is! SliverFillRemaining &&
                        pageSlivers.last is! SliverMainAxisGroup))
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: bottomContentPadding),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
