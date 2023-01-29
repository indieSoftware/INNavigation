import Combine
import INCommons
import SwiftUI

/// The router which provides a functional interface for the navigation between screens.
@MainActor
public class Router: ObservableObject, Sendable {
	/// The list of horizontal paths which makes this the vertical path.
	/// Whenever a new modal screen is shown a new path is added to this list.
	/// Each path in this array represents a horizontal path which reflects the
	/// views in a navigation stack so they can be pushed and popped on each level.
	/// There is always at least one path in this list which represents the root view.
	/// When setting a new path then there must be at least one path in the list.
	var paths: [HorizontalPath] {
		get {
			horizontalPaths
		}
		set {
			precondition(!newValue.isEmpty, "There must be at least one path to provide a root screen")
			horizontalPaths = newValue
		}
	}

	/// The horizontal paths hold as a private property.
	@Published private var horizontalPaths: [HorizontalPath]
    
    /// This is required because sometimes we need to update router view .
    @Published public var reRenderToggle: Bool = false

	/// A conventient accessor to get the index of the last path in the `paths` list.
	private var lastIndex: Int {
		precondition(!paths.isEmpty)
		return paths.count - 1
	}

	/// Returns the number of routes in the current horizontal path stack.
	/// 0 means there are no views pushed on top of the root.
	public var numberOfPushedViews: Int {
		paths[lastIndex].routes.count
	}

	/// Returns the number of routes in the current vertical path stack.
	/// There should always be at least one vertical path, that means the
	/// returned number is 1 or higher.
	public var numberOfPresentedViews: Int {
		paths.count
	}

	/// Only when true then the router will accept new transition calls, ignoring any when false.
	private var enabled: Bool = true

	/// Initializes the router with a root view representation.
	public nonisolated init(root: Route) {
		// The presentation type for the root path is not important.
		_horizontalPaths = Published(initialValue: [HorizontalPath(root: root, presentationType: .fullScreen)])
	}

	/// A helper which ensures that the router is enabled before applying the transition
	/// to the path via `task`, waiting for it to finish and re-enabling the router again.
	///
	/// - parameter direction: The transition direction which indicates for how
	/// long to block the router for additional transitions.
	/// - parameter task: The real path manipulation to apply.
	private nonisolated func transition(direction: RoutingDirection, task: @MainActor @Sendable () -> Void) async {
		let shouldContinue = await MainActor.run {
			guard enabled else { return false }
			enabled = false
			task()
			return true
		}
		guard shouldContinue else { return }
		await direction.sleep()
		await MainActor.run {
			enabled = true
		}
	}

	// MARK: - Horizontal Navigation

	/// Spawns a Task and runs the async method `set(routes:)`.
	public func set(routes: Route...) {
		Task {
			await set(routes: routes)
		}
	}

	/// Sets multiple routes at once replacing the current path.
	///
	/// Will be animated with a single push or pop when there is a difference in the
	/// route's count.
	///
	/// - parameter routes: The routes which replaces the current path.
	/// Might also be empty.
	public nonisolated func set(routes: Route...) async {
		await set(routes: routes)
	}

	/// Similar to `set(routes: Route...)`.
	public nonisolated func set(routes: [Route]) async {
		let shouldContinue = await MainActor.run {
			guard enabled else { return false }
			enabled = false
			let willBeAnimated = numberOfPushedViews == routes.count + 1 || numberOfPushedViews + 1 == routes.count
			applySet(routes: routes)
			if !willBeAnimated {
				enabled = true
			}
			return willBeAnimated
		}
		guard shouldContinue else { return }
		await RoutingDirection.horizontal.sleep()
		await MainActor.run {
			enabled = true
		}
	}

	func applySet(routes: [Route]) {
		paths[lastIndex].routes = routes
	}

	/// Spawns a Task and runs the async method `push(_:)`.
	public func push(_ route: Route) {
		Task {
			await push(route)
		}
	}

