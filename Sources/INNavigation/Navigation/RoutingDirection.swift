import INCommons

/// The different routing directions.
public enum RoutingDirection: Sendable {
	/// A horizontal step (push/pop).
	case horizontal
	/// A vertical step (present/dismiss).
	case vertical
	/// A non-specific direction which doesn't take any time (direct set).
	case nonspecific

	/// Sleeps for the appropriate time for the corresponding step.
	/// This ensures that a thread is waiting for a transition animation has been ended
	/// before the next one can be applied.
	/// If the time is not respected correctly then this can lead to screen discrepancies.
	public func sleep() async {
		let duration: Double
		switch self {
		case .horizontal:
			duration = .routerTransitionDurationHorizontal
		case .vertical:
			duration = .routerTransitionDurationVertical
		case .nonspecific:
			return
		}
		try? await Task.sleep(seconds: duration)
	}

	/// Sleeps for a given time.
	/// - parameter seconds: The time in seconds.
	public static func sleep(seconds: Double) async {
		try? await Task.sleep(seconds: seconds)
	}
}

public extension Double {
	/// The time of a horizontal transition (push/pop).
	static let routerTransitionDurationHorizontal: Double = 0.55
	/// The time of a vertical transition (present/dismiss).
	static let routerTransitionDurationVertical: Double = 0.45
}