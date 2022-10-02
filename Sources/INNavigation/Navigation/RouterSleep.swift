import INCommons

/// The different times to wait for a transition animation
/// before the next step can be safely executed.
public enum RouterSleep: Double {
	/// The time of a horizontal step (push/pop).
	case horizontal = 0.55
	/// The time of a vertical step (present/dismiss).
	case vertical = 0.45

	/// Sleeps for the appropriate time.
	public func sleep() async {
		try? await Task.sleep(seconds: rawValue)
	}

	/// Sleeps for a given time.
	/// - parameter seconds: The time in seconds.
	public static func sleep(seconds: Double) async {
		try? await Task.sleep(seconds: seconds)
	}
}