	/// Adds a new view to the horizontal path.
	///
	/// Will be animated and blocks the router for that time.
	///
	/// - parameter route: The view representing route to push onto the navigation stack.
	public nonisolated func push(_ route: Route) async {
		await transition(direction: .horizontal) {
			applyPush(route)
		}
	}

	func applyPush(_ route: Route) {
		paths[lastIndex].routes.append(route)
	}

	/// Spawns a Task and runs the async method `pop()`.
	public func pop() {
		Task {
			await pop()
		}
	}

	/// Removes the last view in the current horizontal path.
	///
	/// Will be animated and blocks the router for that time.
	/// Does nothing if there are no views pushed.
	public nonisolated func pop() async {
		await transition(direction: .horizontal) {
			applyPop()
		}
	}

	func applyPop() {
		guard numberOfPushedViews > 0 else { return }
		paths[lastIndex].routes.removeLast()
	}

	/// Spawns a Task and runs the async method `popToRoot()`.
	public func popToRoot() {
		Task {
			await popToRoot()
		}
	}

	/// Removes all views from the current horizontal path.
	/// This will only be animated when there is only one single view in the view hierarchy.
	public nonisolated func popToRoot() async {
		let willBeAnimated = await MainActor.run {
			numberOfPushedViews == 1
		}
		await transition(direction: willBeAnimated ? .horizontal : .none) {
			applyPopToRoot()
		}
	}

	func applyPopToRoot() {
		paths[lastIndex].routes.removeAll()
	}

	/// Spawns a Task and runs the async method `popAfter(index:)`.
	public func popAfter(index: Int) {
		Task {
			await popAfter(index: index)
		}
	}

	/// Removes all views from the current horizontal path after the given index.
	///
	/// Does nothing if the index is higher than the amount of routes in the list
	/// or when negative.
	///
	/// Will be animated only if exactly one view has been popped.
	///
	/// - parameter index: The index of the route from which all following routes will be removed.
	/// The index is 0 based with 0 pointing to the root view and thus 1 represents the first pushed screen.
	/// Using an index of 0 does the same as `popToRoot`.
	public nonisolated func popAfter(index: Int) async {
		let willBeAnimated = await MainActor.run {
			numberOfPushedViews - index == 1
		}
		await transition(direction: willBeAnimated ? .horizontal : .none) {
			applyPopAfter(index: index)
		}
	}

	func applyPopAfter(index: Int) {
		let amountToRemove = numberOfPushedViews - index
		guard numberOfPushedViews >= amountToRemove, amountToRemove > 0 else {
			return
		}
		paths[lastIndex].routes.removeLast(amountToRemove)
	}

	// MARK: - Vertical Navigation

	/// Spawns a Task and runs the async method `present(_:type:)`.
	public func present(_ route: Route, type: PresentationType = .sheet) {
		Task {
			await present(route, type: type)
		}
	}

	/// Adds a new view to the vertical path which will be the root for the new horizontal path.
	///
	/// Will be animated and blocks the router for that time.
	///
	/// - parameter route: The view representing route.
	/// - parameter type: The type of vertical presentation, e.g. as a sheet or full-screen covering modal view.
	public nonisolated func present(_ route: Route, type: PresentationType = .sheet) async {
		await transition(direction: .vertical) {
			applyPresent(route, type: type)
		}
	}

	func applyPresent(_ route: Route, type: PresentationType = .sheet) {
		let routerPath = HorizontalPath(root: route, presentationType: type)
		paths.append(routerPath)
	}

	/// Spawns a Task and runs the async method `dismiss()`.
	public func dismiss() {
		Task {
			await dismiss()
		}
	}

	/// Removes the top vertical path.
	/// Will be animated.
	/// Does nothing if there is only one path available
	/// which will be the root path and cannot be dismissed.
	public nonisolated func dismiss() async {
		await transition(direction: .vertical) {
			applyDismiss()
		}
	}

	func applyDismiss() {
		guard numberOfPresentedViews > 1 else { return }
		paths.removeLast()
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
						router?.applyDismissAfter(index: index - 1)
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
	private func applyDismissAfter(index: Int) {
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
