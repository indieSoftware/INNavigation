import SwiftUI

public struct NavigationBar: View {
	public let content: AnyView
	let id: UUID = .init()

	public var body: some View {
		content
	}

	public static var none: NavigationBar { NavigationBar(content: AnyView(EmptyView())) }
}

extension NavigationBar: Equatable {
	public static func == (lhs: NavigationBar, rhs: NavigationBar) -> Bool {
		lhs.id == rhs.id
	}
}

struct NavigationBarKey: PreferenceKey {
	static var defaultValue: [NavigationBar] = []

	static func reduce(value: inout [NavigationBar], nextValue: () -> [NavigationBar]) {
		value.append(contentsOf: nextValue())
	}
}

public extension View {
	func navigationBar(_ navigationBar: NavigationBar) -> some View {
		preference(key: NavigationBarKey.self, value: [navigationBar])
	}

	func navigationBar(@ViewBuilder _ content: @escaping () -> some View) -> some View {
		preference(key: NavigationBarKey.self, value: [NavigationBar(content: AnyView(content()))])
	}
}
