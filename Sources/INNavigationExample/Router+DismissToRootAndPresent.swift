import INNavigation

extension Router {
	/// Dismisses all vertical paths each after another animated and then presents a new route.
	func dismissToRootAndPresent(_ route: Route, type: PresentationType) {
		Task {
			await dismissToRootAndPresent(route, type: type)
		}
	}

	/// Dismisses all vertical paths each after another animated and then presents a new route.
	nonisolated func dismissToRootAndPresent(_ route: Route, type: PresentationType) async {
		await multiDismissToRoot()
		await present(route, type: type)
	}
}
