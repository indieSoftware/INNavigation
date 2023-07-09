# Usage

## Screen

First, next to each view definition, a screen must be defined which represents that view and acts as a factory for that view. For that a struct has to be defined which implements the `Screen` protocol.

```
@MainActor
struct View1Screen: Screen {
	let id: String = UUID().uuidString
	var contentView: AnyView { AnyView(View1()) }
	func navigationBar(namespaceId: Namespace.ID) -> AnyView? { 
		AnyView(View1NavBar(navBarNamespace: namespaceId))
	 }
}
```

Each screen instance needs its own ID to differentiate it from other screens by the router. Usually a UUID string should be enough.

The `contentView` acts as the factory to create the real view. The view has to be wrapped by `AnyView`.

To implement the `navigationBar` method is optional. When not implemented then nil will be automatically returned which means the view will not provide a custom navigation bar. However, if a custom navigation bar should be supported then return the view back again wrapped by `AnyView`.

A screen also supports an optional overlay view. To provide such an overlay simply implement the `overlayView` method similar to `navigationBar`. If no overlay is needed then simply drop it.

The screen struct can also be used to pass a parameter from one screen to another. Or it can hold a reference to the view model to re-use it for the content view and for the navigation bar:

```
@MainActor
struct View2Screen: Screen {
	let id: String = UUID().uuidString
	let viewModel: ViewModel2

	init(parameter: Int) {
		viewModel = ViewModel2(parameter: parameter)
	}

	var contentView: AnyView { AnyView(View2(viewModel: viewModel)) }
	func navigationBar(namespaceId: Namespace.ID) -> AnyView? { AnyView(View2NavBar(viewModel: viewModel, navBarNamespace: namespaceId))
	}
	func overlayView() -> AnyView? {
		AnyView(OverlayView2(viewModel: viewModel))
	}
}
```

In this example view2 needs a parameter passed by the previous screen. And two screens need to use the same view model. That's why the view model is created with the passed parameter during the init method of the screen and it will be passed to the corresponding views.

## Route

It's not necessary, but recommended to provide an easy accessor to the route in a `Route` extension:

```
extension Route {
	@MainActor
	static var view1: Route { Route(View1Screen()) }
}
```

When passing parameters is necessary then use a function instead of a computed property:

```
extension Route {
	@MainActor	
	static func view2(parameter: Int) -> Route {
		Route(View2Screen(parameter: parameter))
	}
}
```

## View

The content view is a typical common view, so nothing special needs to be taken care here.

However, since the view is managed by a RouterView the `Router` gets automatically injected as an `EnvironmentObject`. Therefore, it's possible for a view to access the router to trigger navigations from within the view itself without relying on a view model:

```
struct View1: View {
	@EnvironmentObject var router: Router

	var body: some View {
		Button {
			router.push(.view1)
		} label: {
			Text("Push View1")
		}
	}	
}
```

However, this approach is not recommended. Instead use view models and inject the router to the view model and let the view model decide if and where to navigate to. However, this needs a dependency injection system to inject the router instance into the view model.

Any navigation bar or overlay works similarly to the content view. They are individual views in the view hierarchy which also get the router injected as an `EnvironmentObject` if necessary.

The router uses a `Namespace` for animating the custom navigation bar. This namespace is passed to the screen's factory method so that it can pass it further down to the custom navigation bar view. The navigation bar view can then use the namespace with `matchedGeometryEffect` modifiers to animate sub-views over different navigation bar views. This helps animating sub-views during transitioning the screens.

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

## RouterView

In the app's root view hierachy the `RouterView` has to be used.

```
import INNavigation
import SwiftUI

@main
struct NavigationTestApp: App {
	static let router = Router(root: .exampleView(title: "Root"))

	var body: some Scene {
		WindowGroup {
			RouterView()
				.environmentObject(Self.router)
		}
	}
}
```

The router instance doesn't need to be kept in a static variable, but it has to be injected to the view hierarchy as an `environmentObject` because the `RouterView` will need it to get notified about routes. 

However, to have also access to that `Router` instance in view models it's recommendable to create such an instance before injecting it as an environment object and then inject that same `Router` instance to any view models via a dependency injection system.

The `RouterView` is responsible for providing any navigation code and enables to navigate horizontally or vertically to other screens via routes. Each new vertically layer will have such a `RouterView` as its root view so that each layer can use the router for navigation.

When instantiating the `Router` instance then provide the root route which will reflect which view to show as the root of the view hierarchy. This is already a route.

## Router

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

## Transition animations

SwiftUI's navigation doesn't provide a callback functionality to get informed when the transition animation has finished. 

As a workaround the `Router` will wait for an estimated time on a background thread. That allows to have async methods for `push`, `pop`, etc. which will last for as long as the corresponding transition takes. This also allows to concatenate multiple navigation steps, i.e. to first pop the top screen and then after the animation to push a different one.

```
Task {
	await router.pop()
	await router.push(.view2)
}
```

SwiftUI automatically blocks all interactions in a transitioning content view. However, the custom navigation bar is a view outside of the NavigationStack and thus is uneffected by that blocking behavior. To prevent any routing during such a transition which might break the view hierarchy, the router automatically disables itself during a transition animation.

Keep in mind that the delay for waiting for the animation is time based. Therefore, when enabling "Slow Animations" in the simulator then the animation will take longer than the delay and when interacting with the router after the delay, but before the slow animation has finished then this might break the routing system and the display of the view.
