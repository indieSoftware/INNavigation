import Foundation

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
