import SwiftUI

/// The root view which wrapps a `NavigationStack` and a vertical navigation modifier
/// to make it possible to navigate horizontally and vertically from this.
public struct RouterView: View {
	/// The router which provides the paths for the navigation stack.
	@EnvironmentObject private var router: Router

	/// The namespace for the custom nav bar's geometry effect.
	/// Passed to the nav bar so that sub-views can sync their
	/// animation geometry properly during transition.
	@Namespace private var navigationBarNamespace

	/// A constant used as the geometry effect key for the navigation bar root view.
	private let navigationBarGeometryEffectRootKey = "navigationBarGeometryEffectRootKey"

	/// The vertical index of this path.
	/// Zero means this is the root path and any number above represents the number
	/// of modal views this view is on top of the root path.
	private let index: Int

	/// Initializes a new root router view which handles any transitions via the router.
	public init() {
		index = 0
	}

	/// Initializes a new view when creating a new vertical path with this new view as its root.
	/// - parameter index: The vertical index of this path.
	/// Has to be 1 or higher, because 0 would be the root path and everything
	/// higher is the presented from this root path.
	nonisolated init(index: Int) {
		precondition(index > 0)
		self.index = index
	}

	public var body: some View {
		// The custom navigation bar is shown on top of the content view.
		// Using the safeAreaInset would be better, but as of iOS 16.1 (Swift 5.7.1)
		// this approach doesn't work when embedding the content inside of a NavigationStack.
		// See also Problem1View show-casing this problem.
		ZStack {
			// Only show something if the path is valid.
			if index < router.paths.count {
				let path = $router.paths[index]
				// Embed the content view in a navigation stack.
				NavigationStack(path: path.routes) {
					let rootRoute = path.wrappedValue.root
					// The content view.
					rootRoute.screen.contentView
						// Show or hide the system nav bar for the root screen.
						.navigationBarHidden(rootRoute.screen.navigationBar(namespaceId: navigationBarNamespace) != nil)
						// Add horizontal navigation possibility.
						.navigationDestination(for: Route.self) { route in
							let screen = route.screen
							screen.contentView
								// Show or hide the system nav bar depending of the current screen.
								.navigationBarHidden(screen.navigationBar(namespaceId: navigationBarNamespace) != nil)
								// Inject the router dependency to the view hierarchy.
								.environmentObject(router)
						}
						// Add vertical navigation possibility.
						// The binding is responsible to show or hide the next vertical path.
						.verticalNavigation(binding: router.verticalBinding(index: index + 1))
						// Inject the router dependency to the view hierarchy.
						.environmentObject(router)
				}

				// Needs to be saved locally here to prevent animation glitches.
				let lastRoute = path.wrappedValue.routes.last ?? path.wrappedValue.root

				// Add the nav bar over the content view.
				VStack(spacing: .zero) {
					// Get the current visible route representation.
					// Wrap the nav bar in an additional stack which
					// helps animating the clipping bounds.
					VStack(spacing: .zero) {
						// Create the custom nav bar with the namespace passed so that each
						// nav bar can match the animation for sub-views.

						lastRoute.screen.navigationBar(namespaceId: navigationBarNamespace)
							?? AnyView(Color.clear.frame(height: .zero))

						Spacer()
					}

					// Push the nav bar at the top of the screen.
					Spacer()
				}
				// Inject the router dependency to the navigation bar.
				.environmentObject(router)
				// Mark each custom nav bar as an individual one for SwiftUI,
				// necessary for the geometry effect to distinct the custom nav bars.
				.id(lastRoute)
				// Match each custom nav bar with the next one so that even
				// custom nav bars which are not using the namespace animate somehow.
				.matchedGeometryEffect(id: navigationBarGeometryEffectRootKey, in: navigationBarNamespace)
				// Animate the nav bar transition at all during the screen transition.
				.animation(.easeOut, value: lastRoute)

				// Add an overlay view on top of all other content.
				lastRoute.screen.overlayView()
			}
		}
	}
}
