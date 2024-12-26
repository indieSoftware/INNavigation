import INNavigation
import SwiftUI

struct ExampleView: View {
	@EnvironmentObject var router: Router
	let title: String

	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				VStack {
					Button {
						router.push(.exampleView(title: "Pushed"))
					} label: {
						Text("Push")
					}

					Button {
						router.pop()
					} label: {
						Text("Pop")
					}

					Button {
						router.popToRoot()
					} label: {
						Text("Pop to root")
					}

					Button {
						router.multiPopToRoot()
					} label: {
						Text("Multi-pop to root")
					}
				}

				VStack {
					Button {
						router.present(.exampleView(title: "Presented full-screen"), type: .fullScreen)
					} label: {
						Text("Present full-screen")
					}

					Button {
						router.present(.exampleView(title: "Presented sheet"), type: .sheet(detents: [.large]))
					} label: {
						Text("Present sheet (large detents)")
					}

					Button {
						router.present(.exampleView(title: "Presented sheet"), type: .sheet(detents: [.medium]))
					} label: {
						Text("Present sheet (medium detents)")
					}

					Button {
						router.dismiss()
					} label: {
						Text("Dismiss")
					}

					Button {
						Task {
							await router.multiDismissToRoot()
						}
					} label: {
						Text("Multi-dismiss to root")
					}
				}

				VStack {
					Button {
						Task {
							await router.pop()
							await router.present(.exampleView(title: "Presented"))
							await router.push(.exampleView(title: "Pushed"))
						}
					} label: {
						Text("Pop, present, push")
					}

					Button {
						router.dismissToRootAndPresent(.exampleView(title: "Complex presented"), type: .sheet(detents: [.large]))
					} label: {
						Text("Dismiss to root and present")
					}

					Button {
						router.set(routes: .exampleView(title: "Route A"))
					} label: {
						Text("Set 1 screen")
					}

					Button {
						router.set(routes: .exampleView(title: "Route 1"), .exampleView(title: "Route 2"), .exampleView(title: "Route 3"))
					} label: {
						Text("Set 3 screens")
					}

					Button {
						router.popAfter(index: 1)
					} label: {
						Text("Pop all after index 1")
					}

					Button {
						Task {
							await router.push(.view1)
							await router.push(.view2(parameter: 0))
							await router.push(.view1)
							await router.pop()
							await router.pop()
							await router.pop()
						}
					} label: {
						Text("Test horizontal navigation animation")
					}

					Button {
						Task {
							await router.present(.view1)
							await router.present(.view2(parameter: 0))
							await router.present(.view1)
							await router.dismiss()
							await router.dismiss()
							await router.dismiss()
						}
					} label: {
						Text("Test vertical navigation animation")
					}
				}

				VStack {
					Button {
						router.push(.view1)
					} label: {
						Text("Push View1")
					}
				}

				VStack {
					Button {
						router.push(.overlayExample(viewModel: OverlayExampleViewModel()))
					} label: {
						Text("Push Overlay Example")
					}
				}

				VStack {
					Button {
						print("Router-paths: \(router.description)")
					} label: {
						Text("Print paths")
					}
				}
			}
		}
		.navigationBarTitle(Text(title))
	}
}

extension Route {
	struct ExampleViewScreen: Screen {
		let id: String = UUID().uuidString
		let title: String
		var contentView: AnyView { AnyView(ExampleView(title: title)) }
	}

	static func exampleView(title: String) -> Route { Route(ExampleViewScreen(title: title)) }
}
