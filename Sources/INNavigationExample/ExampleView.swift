import INNavigation
import SwiftUI

struct ExampleView: View {
	@EnvironmentObject var router: Router<ExampleRoute>
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
						Task {
							await router.multiPopToRoot()
						}
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
						router.present(.exampleView(title: "Presented sheet"), type: .sheet)
					} label: {
						Text("Present sheet")
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
						router.consecutiveSteps { router in
							router.pop()
							await RouterSleep.horizontal.sleep()
							router.present(.exampleView(title: "Presented"))
							await RouterSleep.vertical.sleep()
							router.push(.exampleView(title: "Pushed"))
						}
					} label: {
						Text("Pop, present, push")
					}

					Button {
						Task {
							await router.dismissToRootAndPresent(.exampleView(title: "Complex presented"), type: .sheet)
						}
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
