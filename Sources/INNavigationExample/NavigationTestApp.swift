import INNavigation
import SwiftUI

@main
struct NavigationTestApp: App {
	var body: some Scene {
		WindowGroup {
			RouterView()
				.environmentObject(Router(root: .exampleView(title: "Root")))
		}
	}
}
