import SwiftUI

/// A route is a represenation of a screen which can be passed
/// to navigate via a router to its corresponding view represntation.
public struct Route: Sendable {
	/// The screen representable for this route.
	public let screen: Screen

	/// Initializes a route.
	///
	/// - parameter screen: The screen representable to which this route points to.
	public init(_ screen: Screen) {
		self.screen = screen
	}
}

/// Necessary for passing to `NavigationStack`, etc.
extension Route: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(screen.id)
	}
}

/// Necessary for passing to `NavigationStack`, etc.
extension Route: Equatable {
	public static func == (lhs: Route, rhs: Route) -> Bool {
		lhs.screen.id == rhs.screen.id
	}
}

// MARK: - CustomStringConvertible

/// Only for debugging.
extension Route: CustomStringConvertible {
	public var description: String {
		"\(screen.id)"
	}
}
