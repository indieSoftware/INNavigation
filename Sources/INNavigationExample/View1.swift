import INNavigation
import SwiftUI

struct View1: View {
	@EnvironmentObject var router: Router

	var body: some View {
		ZStack {
			Color.cyan.opacity(0.1)
			VStack(spacing: 20) {
				Text("View 1")

				Button {
					router.push(.view2)
				} label: {
					Text("Push View2")
				}

				Button {
					router.pop()
				} label: {
					Text("Pop")
				}

				Spacer()
			}
			.padding(.top, 50)
		}
	}
}

struct View1NavBar: View {
	let navBarNamespace: Namespace.ID

	var body: some View {
		ZStack {
			Color.green
				.matchedGeometryEffect(id: "background", in: navBarNamespace)
				.opacity(0.3)
			Text("View 1 Title")
				.matchedGeometryEffect(id: "title", in: navBarNamespace)
		}
		.frame(height: 50)
	}
}

struct View1Screen: Screen {
	var contentView: AnyView { AnyView(View1()) }
	func navigationBar(namespaceId: Namespace.ID) -> AnyView { AnyView(View1NavBar(navBarNamespace: namespaceId)) }
	var height: Double { 50 }
	var hideSystemNavigationBar: Bool { true }
}

extension Route {
	static var view1: Route { Route(View1Screen()) }
}