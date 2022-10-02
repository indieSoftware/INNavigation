import SwiftUI

/// The root view which wrapps a `NavigationStack` and a vertical navigation modifier
/// to make it possible to navigate horizontally and vertically from this.
public struct RouterView<RouterType: Route>: View {
	/// The router which provides the paths for the navigation stack.
	@EnvironmentObject private var router: Router<RouterType>

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
		if index < router.paths.count {
			NavigationStack(path: $router.paths[index].routes) {
				router.paths[index].root.view
					// Add horizontal navigation possibility.
					.navigationDestination(for: RouterType.self) { route in
						route.view
							.environmentObject(router)
					}
					// Add vertical navigation possibility.
					// The binding is responsible to show or hide the next vertical path.
					.verticalNavigation(for: RouterType.self, binding: router.verticalBinding(index: index + 1))
					// Inject the router dependency to the view hierarchy.
					.environmentObject(router)
			}
		}
	}
}
