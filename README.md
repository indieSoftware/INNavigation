
# INNavigation

Provides an easy accessor which builds on top of SwiftUI's new `NavigationStack` introduced with iOS 16.

## Overview

`INNavigation` uses SwiftUI's `NavigationStack` for navigation. However, this library provides a `Router` which provides a common interface for navigation and handles the navigation via routes. For that a hierarchy is build up for horizontal and vertical navigation.

With horizontal navigation a push/pop navigation is meant, originally provided by a `UINavigationController` and in SwiftUI' `NavigationStack`.

A vertical navigation is realized with present/dismiss actions to show or dismiss sheets. Each vertical navigation automatically introduces a new layer for a horizontal navigation.

## Usage

### Route

First a collection of possible routes has to be created. This can be achieved by introducing an enum which implemnets the `Route` protocol.

```
import INNavigation
import SwiftUI

enum ExampleRoute: Route {
	case exampleView(title: String)

	var view: some View {
		switch self {
		case let .exampleView(title):
			return ExampleView(title: title)
		}
	}
}
```

Here the `ExampleRoute` is defined with only one single route named `exampleView`. That means only one screen is defined, but more can be defined here.

The enum case has one associated value `title`. This is to show-case how to pass parameters to screens.

In the computed `view` property the concrete view is returned. Usually a view model might be also instantiated here which takes the `title` as the parameter instead.

### RouterView

In the app's root view hierachy the `RouterView` has to be used.

```
import INNavigation
import SwiftUI

@main
struct NavigationTestApp: App {
	var body: some Scene {
		WindowGroup {
			RouterView<ExampleRoute>()
				.environmentObject(Router<ExampleRoute>(root: .exampleView(title: "Root")))
		}
	}
}
```

The `RouterView` is responsible for providing any navigation code and enables to navigate horizontally or vertically to other screens via routes. Each new vertically layer will have such a `RouterView` as its root view so that each layer can use the router for navigation.

The type provided to the `RouterView` is the defined route, here `ExampleRoute`.

A new router instance has to be added as an environment object to the view hierarchy. This environment object is used by the `RouterView` to get notified about the routes.

However, to have also access to that `Router` instance in view models it's recommendable to create such an instance before injecting it as an environment object and then inject that same `Router` instance to any view models.

When instantiating the `Router` instance then provide the root route which will reflect which view to show as the root of the view hierarchy.

### Router

The `Router` instance can then be accessed in views when resolving it as an environment object.

```
struct ExampleView: View {
	@EnvironmentObject var router: Router<ExampleRoute>
	...
}
```

However, most of the time the instance should be injected into view models and used there to navigate to other screens.

When navigating to other screens simply use the `Router`'s methods, i.e.:

```
router.push(.exampleView(title: "Pushed"))
router.pop()
router.popToRoot()
router.popAfter(index: 1)
router.set(routes: .exampleView(title: "Route A"))

router.present(.exampleView(title: "Presented full-screen"), type: .fullScreen)
router.dismiss()
```

### Multi-step navigation

It's also possible to use multiple navigation steps. Some are already provided, however, they have to be executed asynchonously because the thread has to sleep in-between of the navigation steps. This is necessary to wait for the navigation animation to finish otherwise the animation will not be visible.

```
Task {
	await router.multiPopToRoot()
}
```
```
Task {
	await router.multiDismissToRoot()
}
```

It's also possible to create own custom multi-step navigations. For this the router's `consecutiveSteps` method can be used, i.e.:

```
router.consecutiveSteps { router in
	router.pop()
	await RoutingDirection.horizontal.sleep()
	router.present(.exampleView(title: "Presented"))
	await RoutingDirection.vertical.sleep()
	router.push(.exampleView(title: "Pushed"))
}
```

Just keep in mind to sleep between each step and be aware that different navigation transitions need a minimal delay time for the animation. So, after a horizontal navigation like push or pop a horizontal sleep time should be waited for. For vertical navigations like present and dismiss the vertical sleep time should be used accordingly.

