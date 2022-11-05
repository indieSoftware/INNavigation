
# INNavigation

Provides an easy accessor which builds on top of SwiftUI's new `NavigationStack` introduced with iOS 16.

## Overview

`INNavigation` uses SwiftUI's `NavigationStack` for navigation. However, this library provides a `Router` which provides a common interface for navigation and handles the navigation via routes. For that a hierarchy is build up for horizontal and vertical navigation.

With horizontal navigation a push/pop navigation is meant, originally provided by a `UINavigationController` and in SwiftUI' `NavigationStack`.

A vertical navigation is realized with present/dismiss actions to show or dismiss sheets. Each vertical navigation automatically introduces a new layer for a horizontal navigation.

In addition to the routing management the routing system also supports custom navigation bars which stay on screen simulating a static navigation bar which, however, can change for each screen.

## Usage

### Route and Screen

First, next to each view definition, a screen must be defined which represents that view and acts as a factory for that view. For that a struct has to be defined which implements the `Screen` protocol.

It's not necessary, but recommended to place the screen definition in a `Route` extension. That eases the access later.

```
extension Route {
	struct View1Screen: Screen {
		let id: String = UUID().uuidString
		var contentView: AnyView { AnyView(View1()) }
		func navigationBar(namespaceId: Namespace.ID) -> AnyView? { 
			AnyView(View1NavBar(navBarNamespace: namespaceId))
		 }
	}

	static var view1: Route { Route(View1Screen()) }
}
```

In the above example the `View1Screen` represents the content view `View1`. The `navigationBar` method creates the custom navigation bar and the static computed property `view1` provides a computed property to return a `Route` for that screen.

It's also possible to pass any parameters to the view during initialization. Simply add some properties to the struct and use a static function instead of a static property for the route creation.

```
extension Route {
	struct ExampleViewScreen: Screen {
		let id: String = UUID().uuidString
		let title: String
		var contentView: AnyView { AnyView(ExampleView(title: title)) }
		func navigationBar(namespaceId _: Namespace.ID) -> AnyView? { nil }
		var hideSystemNavigationBar: Bool { false }
	}

	static func exampleView(title: String) -> Route { Route(ExampleViewScreen(title: title)) }
}
```

If a view should use the system's navigation bar instead of a custom one then simply pass `nil` as the `navigationBar` result.

The custom navigation bar as well as the content view are plain views, just embedded into `AnyView`s to pass them around.

However, for a custom navigation bar it might be interesting to inject the router reference via an `EnvironmentObject`. That can then be used to navigatie via custom buttons in the navigation bar.

The router uses a `Namespace` for animating the custom navigation bar. This namespace is passed to the screen's factory method so that it can pass it to the custom navigation bar view. The view can then use the namespace with `matchedGeometryEffect` modifiers to animate sub-views over different navigation bar views. This helps animating sub-views during transitioning the screens.

```
struct View1NavBar: View {
	@EnvironmentObject var router: Router
	let navBarNamespace: Namespace.ID

	var body: some View {
		ZStack {
			Color.green
				.matchedGeometryEffect(id: "background", in: navBarNamespace)
				.opacity(0.3)

			HStack {
				Button {
					router.pop()
				} label: {
					Image(systemName: "chevron.left")
						.matchedGeometryEffect(id: "leftButtonIcon", in: navBarNamespace)
						.frame(width: 45, height: 45)
				}
				Spacer()
			}

			Text("View 1 Title")
				.matchedGeometryEffect(id: "title", in: navBarNamespace)
		}
		.frame(height: 50)
	}
}
```

### RouterView

In the app's root view hierachy the `RouterView` has to be used.

```
import INNavigation
import SwiftUI

@main
struct NavigationTestApp: App {
	var body: some Scene {
		WindowGroup {
			RouterView()
				.environmentObject(Router(root: .exampleView(title: "Root")))
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

### Transition animations

SwiftUI's navigation doesn't provide a callback functionality to get informed when the transition animation has finished. 

As a workaround the `Router` will wait for an estimated time on a background thread. That allows to have async methods for `push`, `pop`, etc. which will last for as long as the corresponding transition takes. This also allows to concatenate multiple navigation steps, i.e. to first pop the top screen and then after the animation to push a different one.

```
Task {
	await router.pop()
	await router.push(.view2)
}
```

SwiftUI automatically blocks all interactions in a transitioning content view. However, the custom navigation bar is a view outside of the NavigationStack and thus is uneffected by that block. To prevent any routing during such a transition which might break the view hierarchy, the router automatically disables itself during a transition animation.
