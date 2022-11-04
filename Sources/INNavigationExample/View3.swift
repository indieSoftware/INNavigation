import INNavigation
import SwiftUI

struct View3: View {
	@State private var isExpanded = false
	@Namespace private var namespace // <1>

	var body: some View {
		Group {
			if isExpanded {
				VStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(Color.pink)
						.frame(width: 60, height: 60)
						.matchedGeometryEffect(id: "rect", in: namespace) // <2>
					// SubView3()
					SubView2()
//					Text("Hello SwiftUI!").fontWeight(.semibold)
						.matchedGeometryEffect(id: "text", in: namespace) // <3>
				}
			} else {
				HStack {
					SubView3()
						// Text("Hello SwiftUI!").fontWeight(.semibold)
						.matchedGeometryEffect(id: "text", in: namespace) // <4>
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(Color.pink)
						.frame(width: 60, height: 60)
						.matchedGeometryEffect(id: "rect", in: namespace) // <5>
				}
			}
		}.onTapGesture {
			withAnimation {
				isExpanded.toggle()
			}
		}
	}
}

struct SubView2: View {
	var body: some View {
		HStack {
			Text("Foo!").fontWeight(.semibold)
				.background(Color.blue)
		}
	}
}

struct SubView3: View {
	var body: some View {
		ZStack {
//			Color.green.frame(size: CGSize(width: 100, height: 50))
			VStack {
				Text("Hello SwiftUI!").fontWeight(.semibold)
				Text("Hello SwiftUI!").fontWeight(.semibold)
			}
			.background(Color.green)
		}
	}
}

struct View3Screen: Screen {
	let id: String = UUID().uuidString
	var contentView: AnyView { AnyView(View3()) }
	func navigationBar(namespaceId _: Namespace.ID) -> AnyView { .noNavBar }
	var height: Double { 0 }
	var hideSystemNavigationBar: Bool { false }
}

extension Route {
	static var view3: Route { Route(View3Screen()) }
}
