import Combine
import SwiftUI

/// The router which provides a functional interface for the navigation between screens.
@MainActor
public class Router<RouterType: Route>: ObservableObject, Sendable {
	/// The list of horizontal paths which makes this the vertical path.
	/// Whenever a new modal screen is shown a new path is added to this list.
	/// Each path in this array represents a horizontal path which reflects the
	/// views in a navigation stack so they can be pushed and popped on each level.
	/// There is always at least one path in this list which represents the root view.
	/// When setting a new path then there must be at least one path in the list.
	var paths: [HorizontalPath<RouterType>] {
		get {
			horizontalPaths
		}
		set {
			precondition(!newValue.isEmpty, "There must be at least one path to provide a root screen")
			horizontalPaths = newValue
		}
	}

	/// The horizontal paths hold as a private property.
	@Published private var horizontalPaths: [HorizontalPath<RouterType>]

	/// Returns the number of routes in the current horizontal path stack.
	/// 0 means there are no views pushed on top of the root.
	public var numberOfPushedViews: Int {
		paths[lastIndex].routes.count
	}

	/// A conventient accessor to get the index of the last path in the `paths` list.
	private var lastIndex: Int {
		precondition(!paths.isEmpty)
		return paths.count - 1
	}

	/// Initializes the router with a root view representation.
	public nonisolated init(root: RouterType) {
		// The presentation type for the root path is not important.
		_horizontalPaths = Published(initialValue: [HorizontalPath(root: root, presentationType: .fullScreen)])
	}

	// MARK: - Navigation

	/// Sets multiple routes at once replacing the current path.
	/// Will be animated only when one screen has been added or removed
	/// relative to the old state.
	/// - parameter routes: The routes which replaces the current path.
	/// Might also be empty.
	public func set(routes: RouterType...) {
		paths[lastIndex].routes = routes
	}

	/// Adds a new view to the horizontal path.
	/// Will be animated.
	/// - parameter route: The view representing route to push onto the navigation stack.
	public func push(_ route: RouterType) {
		paths[lastIndex].routes.append(route)
	}

	/// Removes the last view in the current horizontal path.
	/// Will be animated.
	/// Does nothing if there are no views pushed.
	public func pop() {
		guard !paths[lastIndex].routes.isEmpty else {
			return
		}
		paths[lastIndex].routes.removeLast()
	}

	/// Removes all views from the current horizontal path.
	/// This will not be animated.
	public func popToRoot() {
		paths[lastIndex].routes.removeAll()
	}

	/// Removes all views from the current horizontal path after the given index.
	/// Does nothing if the index is higher than the amount of routes in the list
	/// or when negative.
	/// Will be animated only if exactly one view has been popped.
	/// - parameter index: The index of the route from which all following routes will be removed.
	/// The index is 0 based while 0 indicates the first pushed screen.
	/// When also the first pushed screen should be popped, then use `popToRoot` instead.
	public func popAfter(index: Int) {
		let amountToRemove = paths[lastIndex].routes.count - 1 - index
		guard paths[lastIndex].routes.count > amountToRemove, amountToRemove > 0 else {
			return
		}
		paths[lastIndex].routes.removeLast(amountToRemove)
	}

	/**
	 Adds a new view to the vertical path which will be the root for the new horizontal path.
	 Will be animated.
	 - parameter route: The view representing route.
	 - parameter type: The type of vertical presentation, e.g. as a sheet or full-screen covering modal view.
	 */
	public func present(_ route: RouterType, type: PresentationType = .sheet) {
		let routerPath = HorizontalPath<RouterType>(root: route, presentationType: type)
		paths.append(routerPath)
	}

	/// Removes the top vertical path.
	/// Will be animated.
	/// Does nothing if there is only one path available
	/// which will be the root path and cannot be dismissed.
	public func dismiss() {
		guard paths.count > 1 else {
			return
		}
		paths.removeLast()
	}

	// MARK: - Consecutive steps

	/**
	 Executes consecutive transition steps.

	 Provides a possibility to concatinate multiple and different transitions.
	 In the `steps` closure multiple and different router calls can be executed.

	 However, the transition will not be necessarily animated when there is not
	 enough time passed between each call.
	 Therefore, after each transition step the background thread should sleep
	 before calling the next step.

	 For this the `RouterSleep` can be used and an individual sleep time
	 chosen depending on which previous step has been executed.

	 For example, to execute a pop and then a present and then a push:

	 ```
	 router.consecutiveSteps { router in
	   router.pop()
	   await RouterSleep.horizontal.sleep()
	   router.present(.route1)
	   await RouterSleep.vertical.sleep()
	   router.push(.route2)
	 }
	 ```

	 - warning: Keep in mind that it' i's not thread safe and not user-safe to execute
	 multiple transition steps.
	 While waiting for a transition being executed the user might interact with the app
	 which can cause unexpected side-effects when happening during the transaction sequence.
	 The app might also transition to screens via gestures which the router can't catch in advance.
	 Therefore, only use this method with caution.
	 */
	public nonisolated func consecutiveSteps(_ steps: @escaping @MainActor @Sendable (Router) async -> Void) {
		Task {
			await steps(self)
		}
	}

	// MARK: - Binding

	/**
	 Creates a binding for a vertical navigation by the router view.

	 The binding returns nil if there is no path for the corresponding index which
	 means the reflected view will be dismissed.
	 When there is a path then the corresponding view will be shown
	 so a info struct will be returned used by a `sheet` or `fullScreenCover` modifier.

	 - parameter index: The vertical index of the next level.
	 This binding is responsible to show or hide the path represnted by the index.
	 - returns: A new binding.
	 */
	func verticalBinding(index: Int) -> Binding<PresentationInfo?> {
		Binding<PresentationInfo?>(
			get: { [weak self] in
				guard let router = self, router.paths.count > index else {
					return nil
				}

				let newPath = router.paths[index]
				return PresentationInfo(
					index: index,
					presentationType: newPath.presentationType,
					onDismiss: { [weak router] in
						// Will be triggered when the user dismisses a sheet manually
						// by dragging it down in which case we have to update
						// the router stack manually to be in sync with the view hierarchy.
						router?.dismissAfter(index: index - 1)
					}
				)
			},
			set: { _ in }
		)
	}

	/// Removes all vertical paths after a given index.
	/// Usually this will cause visual glitches when dismissing multiple modal views,
	/// therefore, it's not part of the public interface.
	/// However, the binding needs to keep the paths in sync with
	/// the view hierarchy, so this is not to trigger a transition,
	/// but to update the state to be in sync.
	/// Does nothing if the index is higher than the amount of routes in the list
	/// or when negative.
	private func dismissAfter(index: Int) {
		let amountToRemove = paths.count - 1 - index
		guard paths.count > amountToRemove, amountToRemove > 0 else {
			return
		}
		paths.removeLast(amountToRemove)
	}
}

// MARK: - CustomStringConvertible

extension Router: CustomStringConvertible {
	public var description: String {
		"\(paths)"
	}
}
