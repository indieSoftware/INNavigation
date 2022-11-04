import SwiftUI

public protocol Screen: Sendable {
	var id: String { get }

	@MainActor
	var contentView: AnyView { get }

	@MainActor
	func navigationBar(namespaceId: Namespace.ID) -> AnyView?
}
