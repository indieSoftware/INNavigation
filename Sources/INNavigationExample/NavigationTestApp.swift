import INNavigation
import SwiftUI

@main
struct NavigationTestApp: App {
	var body: some Scene {
		WindowGroup {
			RouterView()
				.environmentObject(Router(root: .exampleView(title: "Root")))

			// Replace the RouterView with a problem view from below
			// Problem1View()
		}
	}
}
