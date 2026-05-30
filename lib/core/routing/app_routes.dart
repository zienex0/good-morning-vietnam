/// Typed route path constants for framework-backed app features.
abstract final class AppRoutes {
  static const String home = '/';
  static const String gallery = '/gallery';
  static const String details = '/details';

  /// Builds the path for the details screen for a given [id].
  static String detailsFor(String id) => '$details/$id';
}
