import INCommons

/// The different times to wait for a transition animation
/// before the next step can be safely executed.
public enum RouterSleep {
	/// A horizontal step (push/pop).
	case horizontal
	/// A vertical step (present/dismiss).
	case vertical

	/// Sleeps for the appropriate time for the corresponding step.
	public func sleep() async {
		let duration: Double
		switch self {
		case .horizontal:
			duration = .routerTransitionDurationHorizontal
		case .vertical:
			duration = .routerTransitionDurationVertical
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
