import INNavigation
import SwiftUI

@main
struct INNavigationExample: App {
	static let router = Router(root: .exampleView(title: "Root"))

	var body: some Scene {
		WindowGroup {
			RouterView()
				.environmentObject(Self.router)

			// Replace the RouterView with a problem view from below
			// Problem1View()
		}
	}
}
