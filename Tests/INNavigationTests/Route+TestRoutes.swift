import INNavigation
import SwiftUI

extension Route {
	struct TestRoute: Screen {
		let id: String
		var contentView: AnyView { AnyView(EmptyView()) }
		func navigationBar(namespaceId _: Namespace.ID) -> AnyView? { nil }
	}

	static var testRoute1: Route { Route(TestRoute(id: "Route1")) }
	static var testRoute2: Route { Route(TestRoute(id: "Route2")) }
	static var testRoute3: Route { Route(TestRoute(id: "Route3")) }
}
