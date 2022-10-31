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
//			.navigationBar {
//				HStack {
//					Text("View 1 Title")
//				}
//				.frame(height: 50)
//				.background(Color.green)
//			}
		}
	}
}

struct View1Screen: Screen {
	var contentView: AnyView { AnyView(View1()) }
	var showCustomNavigationBar: Bool { true }
	var navigationBar: AnyView { AnyView(Color.green.opacity(0.3).frame(height: 50)) }
}

extension Route {
	static var view1: Route { Route(View1Screen()) }
}
