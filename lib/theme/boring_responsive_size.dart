class BoringBreakpoint {
  static double xs = 0.0;
  static double sm = 640.0;
  static double md = 768.0;
  static double lg = 1024.0;
  static double xl = 1280.0;
}

class BoringResponsiveSize {
  const BoringResponsiveSize({int? lg, int? sm, int? md, int? xl, int? xs})
      : _xs = xs,
        _sm = sm,
        _md = md,
        _lg = lg,
        _xl = xl;
  final int? _xs;
  final int? _sm;
  final int? _md;
  final int? _lg;
  final int? _xl;

  int get xs => _xs ?? 12;

  int get sm => _sm ?? xs;

  int get md => _md ?? sm;

  int get lg => _lg ?? md;

  int get xl => _xl ?? lg;

  int breakpointValue(double width) {
    if (width < BoringBreakpoint.md) {
      //can be sm, or xs
      if (width < BoringBreakpoint.sm) {
        return xs;
      } else {
        return sm;
      }
    } else {
      //can be md, lg or xl
      if (width < lg) {
        return md;
      } else {
        if (width < xl) {
          return lg;
        } else {
          return xl;
        }
      }
    }
  }
}
