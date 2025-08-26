import 'dart:math' as math;

class PathLayout {
  /// Horizontal offset in pixels for a given index.
  /// Use a GLOBAL index (kept across sections) for a continuous wave.
  static double dx({
    required int index,
    double amplitude = 100.0,         // curve width
    double stepRads = math.pi / 2,    // center→right→center→left…
    double phase = -math.pi / 2,      // start a bit left of center
  }) {
    return amplitude * math.sin(phase + index * stepRads);
  }
}
