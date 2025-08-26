import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../domain/models/section_data.dart';
import '../components/current_section.dart';
import '../components/section.dart';

final testData = <SectionData>[
  SectionData(
    color: Colors.blue,
    unit: 1,
    section: 1,
    title: 'Safety equipment',
    exercise: 5,
  ),
  SectionData(
    color: Colors.orange,
    unit: 1,
    section: 2,
    title: 'Distress signals',
    exercise: 4,
  ),
  SectionData(
    color: Colors.green,
    unit: 1,
    section: 3,
    title: 'Lifejackets',
    exercise: 5,
  ),
  SectionData(
    color: Colors.purple,
    unit: 1,
    section: 4,
    title: 'Fire & extinguishers',
    exercise: 6,
  ),
  SectionData(
    color: Colors.red,
    unit: 1,
    section: 5,
    title: 'Engine checks & MOB',
    exercise: 7,
  ),
];


const double _headerHeight = 96.0;      // visual height of CurrentSection card
const double _headerTopPadding = 8.0;   // breathing room from top

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  int iCurrentSection = 0;


  @override
  void initState() {
    super.initState();
    // [ADD] listen to visible items and compute "current section"
    itemPositionsListener.itemPositions.addListener(_updateCurrentSectionFromVisibleItems);
  }

  void _updateCurrentSectionFromVisibleItems() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty || !mounted) return;

    // Screen-normalized coordinates: 0 (top) .. 1 (bottom).
    // Our pinned header occupies [_headerTopPadding, _headerTopPadding + _headerHeight] px from the top.
    // Convert that into a fraction of screen height.
    final screenHeight = MediaQuery.of(context).size.height;
    final headerBottomFraction = (_headerTopPadding + _headerHeight) / screenHeight;

    // We render list items in order: index 0 is a small spacer, then sections at [1..N].
    // We want the **last** item whose top (leadingEdge) is AT or ABOVE the header bottom.
    int candidateIndex = 1; // default to first section container
    for (final pos in positions) {
      // We only care about real section rows (skip 0 if it's our spacer)
      if (pos.index == 0) continue;

      if (pos.itemLeadingEdge <= headerBottomFraction) {
        candidateIndex = pos.index; // further down (still under header) wins
      }
    }

    // Map list index -> section index (because of the spacer at 0)
    final newSection = (candidateIndex - 1).clamp(0, testData.length - 1);
    if (newSection != iCurrentSection) {
      setState(() => iCurrentSection = newSection);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void jumpToSection(int sectionIndex) {
    // +1 because index 0 is the spacer item in the list
    itemScrollController.scrollTo(
      index: sectionIndex + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.1, // keep section’s title just below the pinned header
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              jumpToSection(2); // [EXAMPLE] Jump to Section 2 (index = 2)
            },
            icon: const Icon(Icons.arrow_downward),
          ),
          IconButton(
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              authCubit.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          // [MOD] Push list down so it doesn't go under the pinned header
          Padding(
            padding: const EdgeInsets.only(
              top: _headerTopPadding + _headerHeight + 8, // extra 8 for separation
            ),
            child: ScrollablePositionedList.separated(
              // [ADD] controllers
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,

              // [MOD] we include a leading spacer item at index 0 for cleaner top padding
              itemCount: testData.length + 1,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return const SizedBox(height: 24); // [ADD] spacer item
                }
                // [EXISTING] your Section widget
                return Section(data: testData[index - 1]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 24.0),
              padding: const EdgeInsets.only(
                bottom: 24.0,
                left: 16.0,
                right: 16.0,
              ),
            ),
          ),

          // [MOD] Pin the CurrentSection card at the top
          Positioned(
            top: _headerTopPadding,
            left: 16,
            right: 16,
            child: SizedBox(
              height: _headerHeight,
              // [ADD] small delight: animate the content swap when section changes
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: CurrentSection(
                  key: ValueKey(iCurrentSection), // ensures animation on change
                  data: testData[iCurrentSection],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}