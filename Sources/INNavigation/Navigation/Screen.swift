import SwiftUI

public protocol Screen: Sendable {
	var id: String { get }

	@MainActor
	var contentView: AnyView { get }

	@MainActor
	func navigationBar(namespaceId: Namespace.ID) -> AnyView

	var hideSystemNavigationBar: Bool { get }
//	var height: Double { get }
}

public extension AnyView {
	/// A clear color with no height embedded into an `AnyView`.
	/// Suitable for passing as the result of a custom nav bar for the `Screen` protocol
	/// to indicate that no custom nav bar should be used..
	static let noNavBar = AnyView(Color.clear.frame(height: .zero))
}
