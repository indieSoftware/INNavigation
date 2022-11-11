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
		case .none:
			return
		case let .custom(customDuration):
			precondition(customDuration >= 0)
			duration = customDuration
		}
		try? await Task.sleep(seconds: duration)
	}

	/// Sleeps for a given time.
	/// - parameter seconds: The time in seconds.
	public static func sleep(seconds: Double) async {
		try? await Task.sleep(seconds: seconds)
	}
}

/// These values are best guesses and might change any time with an iOS update.
/// They are used as a workaround for the lack of a callback after a transition animation has finished.
/// When these values are not correct anymore then transitions might break where screens get blank
/// or not updated.
/// This can be validated with the example app when executing multiple transitions one after each other.
public extension Double {
	/// The time of a horizontal transition (push/pop).
	static let routerTransitionDurationHorizontal: Double = 0.55
	/// The time of a vertical transition (present/dismiss).
	static let routerTransitionDurationVertical: Double = 0.50
}
