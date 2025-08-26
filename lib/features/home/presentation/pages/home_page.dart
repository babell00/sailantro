import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:sailantro/features/home/presentation/pages/test_data.dart';
import '../components/current_section_widget.dart';
import '../components/section_widget.dart';

const double _headerHeight = 96.0;
const double _headerTopPadding = 8.0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  int iCurrentSection = 0;

  // Prefix sums of challenges per section → waveStartIndex per section
  late final List<int> _waveStarts;

  @override
  void initState() {
    super.initState();
    _waveStarts = _computeWaveStarts();
    itemPositionsListener.itemPositions.addListener(_updateCurrentSectionFromVisibleItems);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_updateCurrentSectionFromVisibleItems);
    super.dispose();
  }

  List<int> _computeWaveStarts() {
    var acc = 0;
    final starts = <int>[];
    for (final s in testData) {
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
    final newSection = (candidateIndex - 1).clamp(0, testData.length - 1);
    if (newSection != iCurrentSection) {
      setState(() => iCurrentSection = newSection);
    }
  }

  void jumpToSection(int sectionIndex) {
    itemScrollController.scrollTo(
      index: sectionIndex + 1, // +1 for spacer
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: HomeTopBar(
      //   onJumpToExample: () => jumpToSection(2),
      //   onLogout: () => context.read<AuthCubit>().logout(),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            const HomeBackground(
              asset: 'assets/lottie/water.json',
              blurSigma: 8,
              opacity: 0.25,
            ),
            HomeContentList(
              headerHeight: _headerHeight,
              headerTopPadding: _headerTopPadding,
              sectionCount: testCourse.sections.length,
              buildItem: (secIdx) => SectionWidget(
                section: testCourse.sections[secIdx],
                waveStartIndex: _waveStarts[secIdx], // chips use waveStartIndex + i
              ),
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
            ),
            HomePinnedHeader(
              headerTopPadding: _headerTopPadding,
              child: CurrentSectionWidget(courseName: testCourse.name ,section: testCourse.sections[iCurrentSection]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNav(),
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
            opacity: opacity,
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
        itemCount: sectionCount + 1, // +1 = top spacer
        itemBuilder: (_, index) {
          if (index == 0) return const SizedBox(height: 24);
          final secIdx = index - 1;
          return buildItem(secIdx);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8.0),
        padding: const EdgeInsets.only(bottom: 320.0, left: 16.0, right: 16.0),
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
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(
          0xFFC7F5F8)))),
      child: BottomNavigationBar(
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
      ),
    );
  }
}
