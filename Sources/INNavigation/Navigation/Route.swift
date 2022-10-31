import SwiftUI

/// A route is a represenation of a screen which can be passed
/// to navigate via a router to its corresponding view represntation.
public struct Route: Sendable {
	public let screen: Screen

	public init(_ screen: Screen) {
		self.screen = screen
	}
}

extension Route: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(screen.id)
	}
}

extension Route: Equatable {
	public static func == (lhs: Route, rhs: Route) -> Bool {
		lhs.screen.id == rhs.screen.id
	}
}

// MARK: - CustomStringConvertible

extension Route: CustomStringConvertible {
	public var description: String {
		"\(screen.id)"
	}
}
