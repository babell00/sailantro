import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../domain/entities/course.dart';
import '../components/current_section_widget.dart';
import '../components/section_widget.dart';

const double _headerHeight = 35.0;
const double _headerTopPadding = 8.0;

class HomeView extends StatefulWidget {
  final Course course;
  const HomeView({super.key, required this.course});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  int iCurrentSection = 0;

  late final List<int> _waveStarts;

  @override
  void initState() {
    super.initState();
    _waveStarts = _computeWaveStarts(widget.course);
    itemPositionsListener.itemPositions.addListener(_updateCurrentSectionFromVisibleItems);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_updateCurrentSectionFromVisibleItems);
    super.dispose();
  }

  List<int> _computeWaveStarts(Course course) {
    var acc = 0;
    final starts = <int>[];
    for (final s in course.sections) {
      starts.add(acc);
      acc += s.challenges.length;
    }
    return starts;
  }

  void _updateCurrentSectionFromVisibleItems() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty || !mounted) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final headerBottomFraction = (_headerTopPadding + _headerHeight) / screenHeight;

    int candidateIndex = 1; // 0 is spacer
    for (final pos in positions) {
      if (pos.index == 0) continue;
      if (pos.itemLeadingEdge <= headerBottomFraction) {
        candidateIndex = pos.index;
      }
    }
    final newSection = (candidateIndex - 1).clamp(0, widget.course.sections.length - 1);
    if (newSection != iCurrentSection) {
      setState(() => iCurrentSection = newSection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScene(
      headerTopPadding: _headerTopPadding,
      headerHeight: _headerHeight,
      backgroundAsset: 'assets/lottie/water.json',
      header: CurrentSectionWidget(
        courseName: widget.course.name,
        section: widget.course.sections[iCurrentSection],
      ),
      content: HomeContentList(
        headerHeight: _headerHeight,
        headerTopPadding: _headerTopPadding,
        sectionCount: widget.course.sections.length,
        buildItem: (secIdx) => SectionWidget(
          section: widget.course.sections[secIdx],
          waveStartIndex: _waveStarts[secIdx],
        ),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
      ),
    );
  }
}

/* ========================= SUB-WIDGETS ========================= */

class HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onJumpToExample;
  final VoidCallback onLogout;
  const HomeTopBar({super.key, required this.onJumpToExample, required this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Home Page"),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      actions: [
        IconButton(onPressed: onJumpToExample, icon: const Icon(Icons.arrow_downward)),
        IconButton(onPressed: onLogout, icon: const Icon(Icons.logout)),
      ],
    );
  }
}

class HomeBackground extends StatelessWidget {
  final String asset;
  final double blurSigma;
  final double opacity;

  const HomeBackground({
    super.key,
    required this.asset,
    this.blurSigma = 8,
    this.opacity = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Opacity(
            opacity:  opacity,
            child: Semantics(
              label: 'Animated sailing water background',
              child: Lottie.asset(
                asset,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                repeat: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef SectionItemBuilder = Widget Function(int sectionIndex);

class HomeContentList extends StatelessWidget {
  final double headerHeight;
  final double headerTopPadding;
  final int sectionCount;
  final SectionItemBuilder buildItem;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const HomeContentList({
    super.key,
    required this.headerHeight,
    required this.headerTopPadding,
    required this.sectionCount,
    required this.buildItem,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: headerTopPadding + headerHeight + 8),
      child: ScrollablePositionedList.separated(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: sectionCount + 1,
        itemBuilder: (_, index) {
          if (index == 0) return const SizedBox(height: 24);
          final secIdx = index - 1;
          return buildItem(secIdx);
        },
        separatorBuilder: (_, _) => const SizedBox(height: 8.0),
        padding: const EdgeInsets.only(bottom: 360.0, left: 16.0, right: 16.0),
      ),
    );
  }
}

class HomePinnedHeader extends StatelessWidget {
  final double headerTopPadding;
  final Widget child;
  const HomePinnedHeader({
    super.key,

    required this.headerTopPadding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: headerTopPadding,
      left: 4,
      right: 4,
      child: SizedBox(child: child),
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svg/lighthouse.svg', width: 32, height: 32),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svg/helm.svg', width: 32, height: 32),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svg/trophy.svg', width: 32, height: 32),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svg/treasure.svg', width: 32, height: 32),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svg/pirate.svg', width: 32, height: 32),
          label: '',
        ),
      ],
    );
  }
}
class HomeScene extends StatelessWidget {
  final double headerTopPadding;
  final double headerHeight;
  final String backgroundAsset;
  final Widget header;
  final Widget content;

  const HomeScene({
    super.key,
    required this.headerTopPadding,
    required this.headerHeight,
    required this.backgroundAsset,
    required this.header,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // HomeBackground(asset: backgroundAsset, blurSigma: 9, opacity: 0.35),
          Padding(
            padding: EdgeInsets.only(top: headerTopPadding + headerHeight + 8),
            child: content,
          ),
          HomePinnedHeader(headerTopPadding: headerTopPadding, child: header),
        ],
      ),
    );
  }
}
