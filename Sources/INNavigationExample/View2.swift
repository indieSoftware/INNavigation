import INNavigation
import SwiftUI

struct View2: View {
	@EnvironmentObject var router: Router

	var body: some View {
		ZStack {
			Color.indigo.opacity(0.1)
			VStack(spacing: 20) {
				Text("View 2")

				Button {
					router.pop()
				} label: {
					Text("Pop")
				}

				Spacer()
			}
//			.navigationBar {
//				HStack {
//					Text("View 2 Title")
//				}
//				.frame(height: 90)
//				.background(Color.blue)
//			}
//			.navigationBarTitle(Text("View2"))
		}
	}
}

struct View2Screen: Screen {
	var contentView: AnyView { AnyView(View2()) }
	var showCustomNavigationBar: Bool { true }
	var navigationBar: AnyView { AnyView(Color.orange.opacity(0.3).frame(height: 90)) }
}

extension Route {
	static var view2: Route { Route(View2Screen()) }
}
