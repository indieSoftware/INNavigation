import SwiftUI

/// Defines a screen representable for a navigation route.
public protocol Screen: Sendable {
	/// A unique identifier to distinct this screen from another.
	/// Usually `UUID().uuidString` is enough to be returned.
	var id: String { get }

	/// Returns the screen's content view wrapped by an `AnyView`.
	@MainActor
	var contentView: AnyView { get }

	/// Returns a screen's overlay view which will be presented above the content and the navigation bar hiding both.
	/// When nil is returned then no overlay will be shown.
	@MainActor
	func overlayView() -> AnyView?

	/// Returns the custom navigation bar wrapped by an `AnyView`.
	///
	/// - parameter namespaceId: A namespace which will be provided by the navigation system
	/// and which can be used by a custom navigation bar to link sub-views together for a better
	/// transition animation via `matchedGeometryEffect`.
	/// - returns: The custom navigation bar.
	/// When a view is returned then the system navigation bar will be hidden.
	/// Returns `nil` if no custom navigation bar should be used, but the system's one.
	@MainActor
	func navigationBar(namespaceId: Namespace.ID) -> AnyView?
}

public extension Screen {
	func overlayView() -> AnyView? {
		// Makes this function being optional to impelent.
		nil
	}

	func navigationBar(namespaceId _: Namespace.ID) -> AnyView? {
		// Makes this function being optional to impelent.
		nil
	}
}
