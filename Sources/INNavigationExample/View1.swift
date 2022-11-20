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
			.padding(.top, 50)
		}
	}
}

struct View1NavBar: View {
	@EnvironmentObject var router: Router
	let navBarNamespace: Namespace.ID

	var body: some View {
		ZStack {
			Color.green
				.matchedGeometryEffect(id: "background", in: navBarNamespace)
				.opacity(0.3)

			HStack {
				Button {
					router.pop()
				} label: {
					Image(systemName: "chevron.left")
						.matchedGeometryEffect(id: "leftButtonIcon", in: navBarNamespace)
						.frame(width: 45, height: 45)
						.background(
							Color.blue.opacity(0.1)
								.matchedGeometryEffect(id: "leftButton", in: navBarNamespace)
						)
				}
				Spacer()
			}

			Text("View 1 Title")
				.matchedGeometryEffect(id: "title", in: navBarNamespace)
		}
		.frame(height: 50)
	}
}

extension Route {
	struct View1Screen: Screen {
		let id: String = UUID().uuidString
		var contentView: AnyView { AnyView(View1()) }
		func navigationBar(namespaceId: Namespace.ID) -> AnyView? { AnyView(View1NavBar(navBarNamespace: namespaceId)) }
	}

	static var view1: Route { Route(View1Screen()) }
}
