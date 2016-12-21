part of ose;

/// State of a renderer.
enum RendererState {
  /// Stop was requested.
  StopRequested,
  /// Restart was requested.
  RestartRequested,
  /// Start was requested.
  StartRequested,
  /// Already started.
  Started,
  /// Has been stopped or hasn't been launched before.
  Stopped
}
