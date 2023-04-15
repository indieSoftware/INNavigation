import Foundation

/// Represents a sequence of horizontally shown views,
/// meaning they are pushed on a navigation stack.
struct HorizontalPath {
	/// The routes representing the screens shown in a navigation stack.
	/// This array contains all horizontal follow-up routes after the root,
	/// meaning when this array is empty then only the root is shown
	/// and adding a route to this array results in pushing a new view
	/// onto the navigation stack.
	/// This acts as the `NavigationStack`'s path.
	var routes: [Route] = []

	/// The root route representing the intial screen of each horizontal path.
	let root: Route

	/// The vertical navigation type of the whole horizontal path.
	/// That means the first view with the navigation stack will be shown
	/// modally in a sheet or full-screen which will reflected by this property.
	let presentationType: PresentationType

	init(
		root: Route,
		presentationType: PresentationType
	) {
		self.root = root
		self.presentationType = presentationType
	}
}

// MARK: - CustomStringConvertible

extension HorizontalPath: CustomStringConvertible {
	var description: String {
		"\(root)-\(routes)"
	}
}
