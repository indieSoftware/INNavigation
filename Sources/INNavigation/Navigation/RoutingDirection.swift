import INCommons

/// The different routing directions.
public enum RoutingDirection: Sendable {
	/// A horizontal step (push/pop).
	case horizontal
	/// A vertical step (present/dismiss).
	case vertical
	/// A non-specific direction which doesn't take any time (direct set).
	case none
	/// A custom value for passing a sleep duration in seconds.
	case custom(_ duration: Double)
}
