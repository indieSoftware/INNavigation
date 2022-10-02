import SwiftUI

/// A route is a represenation of a screen which can be passed
/// to navigate via a router to its corresponding view represntation.
public protocol Route: Hashable, Sendable {
	/// The type of the underlying view.
	associatedtype Body: View

	/// The view's content.
	@ViewBuilder
	@MainActor
	var view: Self.Body { get }
}
