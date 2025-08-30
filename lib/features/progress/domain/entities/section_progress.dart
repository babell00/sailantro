class SectionProgress {
  final String sectionId;
  final int completedChallenges;
  final int totalChallenges;

  const SectionProgress({
    required this.sectionId,
    required this.completedChallenges,
    required this.totalChallenges,
  });

  double get percent =>
      totalChallenges == 0 ? 0.0 : completedChallenges / totalChallenges;
}
