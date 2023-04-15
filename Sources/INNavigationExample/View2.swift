import INNavigation
import SwiftUI

struct View2: View {
	@EnvironmentObject var router: Router
	@ObservedObject var viewModel: ViewModel2

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
					viewModel.pushToView2()
				} label: {
					Text("Push View2")
				}

				Button {
					router.pop()
				} label: {
					Text("Pop")
				}

				Button(action: {
					viewModel.showOverlay = true
				}, label: {
					Text("Show Overlay")
				})

				Spacer()
			}
			.padding(.top, 90)
		}
	}
}

struct View2NavBar: View {
	@EnvironmentObject var router: Router
	@ObservedObject var viewModel: ViewModel2
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
				Text("Parameter: \(viewModel.parameter)").font(.caption)
			}
			.matchedGeometryEffect(id: "title", in: navBarNamespace)
		}
		.frame(height: 90)
	}
}

struct OverlayView2: View {
	@EnvironmentObject var router: Router
	@ObservedObject var viewModel: ViewModel2

	var body: some View {
		if viewModel.showOverlay {
			ZStack {
				Color.black
					.opacity(0.5)
					.edgesIgnoringSafeArea(.all)

				VStack {
					Button(action: {
						viewModel.showOverlay = false
					}, label: {
						Text("Hide Overlay")
							.padding(20)
							.background(Color.white)
					})

					Button {
						router.pop()
					} label: {
						Text("Pop back")
							.padding(20)
							.background(Color.white)
					}
				}
			}
		}
	}
}

@MainActor
class ViewModel2: ObservableObject {
	let parameter: Int
	@Published var showOverlay: Bool = false

	// Simulates the dependency injection of the router.
	private var router: Router {
		NavigationTestApp.router
	}

	init(parameter: Int) {
		self.parameter = parameter
	}

	func pushToView2() {
		router.push(.view2(parameter: parameter + 1))
	}
}

@MainActor
struct View2Screen: Screen {
	let id: String = UUID().uuidString
	let viewModel: ViewModel2

	init(parameter: Int) {
		viewModel = ViewModel2(parameter: parameter)
	}

	var contentView: AnyView { AnyView(View2(viewModel: viewModel)) }
	func navigationBar(namespaceId: Namespace.ID) -> AnyView? { AnyView(View2NavBar(viewModel: viewModel, navBarNamespace: namespaceId))
	}

	func overlayView() -> AnyView? {
		AnyView(OverlayView2(viewModel: viewModel))
	}
}

extension Route {
	@MainActor
	static func view2(parameter: Int) -> Route {
		Route(View2Screen(parameter: parameter))
	}
}
