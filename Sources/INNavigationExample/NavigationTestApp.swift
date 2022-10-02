import INNavigation
import SwiftUI

@main
struct NavigationTestApp: App {
	var body: some Scene {
		WindowGroup {
			RouterView<ExampleRoute>()
				.environmentObject(Router<ExampleRoute>(root: .exampleView(title: "Root")))
		}
	}
}
