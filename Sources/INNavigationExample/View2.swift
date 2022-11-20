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
	@EnvironmentObject var router: Router
	let navBarNamespace: Namespace.ID

	var body: some View {
		ZStack {
			Color.orange
				.matchedGeometryEffect(id: "background", in: navBarNamespace)
				.opacity(0.3)

			VStack(spacing: .zero) {
				HStack {
					Button {
						router.pop()
					} label: {
						Image(systemName: "chevron.left")
							.matchedGeometryEffect(id: "leftButtonIcon", in: navBarNamespace)
							.frame(width: 60, height: 60)
							.background(
								Color.red.opacity(0.1)
									.matchedGeometryEffect(id: "leftButton", in: navBarNamespace)
							)
					}
					Spacer()
				}
			}

			VStack {
				Text("View 2 Title")
				Text("Subtitle").font(.caption)
			}
			.matchedGeometryEffect(id: "title", in: navBarNamespace)
		}
		.frame(height: 90)
	}
}

extension Route {
	struct View2Screen: Screen {
		let id: String = UUID().uuidString
		var contentView: AnyView { AnyView(View2()) }
		func navigationBar(namespaceId: Namespace.ID) -> AnyView? { AnyView(View2NavBar(navBarNamespace: namespaceId)) }
	}

	static var view2: Route { Route(View2Screen()) }
}
