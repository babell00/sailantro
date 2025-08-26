import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:sailantro/features/home/presentation/pages/test_data.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
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

    // Keep the “current section” in sync with what’s under the pinned header
    itemPositionsListener.itemPositions.addListener(_updateCurrentSectionFromVisibleItems);
  }

  @override
  void dispose() {
    // Clean up the listener
    itemPositionsListener.itemPositions.removeListener(_updateCurrentSectionFromVisibleItems);
    super.dispose();
  }

  // Build prefix sums so the sine wave is continuous across sections
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

    int candidateIndex = 1; // first real section row (0 is spacer)
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
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () => jumpToSection(2),
            icon: const Icon(Icons.arrow_downward),
          ),
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Push list below pinned header
          Padding(
            padding: const EdgeInsets.only(
              top: _headerTopPadding + _headerHeight + 8,
            ),
            child: ScrollablePositionedList.separated(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: testData.length + 1, // +1 = top spacer
              itemBuilder: (_, index) {
                if (index == 0) {
                  return const SizedBox(height: 24);
                }
                final secIdx = index - 1;
                final section = testData[secIdx];
                final waveStartIndex = _waveStarts[secIdx]; // ← precomputed global start

                return SectionWidget(
                  section: section,
                  waveStartIndex: waveStartIndex, // chips will use waveStartIndex + i
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 24.0),
              padding: const EdgeInsets.only(
                bottom: 24.0,
                left: 16.0,
                right: 16.0,
              ),
            ),
          ),

          // Pinned “Current Section” card
          Positioned(
            top: _headerTopPadding,
            left: 16,
            right: 16,
            child: SizedBox(
              height: _headerHeight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: CurrentSectionWidget(
                  key: ValueKey(iCurrentSection),
                  section: testData[iCurrentSection],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
