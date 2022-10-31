import SwiftUI

public protocol Screen: Sendable {
	var id: String { get }

	var showCustomNavigationBar: Bool { get }

	@MainActor
	var contentView: AnyView { get }

	@MainActor
	var navigationBar: AnyView { get }
}

public extension Screen {
	var id: String { String(describing: Self.self) }
}
