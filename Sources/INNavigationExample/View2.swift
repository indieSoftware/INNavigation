import INNavigation
import SwiftUI

struct View2: View {
	@EnvironmentObject var router: Router

	var body: some View {
		ZStack {
			Color.indigo.opacity(0.1)
				.ignoresSafeArea()

			VStack(spacing: 20) {
				Text("View 2")

				Button {
					router.push(.view1)
				} label: {
					Text("Push View1")
				}

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
			.padding(.top, 90)
		}
	}
}

struct View2NavBar: View {
	let navBarNamespace: Namespace.ID

	var body: some View {
		ZStack {
			Color.orange
				.matchedGeometryEffect(id: "background", in: navBarNamespace)
				.opacity(0.3)
			Text("View 2 Title")
				.matchedGeometryEffect(id: "title", in: navBarNamespace)
		}
		.frame(height: 90)
	}
}

struct View2Screen: Screen {
	let id: String = UUID().uuidString
	var contentView: AnyView { AnyView(View2()) }
	func navigationBar(namespaceId: Namespace.ID) -> AnyView { AnyView(View2NavBar(navBarNamespace: namespaceId)) }
	var height: Double { 90 }
	var hideSystemNavigationBar: Bool { true }
}

extension Route {
	static var view2: Route { Route(View2Screen()) }
}
