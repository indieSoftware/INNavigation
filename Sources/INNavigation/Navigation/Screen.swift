import SwiftUI

public protocol Screen: Sendable {
	var id: String { get }

	@MainActor
	var contentView: AnyView { get }

	@MainActor
	func navigationBar(namespaceId: Namespace.ID) -> AnyView

	var hideSystemNavigationBar: Bool { get }
	var height: Double { get }
}

public extension Screen {
	var id: String { String(describing: Self.self) }
}

public extension AnyView {
	static let none = AnyView(Color.clear.frame(height: .zero))
}
