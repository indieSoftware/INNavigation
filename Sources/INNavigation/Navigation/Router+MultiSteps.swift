public extension Router {
	/// Performs multiple pop calls and waits between each step to have them animated.
	func multiPopToRoot() async {
		guard !paths.isEmpty else { return }

		let lastIndex = paths.count - 1
		let numberOfPaths = paths[lastIndex].routes.count
		guard numberOfPaths > 0 else {
			return
		}

		for _ in 0 ..< numberOfPaths {
			pop()
			await RouterSleep.horizontal.sleep()
		}
	}

	/// Removes all vertical paths one after another animated.
	func multiDismissToRoot() async {
		let numberOfPaths = paths.count
		guard numberOfPaths > 1 else {
			return
		}

		for _ in 1 ..< numberOfPaths {
			dismiss()
			await RouterSleep.vertical.sleep()
		}
	}

	/// Dismisses all vertical paths each after another animated and then presents a new route.
	func dismissToRootAndPresent(_ route: RouterType, type: PresentationType) async {
		await multiDismissToRoot()
		present(route, type: type)
		await RouterSleep.vertical.sleep()
	}
}
